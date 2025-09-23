#!/bin/sh

# update for any release using
curl -kLO https://github.com/open-traffic-generator/ixia-c/releases/download/v1.38.0-1/versions.yaml
VERSIONS_YAML="versions.yaml"
CTRL_IMAGE="ghcr.io/open-traffic-generator/keng-controller"
TE_IMAGE="ghcr.io/open-traffic-generator/ixia-c-traffic-engine"
PE_IMAGE="ghcr.io/open-traffic-generator/ixia-c-protocol-engine"

TIMEOUT_SECONDS=300

# --- Argument parsing for ETH_A and ETH_Z ---
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "usage: $0 <eth_A> <eth_Z> <function> [args...]"
    exit 1
fi

ETH_A=$1
ETH_Z=$2
shift 2

configq() {
    # echo is needed to further evaluate the 
    # contents extracted from configuration
    eval echo $(yq "${@}" versions.yaml)
}

push_ifc_to_container() {
    # It takes a host NIC (say eth1) and injects it into a container’s 
    # network namespace so the container can directly use that NIC (bypassing Docker’s default bridge). 
    # It symlinks the container’s netns into /var/run/netns, 
    # then moves and configures the interface inside that namespace.
    if [ -z "${1}" ] || [ -z "${2}" ]
    then
        echo "usage: ${0} push_ifc_to_container <ifc-name> <container-name>"
        exit 1
    fi

    # Resolve container metadata
    cid=$(container_id ${2})
    cpid=$(container_pid ${2})

    echo "Changing namespace of ifc ${1} to container ID ${cid} pid ${cpid}"

    # Prepare namespace paths
    orgPath=/proc/${cpid}/ns/net
    newPath=/var/run/netns/${cid}
    
    # Make namespace accessible to ip netns 
    # Move interface into the container’s netns
    # Rename and configure inside the container
    sudo mkdir -p /var/run/netns
    echo "Creating symlink ${orgPath} -> ${newPath}"
    sudo ln -s ${orgPath} ${newPath} \
    && sudo ip link set ${1} netns ${cid} \
    && sudo ip netns exec ${cid} ip link set ${1} name ${1} \
    && sudo ip netns exec ${cid} ip -4 addr add 0/0 dev ${1} \
    && sudo ip netns exec ${cid} ip -4 link set ${1} up \
    && echo "Successfully changed namespace of ifc ${1}"

    sudo rm -rf ${newPath}
}

container_id() {
    docker inspect --format="{{json .Id}}" ${1} | cut -d\" -f 2
}

container_pid() {
    docker inspect --format="{{json .State.Pid}}" ${1} | cut -d\" -f 2
}

container_ip() {
    docker inspect --format="{{json .NetworkSettings.IPAddress}}" ${1} | cut -d\" -f 2
}

ixia_c_img_tag() {
    tag=$(grep ${1} ${VERSIONS_YAML} | cut -d: -f2 | cut -d\  -f2)
    echo "${tag}"
}

ixia_c_traffic_engine_img() {
    echo "${TE_IMAGE}:$(ixia_c_img_tag ixia-c-traffic-engine)"
}

ixia_c_protocol_engine_img() {
    echo "${PE_IMAGE}:$(ixia_c_img_tag ixia-c-protocol-engine)"
}

keng_controller_img() {
    echo "${CTRL_IMAGE}:$(ixia_c_img_tag keng-controller)"
}

gen_controller_config_b2b_cpdp() {
    configdir=/home/ixia-c/controller/config
    OTG_PORTA=$(container_ip ixia-c-traffic-engine-${ETH_A})
    OTG_PORTZ=$(container_ip ixia-c-traffic-engine-${ETH_Z})
    
    wait_for_sock ${OTG_PORTA} 5555
    wait_for_sock ${OTG_PORTA} 50071
    wait_for_sock ${OTG_PORTZ} 5555
    wait_for_sock ${OTG_PORTZ} 50071

    yml="location_map:
          - location: ${ETH_A}
            endpoint: \"${OTG_PORTA}:5555+${OTG_PORTA}:50071\"
          - location: ${ETH_Z}
            endpoint: \"${OTG_PORTZ}:5555+${OTG_PORTZ}:50071\"
        "
    echo -n "$yml" | sed "s/^        //g" | tee ./config.yaml > /dev/null \
    && docker exec keng-controller mkdir -p ${configdir} \
    && docker cp ./config.yaml keng-controller:${configdir}/ \
    && rm -rf ./config.yaml
}

wait_for_sock() {
    TIMEOUT_SECONDS=30
    if [ ! -z "${3}" ]
    then
        TIMEOUT_SECONDS=${3}
    fi
    echo "Waiting for ${1}:${2} to be ready (timeout=${TIMEOUT_SECONDS}s)..."
    elapsed=0
    TIMEOUT_SECONDS=$(($TIMEOUT_SECONDS * 10))
    while true
    do
        nc -z -v ${1} ${2} && return 0

        elapsed=$(($elapsed+1))
        # echo "Timeout: $TIMEOUT_SECONDS"
        # echo "elapsed time: $elapsed"

        if [ $elapsed -gt ${TIMEOUT_SECONDS} ]
        then
            echo "${1}:${2} to be ready after ${TIMEOUT_SECONDS}"
            exit 1
        fi
        sleep 0.1
    done

}

prepare_eth_pair() {
    if [ -z "${1}" ] || [ -z "${2}" ]
    then
        echo "usage: ${0} create_veth_pair <name1> <name2>"
        exit 1
    fi

    sudo ip link set ${1} up \
    && sudo ip link set ${1} promisc on \
    && sudo ip link set ${2} up \
    && sudo ip link set ${2} promisc on
}

create_ixia_c_b2b_cpdp() {
    docker ps -a
    echo "Setting up back-to-back with CP/DP distribution of ixia-c ..."
    docker run -d                                        \
    --name=keng-controller                              \
    --publish 0.0.0.0:8443:8443                         \
    --publish 0.0.0.0:40051:40051                       \
    $(keng_controller_img)                              \
    --accept-eula                                       \
    --trace                                             \
    --disable-app-usage-reporter
    docker run --privileged -d                           \
        --name=ixia-c-traffic-engine-${ETH_A}              \
        -e OPT_LISTEN_PORT="5555"                           \
        -e ARG_IFACE_LIST="virtual@af_packet,${ETH_A}"     \
        -e OPT_NO_HUGEPAGES="Yes"                           \
        -e OPT_NO_PINNING="Yes"                             \
        -e WAIT_FOR_IFACE="Yes"                             \
        -e OPT_ADAPTIVE_CPU_USAGE="Yes"                              \
        $(ixia_c_traffic_engine_img)                        \
    && docker run --privileged -d                           \
        --net=container:ixia-c-traffic-engine-${ETH_A}     \
        --name=ixia-c-protocol-engine-${ETH_A}             \
        -e INTF_LIST="${ETH_A}"                            \
        $(ixia_c_protocol_engine_img)                       \
    && docker run --privileged -d                           \
        --name=ixia-c-traffic-engine-${ETH_Z}              \
        -e OPT_LISTEN_PORT="5555"                           \
        -e ARG_IFACE_LIST="virtual@af_packet,${ETH_Z}"     \
        -e OPT_NO_HUGEPAGES="Yes"                           \
        -e OPT_NO_PINNING="Yes"                             \
        -e WAIT_FOR_IFACE="Yes"                             \
        -e OPT_ADAPTIVE_CPU_USAGE="Yes"                              \
        $(ixia_c_traffic_engine_img)                        \
    && docker run --privileged -d                           \
        --net=container:ixia-c-traffic-engine-${ETH_Z}     \
        --name=ixia-c-protocol-engine-${ETH_Z}             \
        -e INTF_LIST="${ETH_Z}"                            \
        $(ixia_c_protocol_engine_img)                       \
    && docker ps -a                                         \
    && prepare_eth_pair ${ETH_A} ${ETH_Z}                 \
    && push_ifc_to_container ${ETH_A} ixia-c-traffic-engine-${ETH_A}  \
    && push_ifc_to_container ${ETH_Z} ixia-c-traffic-engine-${ETH_Z}  \
    && gen_controller_config_b2b_cpdp $1                     \                         \
    && docker ps -a \
    && echo "Successfully deployed !"
}

rm_ixia_c_b2b_cpdp() {
    docker ps -a
    echo "Tearing down back-to-back with CP/DP distribution of ixia-c ..."
    docker stop keng-controller && docker rm keng-controller

    docker stop ixia-c-traffic-engine-${ETH_A}
    docker stop ixia-c-protocol-engine-${ETH_A}
    docker rm ixia-c-traffic-engine-${ETH_A}
    docker rm ixia-c-protocol-engine-${ETH_A}

    docker stop ixia-c-traffic-engine-${ETH_Z}
    docker stop ixia-c-protocol-engine-${ETH_Z}
    docker rm ixia-c-traffic-engine-${ETH_Z}
    docker rm ixia-c-protocol-engine-${ETH_Z}

    docker ps -a
}

topo() {
    case $1 in
        new )  
            create_ixia_c_b2b_cpdp      
        ;;
        rm  )
            rm_ixia_c_b2b_cpdp
        ;;
        *   )
            exit 1
        ;;
    esac
}


help() {
    grep "() {" ${0} | cut -d\  -f1
}

usage() {
    echo "usage: $0 [name of any function in script]"
    exit 1
}

case $1 in
    *   )
        cmd=${1}
        shift 1
        ${cmd} "$@" || usage
    ;;
esac

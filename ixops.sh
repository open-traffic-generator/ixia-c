#!/bin/sh

# This file contains paths pointing to some binaries whose paths
# may not already be known to current shell, hence source it before execution
DOT_PROFILE="${HOME}/.profile"
. ${DOT_PROFILE}
# This file contains configurables like versions of certain tools, container images,
# flags, etc.
CONFIG_YAML=$(pwd)/deployments/config.yaml
# This file contains all the stdout and stderr generated during
# execution; the new contents are appended everytime script is executed
IXOPS_LOG=$(pwd)/ixops.log

DOT_KUBE="${HOME}/.kube"
DOCKER_CONFIG="${HOME}/.docker/config.json"

GO_RELEASE="1.20.4"
GO_SOURCE="https://dl.google.com/go/go${GO_RELEASE}.linux-amd64.tar.gz"
YQ_RELEASE="v4.33.3"
YQ_SOURCE="github.com/mikefarah/yq/v4@${YQ_RELEASE}"

# update for any release using
# curl -kLO https://github.com/open-traffic-generator/ixia-c/releases/download/v0.0.1-2994/versions.yaml
VERSIONS_YAML="versions.yaml"
VETH_A="veth-a"
VETH_Z="veth-z"
# additional member ports for LAG
VETH_B="veth-b"
VETH_C="veth-c"
VETH_X="veth-x"
VETH_Y="veth-y"

NOKIA_SRL_OPERATOR_VERSION="0.4.6"
NOKIA_SRL_OPERATOR_YAML="https://github.com/srl-labs/srl-controller/config/default?ref=v${NOKIA_SRL_OPERATOR_VERSION}"
ARISTA_CEOS_VERSION="4.29.1F-29233963"
ARISTA_CEOS_IMAGE="ghcr.io/open-traffic-generator/ceos"

OPENCONFIG_MODELS_REPO=https://github.com/openconfig/public.git
OPENCONFIG_MODELS_COMMIT=5ca6a36

APT_UPDATE=true

configq() {
    # echo is needed to further evaluate the 
    # contents extracted from configuration
    eval echo $(yq "${@}" ${CONFIG_YAML})
}

check_cmd() {
    eval "${@}" >> "${IXOPS_LOG}" 2>&1
}

get_seconds() {
    date +%s
}

apt_update() {
    if [ "${APT_UPDATE}" = "true" ]
    then
        check_cmd DEBIAN_FRONTEND=noninteractive sudo apt-get update -yq --no-install-recommends
        APT_UPDATE=false
    fi
}

apt_install() {
    log "Installing ${@} ..."
    apt_update \
    && check_cmd DEBIAN_FRONTEND=noninteractive sudo apt-get install -yq --no-install-recommends ${@} \
    && log "Successfully installed ${@}"
}

apt_install_curl() {
    check_cmd curl --version && return
    apt_install curl
}

apt_install_vim() {
    check_cmd dpkg -s vim && return
    apt_install vim
}

apt_install_git() {
    check_cmd git version && return
    apt_install git
}

apt_install_gnupg() {
    check_cmd gpg -k && return
    apt_install gnupg
}

apt_install_ca_certs() {
    check_cmd dpkg -s ca-certificates && return
    apt_install gnupg ca-certificates
}

apt_install_pkgs() {
    apt_install_curl \
    && apt_install_vim \
    && apt_install_git \
    && apt_install_gnupg \
    && apt_install_ca_certs
}

check_docker_release() {
    log "Checking docker installation ..."
    check_cmd which docker || return 1
    log "Checking docker release ..."
    docker -v | grep " ${1}," || return 1
}

rm_docker() {
    log "Removing any existing docker installation ..."
    check_cmd sudo apt-get remove -y docker docker-engine docker.io containerd runc docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo rm -rf /etc/apt/sources.list.d/docker.list
    sudo rm -rf /etc/apt/keyrings/docker.gpg
}

setup_docker() {
    check_docker_release $(configq .releases.docker) && return
    rm_docker
    
    log "Installing docker $(configq .releases.docker) ..."
    # install docker and other tools per https://docs.docker.com/engine/install/ubuntu/
    sudo install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && sudo chmod a+r /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    log "Checking whether intended version is available for install ..."
    APT_UPDATE=true
    apt_update
    version=$(apt-cache madison docker-ce | awk '{ print $3 }' | grep $(configq .releases.docker))
    log "Found ${version}"
    wrn "Please execute 'systemctl restart docker' if docker service cannot be reached post installation !"
    apt_install docker-ce=${version} docker-ce-cli=${version} containerd.io docker-buildx-plugin docker-compose-plugin
}

sudo_docker() {
    groups | grep docker > /dev/null 2>&1 && return
    sudo groupadd docker
    sudo usermod -aG docker $USER

    sudo docker version
    wrn "Please logout, login again and re-execute previous command"
    exit 0
}

get_docker() {
    log "Getting docker ..."
    setup_docker \
    && sudo_docker
}

common_install() {
    apt_install_pkgs \
    && get_go \
    && get_yq
}

create_veth_pair() {
    if [ -z "${1}" ] || [ -z "${2}" ]
    then
        echo "usage: ${0} create_veth_pair <name1> <name2>"
        exit 1
    fi
    sudo ip link add ${1} type veth peer name ${2} \
    && sudo ip link set ${1} up \
    && sudo ip link set ${2} up
}

rm_veth_pair() {
    if [ -z "${1}" ] || [ -z "${2}" ]
    then
        echo "usage: ${0} rm_veth_pair <name1> <name2>"
        exit 1
    fi
    sudo ip link delete ${1}
}

ipv6_enable_docker() {
    echo "{\"ipv6\": true, \"fixed-cidr-v6\": \"2001:db8:1::/64\"}" | sudo tee /etc/docker/daemon.json
    echo "$(sudo systemctl restart docker)"
}

push_ifc_to_container() {
    if [ -z "${1}" ] || [ -z "${2}" ]
    then
        echo "usage: ${0} push_ifc_to_container <ifc-name> <container-name>"
        exit 1
    fi

    cid=$(container_id ${2})
    cpid=$(container_pid ${2})
    echo "Changing namespace of ifc ${1} to container ID ${cid} pid ${cpid}"
    orgPath=/proc/${cpid}/ns/net
    newPath=/var/run/netns/${cid}
    
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

container_ip6() {
    docker inspect --format="{{json .NetworkSettings.GlobalIPv6Address}}" ${1} | cut -d\" -f 2
}

ixia_c_img() {
    path=$(grep -A 2 ${1} ${VERSIONS_YAML} | grep path | cut -d: -f2 | cut -d\  -f2)
    tag=$(grep -A 2 ${1} ${VERSIONS_YAML} | grep tag | cut -d: -f2 | cut -d\  -f2)
    echo "${path}:${tag}"
}

ixia_c_traffic_engine_img() {
    ixia_c_img traffic-engine
}

ixia_c_protocol_engine_img() {
    ixia_c_img protocol-engine
}

ixia_c_controller_img() {
    case $1 in
        dp  )
            ixia_c_img controller-dp
        ;;
        cpdp)
            ixia_c_img controller-cpdp
        ;;
        *   )
            echo "unsupported image type: ${1}"
            exit 1
        ;;
    esac
}

login_ghcr() {
    log "Checking if ghcr.io login is needed ..."
    if [ -f "${DOCKER_CONFIG}" ]
    then
        check_cmd grep ghcr.io "${DOCKER_CONFIG}" && log "Already logged into ghcr.io" && return
    fi

    log "Not logged into ghcr.io, attempting login ..."
    if [ -z "${GITHUB_USER}" ] || [ -z "${GITHUB_PAT}" ]
    then
        wrn "Need to manually log into ghcr.io (Please provide Github Username and PAT)"
        docker login ghcr.io || err_exit "Could not login to ghcr.io" 1
    else
        log "Logging into ghcr.io using credentials provided in config.yaml"
        echo "${GITHUB_PAT}" | docker login -u"${GITHUB_USER}" --password-stdin ghcr.io
    fi
    log "Successfully logged into ghcr.io !"
}

logout_ghcr() {
    log "Logging out of ghcr.io ..."
    docker logout ghcr.io
}

gen_controller_config_b2b_dp() {
    configdir=/home/ixia-c/controller/config

    wait_for_sock localhost 5555
    wait_for_sock localhost 5556

    yml="location_map:
          - location: ${VETH_A}
            endpoint: localhost:5555
          - location: ${VETH_Z}
            endpoint: localhost:5556
        "
    echo -n "$yml" | sed "s/^        //g" | tee ./config.yaml > /dev/null \
    && docker exec ixia-c-controller mkdir -p ${configdir} \
    && docker cp ./config.yaml ixia-c-controller:${configdir}/ \
    && rm -rf ./config.yaml
}

gen_controller_config_b2b_cpdp() {
    configdir=/home/ixia-c/controller/config
    if [ "${1}" = "ipv6" ]
    then 
        OTG_PORTA=$(container_ip6 ixia-c-traffic-engine-${VETH_A})
        OTG_PORTZ=$(container_ip6 ixia-c-traffic-engine-${VETH_Z})
    else
        OTG_PORTA=$(container_ip ixia-c-traffic-engine-${VETH_A})
        OTG_PORTZ=$(container_ip ixia-c-traffic-engine-${VETH_Z})
    fi

    wait_for_sock ${OTG_PORTA} 5555
    wait_for_sock ${OTG_PORTA} 50071
    wait_for_sock ${OTG_PORTZ} 5555
    wait_for_sock ${OTG_PORTZ} 50071

    if [ "${1}" = "ipv6" ]
    then 
        OTG_PORTA="[${OTG_PORTA}]"
        OTG_PORTZ="[${OTG_PORTZ}]"
    fi

    yml="location_map:
          - location: ${VETH_A}
            endpoint: \"${OTG_PORTA}:5555+${OTG_PORTA}:50071\"
          - location: ${VETH_Z}
            endpoint: \"${OTG_PORTZ}:5555+${OTG_PORTZ}:50071\"
        "
    echo -n "$yml" | sed "s/^        //g" | tee ./config.yaml > /dev/null \
    && docker exec ixia-c-controller mkdir -p ${configdir} \
    && docker cp ./config.yaml ixia-c-controller:${configdir}/ \
    && rm -rf ./config.yaml
}

gen_controller_config_b2b_lag() {
    configdir=/home/ixia-c/controller/config
    OTG_PORTA=$(container_ip ixia-c-traffic-engine-${VETH_A})
    OTG_PORTZ=$(container_ip ixia-c-traffic-engine-${VETH_Z})

    wait_for_sock ${OTG_PORTA} 5555
    wait_for_sock ${OTG_PORTA} 50071
    wait_for_sock ${OTG_PORTZ} 5555
    wait_for_sock ${OTG_PORTZ} 50071

    yml="location_map:
          - location: ${VETH_A}
            endpoint: ${OTG_PORTA}:5555;1+${OTG_PORTA}:50071
          - location: ${VETH_B}
            endpoint: ${OTG_PORTA}:5555;2+${OTG_PORTA}:50071
          - location: ${VETH_C}
            endpoint: ${OTG_PORTA}:5555;3+${OTG_PORTA}:50071
          - location: ${VETH_Z}
            endpoint: ${OTG_PORTZ}:5555;1+${OTG_PORTZ}:50071
          - location: ${VETH_Y}
            endpoint: ${OTG_PORTZ}:5555;2+${OTG_PORTZ}:50071
          - location: ${VETH_X}
            endpoint: ${OTG_PORTZ}:5555;3+${OTG_PORTZ}:50071
        "
    echo -n "$yml" | sed "s/^        //g" | tee ./config.yaml > /dev/null \
    && docker exec ixia-c-controller mkdir -p ${configdir} \
    && docker cp ./config.yaml ixia-c-controller:${configdir}/ \
    && rm -rf ./config.yaml
}

gen_config_common() {
    location=localhost
    if [ "${1}" = "ipv6" ]
    then 
        location="[$(container_ip6 ixia-c-controller)]"
    fi

    yml="otg_speed: speed_1_gbps
        otg_capture_check: true
        otg_iterations: 100
        otg_grpc_transport: false
        "
    echo -n "$yml" | sed "s/^        //g" | tee -a ./test-config.yaml > /dev/null
}

gen_config_b2b_dp() {
    yml="otg_host: https://localhost:8443
        otg_ports:
          - ${VETH_A}
          - ${VETH_Z}
        "
    echo -n "$yml" | sed "s/^        //g" | tee ./test-config.yaml > /dev/null

    gen_config_common 
}

gen_config_b2b_cpdp() {
    yml="otg_host: https://localhost:8443
        otg_ports:
          - ${VETH_A}
          - ${VETH_Z}
        "
    echo -n "$yml" | sed "s/^        //g" | tee ./test-config.yaml > /dev/null

    gen_config_common $1
}

gen_config_b2b_lag() {
    yml="otg_host: https://localhost:8443
        otg_ports:
          - ${VETH_A}
          - ${VETH_B}
          - ${VETH_C}
          - ${VETH_Z}
          - ${VETH_Y}
          - ${VETH_X}
        "
    echo -n "$yml" | sed "s/^        //g" | tee ./test-config.yaml > /dev/null

    gen_config_common
}

gen_config_kne() {
    OTG_ADDR=$(kubectl get service -n ixia-c service-https-otg-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    
    topo=$(kne_topo_file ${1} ${2})
    yml="        otg_ports:\n"
    for p in $(grep "_node: otg" ${topo} -A 1 | grep _int | sed s/\\s//g)
    do
        yml="${yml}          - $(echo ${p} | cut -d: -f2)\n"
    done
    if [ ! -z "${2}" ]
    then
        yml="${yml}        dut_configs:\n"

        DUT_ADDR=$(kubectl get service -n ixia-c service-dut -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
        yml="${yml}          - name: dut\n"
        yml="${yml}            host: ${DUT_ADDR}\n"
        
        SSH_PORT=$(grep "\- name: dut" -A 30 ${topo} | grep -m 1 services -A 10 | grep 'name: ssh' -B 1 | head -n 1 | tr -d ' :')
        yml="${yml}            ssh_username: admin\n"
        # yml="${yml}            ssh_password: admin\n"
        yml="${yml}            ssh_port: ${SSH_PORT}\n"

        GNMI_PORT=$(grep "\- name: dut" -A 30 ${topo} | grep -m 1 services -A 10 | grep 'name: gnmi' -B 1 | head -n 1 | tr -d ' :')
        yml="${yml}            gnmi_username: admin\n"
        yml="${yml}            gnmi_password: admin\n"
        yml="${yml}            gnmi_port: ${GNMI_PORT}\n"
        yml="${yml}            interfaces:\n"
        for i in $(kne topology service ${topo} | grep interfaces -A 8 | grep -E 'peer_name:\s+\"otg' -A 3 -B 5 | grep ' name:'| tr -d ' ')
        do
            ifc=$(echo $i | cut -d\" -f2)
            yml="${yml}              - ${ifc}\n"
        done

        wait_for_sock ${DUT_ADDR} ${GNMI_PORT}
        wait_for_sock ${DUT_ADDR} ${SSH_PORT}
    fi

    yml="otg_host: https://${OTG_ADDR}:8443\n${yml}"
    echo -n "$yml" | sed "s/^        //g" | tee ./test-config.yaml > /dev/null

    gen_config_common
}

gen_config_k8s() {
    ADDR=$(kubectl get service -n ixia-c service-otg-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    ETH1=$(grep "location:" deployments/k8s/manifests/${1}.yaml -m 2 | head -n1 | cut -d\: -f2 | cut -d\  -f2)
    ETH2=$(grep "location:" deployments/k8s/manifests/${1}.yaml -m 2 | tail -n1 | cut -d\: -f2 | cut -d\  -f2)
    yml="otg_host: https://${ADDR}:8443
        otg_ports:
          - ${ETH1}
          - ${ETH2}
        "
    echo -n "$yml" | sed "s/^        //g" | tee ./test-config.yaml > /dev/null

    gen_config_common

    gen_config_k8s_test_const ${1}
}

gen_config_k8s_test_const() {
    if [ "${1}" = "ixia-c-b2b-eth0" ]
    then
        rxUdpPort=7000
        txIp=$(kubectl get pod -n ixia-c otg-port-eth1 -o 'jsonpath={.status.podIP}')
        rxIp=$(kubectl get pod -n ixia-c otg-port-eth2 -o 'jsonpath={.status.podIP}')
        # send ping to flood arp table and extract gateway MAC
        kubectl exec -n ixia-c otg-port-eth1 -c otg-port-eth1-protocol-engine -- ping -c 1 ${rxIp}
        gatewayMac=$(kubectl exec -n ixia-c otg-port-eth1 -c otg-port-eth1-protocol-engine -- arp -a | head -n 1 | cut -d\  -f4)
        txMac=$(kubectl exec -n ixia-c otg-port-eth1 -c otg-port-eth1-protocol-engine -- ifconfig eth0 | grep ether | sed 's/  */_/g' | cut -d_ -f3)
        rxMac=$(kubectl exec -n ixia-c otg-port-eth2 -c otg-port-eth2-protocol-engine -- ifconfig eth0 | grep ether | sed 's/  */_/g' | cut -d_ -f3)
        # drop UDP packets on given dst port
        kubectl exec -n ixia-c otg-port-eth2 -c otg-port-eth2-protocol-engine -- apt-get install -y iptables
        kubectl exec -n ixia-c otg-port-eth2 -c otg-port-eth2-protocol-engine -- iptables -A INPUT -p udp --destination-port ${rxUdpPort} -j DROP

        yml="otg_test_const:
              txMac: ${txMac}
              rxMac: ${rxMac}
              gatewayMac: ${gatewayMac}
              txIp: ${txIp}
              rxIp: ${rxIp}
              rxUdpPort: ${rxUdpPort}
            "
        echo -n "$yml" | sed "s/^            //g" | tee -a ./test-config.yaml > /dev/null
    fi
}

gen_openconfig_models_sdk() {
    echo "Fetching openconfig models ..."
    rm -rf etc/public \
    && rm -rf helpers/dut/gnmi \
    && mkdir -p etc \
    && cd etc \
    && git clone ${OPENCONFIG_MODELS_REPO} \
    && cd public \
    && git checkout ${OPENCONFIG_MODELS_COMMIT} \
    && cd ..

    EXCLUDE_MODULES=ietf-interfaces,openconfig-bfd,openconfig-messages

    YANG_FILES="
        public/release/models/acl/openconfig-acl.yang
        public/release/models/acl/openconfig-packet-match.yang
        public/release/models/aft/openconfig-aft.yang
        public/release/models/aft/openconfig-aft-network-instance.yang
        public/release/models/ate/openconfig-ate-flow.yang
        public/release/models/ate/openconfig-ate-intf.yang
        public/release/models/bfd/openconfig-bfd.yang
        public/release/models/bgp/openconfig-bgp-policy.yang
        public/release/models/bgp/openconfig-bgp-types.yang
        public/release/models/interfaces/openconfig-if-aggregate.yang
        public/release/models/interfaces/openconfig-if-ethernet.yang
        public/release/models/interfaces/openconfig-if-ethernet-ext.yang
        public/release/models/interfaces/openconfig-if-ip-ext.yang
        public/release/models/interfaces/openconfig-if-ip.yang
        public/release/models/interfaces/openconfig-if-sdn-ext.yang
        public/release/models/interfaces/openconfig-interfaces.yang
        public/release/models/isis/openconfig-isis.yang
        public/release/models/lacp/openconfig-lacp.yang
        public/release/models/lldp/openconfig-lldp-types.yang
        public/release/models/lldp/openconfig-lldp.yang
        public/release/models/local-routing/openconfig-local-routing.yang
        public/release/models/mpls/openconfig-mpls-types.yang
        public/release/models/multicast/openconfig-pim.yang
        public/release/models/network-instance/openconfig-network-instance.yang
        public/release/models/openconfig-extensions.yang
        public/release/models/optical-transport/openconfig-terminal-device.yang
        public/release/models/optical-transport/openconfig-transport-types.yang
        public/release/models/ospf/openconfig-ospfv2.yang
        public/release/models/p4rt/openconfig-p4rt.yang
        public/release/models/platform/openconfig-platform-cpu.yang
        public/release/models/platform/openconfig-platform-ext.yang
        public/release/models/platform/openconfig-platform-fan.yang
        public/release/models/platform/openconfig-platform-integrated-circuit.yang
        public/release/models/platform/openconfig-platform-software.yang
        public/release/models/platform/openconfig-platform-transceiver.yang
        public/release/models/platform/openconfig-platform.yang
        public/release/models/policy-forwarding/openconfig-policy-forwarding.yang
        public/release/models/policy/openconfig-policy-types.yang
        public/release/models/qos/openconfig-qos-elements.yang
        public/release/models/qos/openconfig-qos-interfaces.yang
        public/release/models/qos/openconfig-qos-types.yang
        public/release/models/qos/openconfig-qos.yang
        public/release/models/rib/openconfig-rib-bgp.yang
        public/release/models/sampling/openconfig-sampling-sflow.yang
        public/release/models/segment-routing/openconfig-segment-routing-types.yang
        public/release/models/system/openconfig-system.yang
        public/release/models/types/openconfig-inet-types.yang
        public/release/models/types/openconfig-types.yang
        public/release/models/types/openconfig-yang-types.yang
        public/release/models/vlan/openconfig-vlan.yang
        public/third_party/ietf/iana-if-type.yang
        public/third_party/ietf/ietf-inet-types.yang
        public/third_party/ietf/ietf-interfaces.yang
        public/third_party/ietf/ietf-yang-types.yang
    "

    go install github.com/openconfig/ygnmi/app/ygnmi@v0.7.6 \
    && go install golang.org/x/tools/cmd/goimports@v0.5.0 \
    && ygnmi generator \
        --trim_module_prefix=openconfig \
        --exclude_modules="${EXCLUDE_MODULES}" \
        --base_package_path=github.com/open-traffic-generator/conformance/helpers/dut/gnmi \
        --output_dir=../helpers/dut/gnmi \
        --paths=public/release/models/...,public/third_party/ietf/... \
        --ignore_deviate_notsupported \
        ${YANG_FILES} \
    && cd .. \
    && find helpers/dut/gnmi -name "*.go" -exec goimports -w {} + \
    && find helpers/dut/gnmi -name "*.go" -exec gofmt -w -s {} +
}

wait_for_sock() {
    start=$(get_seconds)
    timeout=$(configq .timeouts.sock-ready)
    if [ ! -z "${3}" ]
    then
        timeout=${3}
    fi
    log "Waiting for ${1}:${2} to be ready (timeout=${timeout}s)..."
    while true
    do
        check_cmd nc -z -v ${1} ${2} && break

        elapsed=$(( $(get_seconds) - start ))
        if [ $elapsed -gt ${timeout} ]
        then
            err_exit "${1}:${2} not ready after ${timeout}s" 1
        fi
        sleep 0.1
    done

    elapsed=$(( $(get_seconds) - start ))
    log "${1}:${2} ready after ${elapsed}s"
}

create_ixia_c_b2b_dp() {
    echo "Setting up back-to-back with DP-only distribution of ixia-c ..."
    create_veth_pair ${VETH_A} ${VETH_Z}                    \
    && docker run --net=host  -d                            \
        --name=ixia-c-controller                            \
        $(ixia_c_controller_img dp)                         \
        --accept-eula                                       \
        --trace                                             \
        --disable-app-usage-reporter                        \
    && docker run --net=host --privileged -d                \
        --name=ixia-c-traffic-engine-${VETH_A}              \
        -e OPT_LISTEN_PORT="5555"                           \
        -e ARG_IFACE_LIST="virtual@af_packet,${VETH_A}"     \
        -e OPT_NO_HUGEPAGES="Yes"                           \
        -e OPT_NO_PINNING="Yes"                             \
        $(ixia_c_traffic_engine_img)                        \
    && docker run --net=host --privileged -d                \
        --name=ixia-c-traffic-engine-${VETH_Z}              \
        -e OPT_LISTEN_PORT="5556"                           \
        -e ARG_IFACE_LIST="virtual@af_packet,${VETH_Z}"     \
        -e OPT_NO_HUGEPAGES="Yes"                           \
        -e OPT_NO_PINNING="Yes"                             \
        $(ixia_c_traffic_engine_img)                        \
    && docker ps -a                                         \
    && gen_controller_config_b2b_dp                         \
    && gen_config_b2b_dp                                    \
    && echo "Successfully deployed !"
}

rm_ixia_c_b2b_dp() {
    echo "Tearing down back-to-back with DP-only distribution of ixia-c ..."
    docker stop ixia-c-controller && docker rm ixia-c-controller
    docker stop ixia-c-traffic-engine-${VETH_A}
    docker rm ixia-c-traffic-engine-${VETH_A}
    docker stop ixia-c-traffic-engine-${VETH_Z}
    docker rm ixia-c-traffic-engine-${VETH_Z}
    docker ps -a
    rm_veth_pair ${VETH_A} ${VETH_Z}
}

create_ixia_c_b2b_cpdp() {
    if [ "${1}" = "ipv6" ]
    then 
        ipv6_enable_docker
    fi
    echo "Setting up back-to-back with CP/DP distribution of ixia-c ..."
    login_ghcr                                              \
    && docker run -d                                        \
        --name=ixia-c-controller                            \
        --publish 0.0.0.0:8443:8443                         \
        --publish 0.0.0.0:40051:40051                       \
        $(ixia_c_controller_img cpdp)                       \
        --accept-eula                                       \
        --trace                                             \
        --disable-app-usage-reporter                        \
    && docker run --privileged -d                           \
        --name=ixia-c-traffic-engine-${VETH_A}              \
        -e OPT_LISTEN_PORT="5555"                           \
        -e ARG_IFACE_LIST="virtual@af_packet,${VETH_A}"     \
        -e OPT_NO_HUGEPAGES="Yes"                           \
        -e OPT_NO_PINNING="Yes"                             \
        -e WAIT_FOR_IFACE="Yes"                             \
        $(ixia_c_traffic_engine_img)                        \
    && docker run --privileged -d                           \
        --net=container:ixia-c-traffic-engine-${VETH_A}     \
        --name=ixia-c-protocol-engine-${VETH_A}             \
        -e INTF_LIST="${VETH_A}"                            \
        $(ixia_c_protocol_engine_img)                       \
    && docker run --privileged -d                           \
        --name=ixia-c-traffic-engine-${VETH_Z}              \
        -e OPT_LISTEN_PORT="5555"                           \
        -e ARG_IFACE_LIST="virtual@af_packet,${VETH_Z}"     \
        -e OPT_NO_HUGEPAGES="Yes"                           \
        -e OPT_NO_PINNING="Yes"                             \
        -e WAIT_FOR_IFACE="Yes"                             \
        $(ixia_c_traffic_engine_img)                        \
    && docker run --privileged -d                           \
        --net=container:ixia-c-traffic-engine-${VETH_Z}     \
        --name=ixia-c-protocol-engine-${VETH_Z}             \
        -e INTF_LIST="${VETH_Z}"                            \
        $(ixia_c_protocol_engine_img)                       \
    && docker ps -a                                         \
    && create_veth_pair ${VETH_A} ${VETH_Z}                 \
    && push_ifc_to_container ${VETH_A} ixia-c-traffic-engine-${VETH_A}  \
    && push_ifc_to_container ${VETH_Z} ixia-c-traffic-engine-${VETH_Z}  \
    && gen_controller_config_b2b_cpdp $1                     \
    && gen_config_b2b_cpdp $1                                \
    && docker ps -a \
    && echo "Successfully deployed !"
}

rm_ixia_c_b2b_cpdp() {
    echo "Tearing down back-to-back with CP/DP distribution of ixia-c ..."
    docker stop ixia-c-controller && docker rm ixia-c-controller

    docker stop ixia-c-traffic-engine-${VETH_A}
    docker stop ixia-c-protocol-engine-${VETH_A}
    docker rm ixia-c-traffic-engine-${VETH_A}
    docker rm ixia-c-protocol-engine-${VETH_A}

    docker stop ixia-c-traffic-engine-${VETH_Z}
    docker stop ixia-c-protocol-engine-${VETH_Z}
    docker rm ixia-c-traffic-engine-${VETH_Z}
    docker rm ixia-c-protocol-engine-${VETH_Z}

    docker ps -a
}

create_ixia_c_b2b_lag() {
    echo "Setting up back-to-back LAG with CP/DP distribution of ixia-c ..."
    login_ghcr                                              \
    && docker run -d                                        \
        --name=ixia-c-controller                            \
        --publish 0.0.0.0:8443:8443                         \
        --publish 0.0.0.0:40051:40051                       \
        $(ixia_c_controller_img cpdp)                       \
        --accept-eula                                       \
        --trace                                             \
        --disable-app-usage-reporter                        \
    && docker run --privileged -d                           \
        --name=ixia-c-traffic-engine-${VETH_A}              \
        -e OPT_LISTEN_PORT="5555"                           \
        -e ARG_IFACE_LIST="virtual@af_packet,${VETH_A} virtual@af_packet,${VETH_B} virtual@af_packet,${VETH_C}"     \
        -e OPT_NO_HUGEPAGES="Yes"                           \
        -e OPT_NO_PINNING="Yes"                             \
        -e WAIT_FOR_IFACE="Yes"                             \
        -e OPT_MEMORY="1024"                                \
        $(ixia_c_traffic_engine_img)                        \
    && docker run --privileged -d                           \
        --net=container:ixia-c-traffic-engine-${VETH_A}     \
        --name=ixia-c-protocol-engine-${VETH_A}             \
        -e INTF_LIST="${VETH_A},${VETH_B},${VETH_C}"        \
        $(ixia_c_protocol_engine_img)                       \
    && docker run --privileged -d                           \
        --name=ixia-c-traffic-engine-${VETH_Z}              \
        -e OPT_LISTEN_PORT="5555"                           \
        -e ARG_IFACE_LIST="virtual@af_packet,${VETH_Z} virtual@af_packet,${VETH_Y} virtual@af_packet,${VETH_X}"     \
        -e OPT_NO_HUGEPAGES="Yes"                           \
        -e OPT_NO_PINNING="Yes"                             \
        -e WAIT_FOR_IFACE="Yes"                             \
        -e OPT_MEMORY="1024"                                \
        $(ixia_c_traffic_engine_img)                        \
    && docker run --privileged -d                           \
        --net=container:ixia-c-traffic-engine-${VETH_Z}     \
        --name=ixia-c-protocol-engine-${VETH_Z}             \
        -e INTF_LIST="${VETH_Z},${VETH_Y},${VETH_X}"        \
        $(ixia_c_protocol_engine_img)                       \
    && docker ps -a                                         \
    && create_veth_pair ${VETH_A} ${VETH_Z}                 \
    && create_veth_pair ${VETH_B} ${VETH_Y}                 \
    && create_veth_pair ${VETH_C} ${VETH_X}                 \
    && push_ifc_to_container ${VETH_A} ixia-c-traffic-engine-${VETH_A}  \
    && push_ifc_to_container ${VETH_Z} ixia-c-traffic-engine-${VETH_Z}  \
    && push_ifc_to_container ${VETH_B} ixia-c-traffic-engine-${VETH_A}  \
    && push_ifc_to_container ${VETH_Y} ixia-c-traffic-engine-${VETH_Z}  \
    && push_ifc_to_container ${VETH_C} ixia-c-traffic-engine-${VETH_A}  \
    && push_ifc_to_container ${VETH_X} ixia-c-traffic-engine-${VETH_Z}  \
    && gen_controller_config_b2b_lag                        \
    && gen_config_b2b_lag                                   \
    && docker ps -a \
    && echo "Successfully deployed !"
}

check_kne_release() {
    log "Checking KNE installation ..."
    check_cmd which kne || return 1
    # TODO: KNE currently does not allow showing version number
    # log "Checking KNE release ..."
    # kne version | grep " ${1} " || return 1
}

rm_kne() {
    log "Removing any existing KNE installation ..."
    sudo rm -rf $(which kne)
}

get_kne() {
    log "Getting kne ..."
    rel=$(configq .releases.kne)
    src="$(configq .sources.kne)/kne_cli@${rel}"

    # TODO: deletion is temporary
    rm_kne
    check_kne_release ${rel} && return
    rm_kne
    
    log "Installing kne ${src} ..."
    go install ${src} \
    && mv $(which kne_cli) $(dirname $(which kne_cli))/kne \
    && check_kne_release ${rel} \
    && log "Successfully installed KNE !"
}

check_yq_release() {
    log "Checking yq installation ..."
    check_cmd which yq || return 1
    log "Checking yq release ..."
    yq --version | grep " ${1}$" || return 1
}

rm_yq() {
    log "Removing any existing yq installation ..."
    check_cmd sudo apt-get remove -y yq
    sudo rm -rf $(which yq)
}

get_yq() {
    log "Getting yq ..."

    check_yq_release ${YQ_RELEASE} && return
    rm_yq
    
    log "Installing yq ${YQ_SOURCE} ..."
    go install "${YQ_SOURCE}" && check_yq_release ${YQ_RELEASE}
    log "Successfully installed yq !"
}

check_go_release() {
    log "Checking Go installation ..."
    check_cmd which go || return 1
    log "Checking Go release ..."
    go version | grep " go${1} " || return 1
}

rm_go() {
    log "Removing any existing Go installation ..."
    sudo rm -rf $(go env 2> /dev/null | grep GOPATH | cut -d\" -f2)
    sudo rm -rf $(go env 2> /dev/null | grep GOCACHE | cut -d\" -f2)
    check_cmd sudo apt-get remove -y go
    sudo rm -rf $(which go)
}

get_go() {
    log "Getting Go ..."

    check_go_release ${GO_RELEASE} && return
    rm_go
    
    log "Installing Go ${GO_RELEASE} ..."
    # install golang per https://golang.org/doc/install#tarball
    curl -kL "${GO_SOURCE}" | sudo tar -C /usr/local/ -xzf - \
    && echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ${DOT_PROFILE} \
    && . ${DOT_PROFILE} \
    && log "Successfully installed Go (please logout and re-login to use go binary) !"
}

get_k9s() {
    [ "$(configq .opts.get-k9s)" != "true" ] && log "Skipping k9s installation" && return
    log "Getting k9s ..."
    rel=$(configq .releases.k9s)
    src="$(configq .sources.k9s)@${rel}"
    check_k9s_release ${rel} && return
    rm_k9s

    log "Installing k9s ${src} ..."
    go install "${src}" && check_k9s_release ${rel}
    log "Successfully installed k9s !"
}

rm_k9s() {
    log "Removing any existing k9s installation ..."
    sudo rm -rf $(which k9s)
}

check_k9s_release() {
    log "Checking k9s installation ..."
    check_cmd which k9s || return 1
    # TODO: k9s version does not list correct version, hence disabled for now
    # log "Checking k9s release ..."
    # k9s version | grep " ${1} " || return 1
}

get_kind() {
    log "Getting kind ..."
    rel=$(configq .releases.kind)
    src="$(configq .sources.kind)@${rel}"

    check_kind_release ${rel} && return
    rm_kind
    
    log "Installing kind ${src} ..."
    go install "${src}" && check_kind_release ${rel}
    log "Successfully installed kind !"
}

check_kind_release() {
    log "Checking kind installation ..."
    check_cmd which kind || return 1
    log "Checking kind release ..."
    kind version | grep " ${1} " || return 1
}

rm_kind() {
    rm_kind_clusters
    log "Removing any existing kind installation ..."
    sudo rm -rf $(which kind)
}

rm_kind_clusters() {
    log "Removing any existing kind cluster ..."
    check_cmd kind delete cluster
    rm -rf "${DOT_KUBE}"
}

kind_cluster_exists() {
    log "Checking if kind cluster ${1} exists ..."
    kind get clusters | grep "${1}" || return 1
    log "Cluster ${1} exists"
}

kind_new_cluster() {
    log "Creating new kind cluster ${1} ..."
    kind_cluster_exists ${1} && return
    kind create cluster --config=$(configq .paths.kind-config) --wait $(configq .timeouts.kind)s || return 1
    log "Successfully created kind cluster !"

    kind_get_kubectl \
    && kind_install_certs
}

kind_get_kubectl() {
    log "Copying kubectl from kind cluster to host ..."
    local_kubctl=deployments/k8s/kubectl
    rm -rf ${local_kubctl}
    docker cp kind-control-plane:/usr/bin/kubectl ${local_kubctl} \
    && sudo install -o root -g root -m 0755 ${local_kubctl} /usr/local/bin/kubectl \
    && rm -rf ${local_kubctl} \
    && log "Successfully copied kubectl !"
}

kind_install_certs() {
    log "Checking if cert installation is needed on kind nodes"
}

kind_setup_auth() {
    [ "$(configq .opts.kind-auth)" != "true" ] && log "Skipping ghcr.io authentication for kind cluster" && return
    log "Setting up ghcr.io authentication for kind cluster ..."
    login_ghcr \
    && cp ${DOCKER_CONFIG} $(configq .paths.docker-config) \
    && log "Successfully setup ghcr.io authentication for kind cluster !"
}

setup_kind_cluster() {
    log "Setting up kind cluster ..."
    get_kind \
    && get_k9s \
    && kind_setup_auth \
    && kind_new_cluster \
    && wait_for_pods \
    && log "Successfully setup kind cluster !"
}

mk_metallb_config() {
    log "Creating metallb configuration for kind cluster ..."
    prefix=$(docker network inspect -f '{{.IPAM.Config}}' kind | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+" | tail -n 1)
    log "Got prefix: ${prefix}"

    yml="apiVersion: metallb.io/v1beta1
        kind: IPAddressPool
        metadata:
          name: kne-pool
          namespace: metallb-system
        spec:
          addresses:
            - ${prefix}.100 - ${prefix}.250
        ---
        apiVersion: metallb.io/v1beta1
        kind: L2Advertisement
        metadata:
          name: kne-l2-adv
          namespace: metallb-system
        spec:
          ipAddressPools:
            - kne-pool
    "

    log "Configuration for metallb stored in $(configq .paths.metallb-config): "
    echo "$yml" | sed "s/^        //g" | tee $(configq .paths.metallb-config)
}

get_metallb() {
    log "Setting up metallb $(configq .sources.metallb) ..."
    kubectl apply -f $(configq .sources.metallb) \
    && wait_for_pods metallb-system \
    && mk_metallb_config \
    && log "Applying metallb config map for exposing internal services via public IP addresses ..." \
    && kubectl apply -f $(configq .paths.metallb-config) \
    && log "Successfully set up metallb !"
}

get_meshnet() {
    log "Setting up meshnet-cni $(configq .sources.meshnet)@$(configq .releases.meshnet) ..."
    rm -rf $(configq .paths.meshnet)
    oldpwd=${PWD}
    cd $(dirname $(configq .paths.meshnet))

    git clone "$(configq .sources.meshnet)" && cd meshnet-cni && git checkout $(configq .releases.meshnet) \
    && cat manifests/base/daemonset.yaml | sed "s#image: $(configq .images.meshnet.path):latest#image: $(configq .images.meshnet.path):$(configq .images.meshnet.tag)#g" | tee manifests/base/daemonset.yaml.patched > /dev/null \
    && mv manifests/base/daemonset.yaml.patched manifests/base/daemonset.yaml \
    && kubectl apply -k manifests/base \
    && wait_for_pods meshnet \
    && cd ${oldpwd} \
    && log "Successfully setup meshnet-cni !"
}

get_ixia_c_operator() {
    log "Installing ixia-c-operator $(configq .sources.ixia-c-operator) ..."
    kubectl apply -f $(configq .sources.ixia-c-operator) \
    && wait_for_pods ixiatg-op-system \
    && log "Successfully installed ixia-c-operator !"
}

rm_ixia_c_operator() {
    log "Removing ixia-c-operator $(configq .sources.ixia-c-operator) ..."
    kubectl delete -f $(configq .sources.ixia-c-operator) \
    && wait_for_no_namespace ixiatg-op-system \
    && log "Successfully removed ixia-c-operator !"
}

get_arista_ceos_operator() {
    log "Installing arista ceos operator $(configq .sources.arista-ceos-operator) ..."
    kubectl apply -k $(configq .sources.arista-ceos-operator) \
    && wait_for_pods arista-ceoslab-operator-system \
    && log "Successfully installed arista ceos operator !"
}

rm_arista_ceos_operator() {
    log "Removing arista ceos operator $(configq .sources.arista-ceos-operator) ..."
    kubectl delete -k $(configq .sources.arista-ceos-operator) \
    && wait_for_no_namespace arista-ceoslab-operator-system \
    && log "Successfully removed arista ceos operator !"
}

get_dut_operators() {
    log "Installing DUT operators ..."
    for dut in $(configq .opts.duts[])
    do
        case ${dut} in
            arista-ceos )
                get_arista_ceos_operator
            ;;
            *           )
                err_exit "Unsupported DUT ${dut}" 1
            ;;
        esac
    done
    log "Successfully installed DUT operators !"
}

get_kubemod() {
    return
    kubectl label namespace kube-system admission.kubemod.io/ignore=true --overwrite \
    && kubectl apply -f https://raw.githubusercontent.com/kubemod/kubemod/v0.15.3/bundle.yaml \
    && wait_for_pods kubemod-system
}

setup_kne_plugins() {
    log "Setting up K8S plugins for KNE ..."
    get_metallb \
    && get_meshnet \
    && get_ixia_c_operator \
    && get_dut_operators \
    && log "Successfully set up K8S plugins for KNE !"
}

ixia_c_image_path() {
    grep "\"${1}\"" -A 1 deployments/ixia-c-config.yaml | grep path | cut -d\" -f4
}

ixia_c_image_tag() {
    grep "\"${1}\"" -A 2 deployments/ixia-c-config.yaml | grep tag | cut -d\" -f4
}

ixia_c_operator_image() {
    curl -kLs ${IXIA_C_OPERATOR_YAML} | grep image | grep operator | tr -s ' ' | cut -d\  -f3
}

nokia_srl_operator_image() {
    yml="$(curl -kLs https://raw.githubusercontent.com/srl-labs/srl-controller/v${NOKIA_SRL_OPERATOR_VERSION}/config/manager/kustomization.yaml)"
    path=$(echo "${yml}" | grep newName | tr -s ' ' | cut -d\  -f 3)
    tag=$(echo "${yml}" | grep newTag | tr -s ' ' | cut -d\  -f 3)
    echo "${path}:${tag}"
}

arista_ceos_operator_image() {
    yml="$(curl -kLs https://raw.githubusercontent.com/aristanetworks/arista-ceoslab-operator/v${ARISTA_CEOS_OPERATOR_VERSION}/config/manager/kustomization.yaml)"
    path=$(echo "${yml}" | grep newName | tr -s ' ' | cut -d\  -f 3)
    tag=$(echo "${yml}" | grep newTag | tr -s ' ' | cut -d\  -f 3)
    echo "${path}:${tag}"
}

load_image_to_kind() {
    log "Loading ${1} to all kind cluster nodes ..."

    login_ghcr \
    && docker pull "${1}" \
    && kind load docker-image "${1}" \
    && log "Successfully loaded image !"
}

load_arista_ceos_image() {
    load_image_to_kind "${ARISTA_CEOS_IMAGE}:${ARISTA_CEOS_VERSION}" "local"
}

load_ixia_c_images() {
    echo "Loading ixia-c images in cluster ..."
    login_ghcr
    for name in controller gnmi-server traffic-engine protocol-engine
    do
        p=$(ixia_c_image_path ${name})
        t=$(ixia_c_image_tag ${name})
        img=${p}:${t}
        limg=${p}:local
        echo "Loading ${img}"
        docker pull ${img} \
        && docker tag ${img} ${limg} \
        && kind load docker-image ${img} \
        && kind load docker-image ${limg}
    done
}

wait_for_pods() {
    log "Waiting for pods ...."
    for n in $(kubectl get namespaces -o 'jsonpath={.items[*].metadata.name}')
    do
        if [ ! -z "$1" ] && [ "$1" != "$n" ]
        then
            continue
        fi
        for p in $(kubectl get pods -n ${n} -o 'jsonpath={.items[*].metadata.name}')
        do
            if [ ! -z "$2" ] && [ "$2" != "$p" ]
            then
                continue
            fi
            log "Waiting for pod/${p} in namespace ${n} (timeout=$(configq .timeouts.pod-ready)s)..."
            kubectl wait -n ${n} pod/${p} --for condition=ready --timeout=$(configq .timeouts.pod-ready)s || return 1
        done
    done
    log "Done waiting for pods"

    kubectl get pods -A -o wide
}

wait_for_services() {
    log "Waiting for services ...."
    for n in $(kubectl get namespaces -o 'jsonpath={.items[*].metadata.name}')
    do
        if [ ! -z "$1" ] && [ "$1" != "$n" ]
        then
            continue
        fi
        for s in $(kubectl get services -n ${n} -o 'jsonpath={.items[*].metadata.name}')
        do
            if [ ! -z "$2" ] && [ "$2" != "$s" ]
            then
                continue
            fi
            h=$(kubectl get service ${s} -n ixia-c -o 'jsonpath={.status.loadBalancer.ingress[0].ip}')
            log "Waiting for service/${s} in namespace ${n} with external IP ${h} ..."
            for p in $(kubectl get service ${s} -n ixia-c -o 'jsonpath={.spec.ports[*].port}')
            do
                log "Waiting for TCP port ${p} ..."
                wait_for_sock ${h} ${p} || return 1
            done
        done
    done
    log "Done waiting for services !"

    kubectl get services -A -o wide
}

wait_for_no_namespace() {
    start=$(get_seconds)
    inf "Waiting for namespace ${1} to be deleted (timeout=$(configq .timeouts.namespace-cleanup)s)..."
    while true
    do
        found=""
        for n in $(kubectl get namespaces -o 'jsonpath={.items[*].metadata.name}')
        do
            if [ "$1" = "$n" ]
            then
                found="$n"
                break
            fi
        done

        if [ -z "$found" ]
        then
            return 0
        fi

        elapsed=$(( $(get_seconds) - start ))
        if [ $elapsed -gt $(configq .timeouts.namespace-cleanup) ]
        then
            err_exit "Namespace ${1} not deleted after $(configq .timeouts.namespace-cleanup)s" 1
        fi
    done
    log "Done waiting for namespace to be deleted !"

    kubectl get pods -A -o wide
    kubectl get services -A -o wide
}

preload_images() {
    log "Preloading images for which preload=true ..."
    for name in $(yq ".images | keys" ${CONFIG_YAML})
    do
        if [ "${name}" != "-" ]
        then
            preload=$(configq .images[\"${name}\"].preload)
            if [ "${preload}" = "true" ]
            then
                img=$(configq .images[\"${name}\"].path):$(configq .images[\"${name}\"].tag)
                log "Preloading ${img} ..."
                load_image_to_kind "${img}" || return 1
            fi
        fi
    done
    log "Successfully preloaded images !"
}

new_kne_cluster() {
    inf "Setting up K8S cluster for KNE ..."
    common_install \
    && get_docker \
    && setup_kind_cluster \
    && preload_images \
    && setup_kne_plugins \
    && get_kne \
    && log "Successfully set up K8S cluster for KNE !"
}

rm_kne_cluster() {
    rm_kind_clusters
}

eval_yaml() {
    new_yaml=$(dirname ${1})/.$(basename ${1})
    rm -rf ${new_yaml}

    # avoid splitting based on whitespace
    IFS=''
    # mix of cat and echo is used to ensure the input file has
    # at least one newline before EOF, otherwise read will not
    # provide last line
    { cat ${1}; echo; } | while read line; do
        # replace all double-quotes with single quotes
        line=$(echo "${line}" | sed s#\"#\'#g)
        # and revert them back to double-quotes post eval;
        # this will result in converting all single-quotes
        # to double-quotes regardless of whether they were
        # originally double-quotes, but hopefully this won't
        # be an issue
        # this workaround was put in place because eval gets
        # rid of double-quotes
        eval echo \"$line\" | sed s#\'#\"#g >> ${new_yaml}
    done
    # restore default IFS
    unset IFS
    echo ${new_yaml}
}

apply_ixia_c_config() {
    [ -z "${1}" ] && cfg=$(configq .paths.ixia-c-config) || cfg=${1}
    log "Applying ixia-c config ${cfg}"
    log "Getting evaluated YAML ..."
    yml=$(eval_yaml ${cfg})
    log "Using ${yml} to apply ..."
    cat ${yml}
    kubectl apply -f ${yml} \
    && log "Successfully applied ixia-c config"
}

new_kne_topo() {
    inf "Creating KNE topology ${1} ..."
    apply_ixia_c_config ${2} || return 1
    log "Getting evaluated YAML ..."
    topo=$(eval_yaml ${1})
    log "Using ${topo} to create topology ..."
    cat ${topo}
    ns=$(yq .name ${topo})

    kne create ${topo} \
    && wait_for_pods ${ns} \
    && wait_for_services ${ns} \
    && log "Successfully created topology !"
}

rm_kne_topo() {
    inf "Deleting KNE topology ${1} ..."
    log "Getting evaluated YAML ..."
    topo=$(eval_yaml ${1})
    log "Using ${topo} to delete topology ..."
    cat ${topo}
    ns=$(yq .name ${topo})

    kne delete ${topo} \
    && wait_for_no_namespace ${ns} \
    && log "Successfully deleted topology !"
}

kne_topo_file() {
    path=deployments/k8s/kne-manifests
    if [ -z "${2}" ]
    then
        echo ${path}/${1}.yaml
    else
        echo ${path}/${1}-${2}.yaml
    fi
}

kne_namespace() {
    grep -E "^name" $(kne_topo_file ${1} ${2}) | cut -d\  -f2 | sed -e s/\"//g
}
 
create_ixia_c_kne() {
    echo "Creating KNE ${1} ${2} topology ..."
    ns=$(kne_namespace ${1} ${2})
    topo=$(kne_topo_file ${1} ${2})
    kubectl apply -f deployments/ixia-c-config.yaml \
    && kne create ${topo} \
    && wait_for_pods ${ns} \
    && kubectl get pods -A \
    && kubectl get services -A \
    && gen_config_kne ${1} ${2} \
    && echo "Successfully deployed !"
}

rm_ixia_c_kne() {
    echo "Removing KNE ${1} topology ..."
    ns=$(kne_namespace ${1} ${2})
    topo=$(kne_topo_file ${1} ${2})
    kne delete ${topo} \
    && wait_for_no_namespace ${ns}
}

k8s_namespace() {
    grep namespace deployments/k8s/manifests/${1}.yaml -m 1 | cut -d \: -f2 | cut -d \  -f 2
}

create_ixia_c_k8s() {
    echo "Creating K8S ${1} topology ..."
    ns=$(k8s_namespace ${1})
    kubectl apply -f deployments/k8s/manifests/${1}.yaml \
    && wait_for_pods ${ns} \
    && kubectl get pods -A \
    && kubectl get services -A \
    && gen_config_k8s ${1} \
    && echo "Successfully deployed !"
}

rm_ixia_c_k8s() {
    echo "Removing K8S ${1} topology ..."
    ns=$(k8s_namespace ${1})
    kubectl delete -f deployments/k8s/manifests/${1}.yaml \
    && wait_for_no_namespace ${ns}
}

topo() {
    case $1 in
        new )
            case $2 in
                dp  )
                    create_ixia_c_b2b_dp
                ;;
                cpdp)
                    create_ixia_c_b2b_cpdp $3
                ;;
                b2blag )
                    create_ixia_c_b2b_lag
                ;;
                kneb2b )
                    create_ixia_c_kne ixia-c-b2b
                ;;
                knepdp )
                    create_ixia_c_kne ixia-c-pdp ${3}
                ;;
                k8seth0 )
                    create_ixia_c_k8s ixia-c-b2b-eth0
                ;;
                *   )
                    echo "unsupported topo type: ${2}"
                    exit 1
                ;;
            esac
        ;;
        rm  )
            case $2 in
                dp  )
                    rm_ixia_c_b2b_dp
                ;;
                cpdp)
                    rm_ixia_c_b2b_cpdp
                ;;
                b2blag )
                    rm_ixia_c_b2b_cpdp
                ;;
                kneb2b )
                    rm_ixia_c_kne ixia-c-b2b
                ;;
                knepdp )
                    rm_ixia_c_kne ixia-c-pdp ${3}
                ;;
                k8seth0 )
                    rm_ixia_c_k8s ixia-c-b2b-eth0
                ;;
                *   )
                    echo "unsupported topo type: ${2}"
                    exit 1
                ;;
            esac
        ;;
        logs    )
            mkdir -p logs/ixia-c-controller
            docker cp ixia-c-controller:/home/ixia-c/controller/logs/ logs/ixia-c-controller
            docker cp ixia-c-controller:/home/ixia-c/controller/config/config.yaml logs/ixia-c-controller
            mkdir -p logs/ixia-c-traffic-engine-${VETH_A}
            mkdir -p logs/ixia-c-traffic-engine-${VETH_Z}
            docker cp ixia-c-traffic-engine-${VETH_A}:/var/log/usstream/ logs/ixia-c-traffic-engine-${VETH_A}
            docker cp ixia-c-traffic-engine-${VETH_Z}:/var/log/usstream/ logs/ixia-c-traffic-engine-${VETH_Z}
            if [ "${2}" = "cpdp" ]
            then
                mkdir -p logs/ixia-c-protocol-engine-${VETH_A}
                mkdir -p logs/ixia-c-protocol-engine-${VETH_Z}
                docker cp ixia-c-protocol-engine-${VETH_A}:/var/log/ logs/ixia-c-protocol-engine-${VETH_A}
                docker cp ixia-c-protocol-engine-${VETH_Z}:/var/log/ logs/ixia-c-protocol-engine-${VETH_Z}
                # TODO: where to get complete logs ?
                docker logs ixia-c-protocol-engine-${VETH_A} | tee logs/ixia-c-protocol-engine-${VETH_A}/stdout.log > /dev/null
                docker logs ixia-c-protocol-engine-${VETH_Z} | tee logs/ixia-c-protocol-engine-${VETH_Z}/stdout.log > /dev/null
            fi
            top -bn2 | tee logs/resource-usage.log > /dev/null
        ;;
        *   )
            exit 1
        ;;
    esac
}

prepytest() {
    rm -rf .env
    python -m pip install virtualenv \
    && python -m virtualenv .env \
    && .env/bin/python -m pip install -r requirements.txt \
    && echo "Successfully setup pytest !"
}

gotest() {
    mkdir -p logs
    log=logs/gotest.log

    CGO_ENABLED=0 go test -v -count=1 -p=1 -timeout 3600s ${@} | tee ${log}

    echo "Summary:"
    grep ": Test" ${log}

    grep FAIL ${log} && return 1 || true
}

pytest() {
    mkdir -p logs
    py=.env/bin/python
    log=logs/pytest.log

    ${py} -m pytest -svvv ${@} | tee ${log}
    
    grep FAILED ${log} && return 1 || true
}


help() {
    grep "() {" ${0} | cut -d\  -f1
}

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S.%N')     LOG: ${@}"
}

inf() {
    echo "\n$(date '+%Y-%m-%d %H:%M:%S.%N')    INFO: ${@}"
}

wrn() {
    echo "\n$(date '+%Y-%m-%d %H:%M:%S.%N') WARNING: ${@}\n"
}

err() {
    echo "\n$(date '+%Y-%m-%d %H:%M:%S.%N')   ERROR: ${@}\n"
}

err_exit() {
    err "${1}"
    if [ ! -z ${2} ]
    then
        exit ${2}
    fi
}

# This switch-case calls a function with the same name as the first argument
# passed to this script and passes rest of the arguments to the function itself
exec_func() {
    inf "Executing '${@}' with config:"
    check_cmd cat ${CONFIG_YAML}
    # shift positional arguments so that arg 2 becomes arg 1, etc.
    cmd=${1}
    shift 1
    ${cmd} ${@} 2>&1 || err_exit "Failed executing: ${cmd} ${@}" 1
}

case $1 in
    *   )
        exec_func ${@} | tee -a "${IXOPS_LOG}"
    ;;
esac
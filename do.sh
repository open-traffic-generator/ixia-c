#!/bin/sh

# update for any release using
# curl -kLO https://github.com/open-traffic-generator/ixia-c/releases/download/v0.0.1-2994/versions.yaml
VERSIONS_YAML="versions.yaml"

GO_VERSION=1.19
KIND_VERSION=v0.16.0
METALLB_VERSION=v0.13.6
MESHNET_COMMIT=f26c193
MESHNET_IMAGE="networkop/meshnet\:v0.3.0"
IXIA_C_OPERATOR_VERSION="0.3.11"
IXIA_C_OPERATOR_YAML="https://github.com/open-traffic-generator/ixia-c-operator/releases/download/v${IXIA_C_OPERATOR_VERSION}/ixiatg-operator.yaml"
KNE_VERSION=v0.1.9

OPENCONFIG_MODELS_REPO=https://github.com/openconfig/public.git
OPENCONFIG_MODELS_COMMIT=5ca6a36

TIMEOUT_SECONDS=300
APT_GET_UPDATE=true


apt_update() {
    if [ "${APT_UPDATE}" = "true" ]
    then
        sudo apt-get update
        APT_GET_UPDATE=false
    fi
}

apt_install() {
    echo "Installing ${1} ..."
    apt_update \
    && sudo apt-get install -y --no-install-recommends ${1}
}

apt_install_curl() {
    curl --version > /dev/null 2>&1 && return
    apt_install curl
}

apt_install_vim() {
    dpkg -s vim > /dev/null 2>&1 && return
    apt_install vim
}

apt_install_git() {
    git version > /dev/null 2>&1 && return
    apt_install git
}

apt_install_lsb_release() {
    lsb_release -v > /dev/null 2>&1 && return
    apt_install lsb_release
}

apt_install_gnupg() {
    gpg -k > /dev/null 2>&1 && return
    apt_install gnupg
}

apt_install_ca_certs() {
    dpkg -s ca-certificates > /dev/null 2>&1 && return
    apt_install gnupg ca-certificates
}

apt_install_pkgs() {
    uname -a | grep -i linux > /dev/null 2>&1 || return 0
    apt_install_curl \
    && apt_install_vim \
    && apt_install_git \
    && apt_install_lsb_release \
    && apt_install_gnupg \
    && apt_install_ca_certs
}

get_go() {
    which go > /dev/null 2>&1 && return
    echo "Installing Go ${GO_VERSION} ..."
    # install golang per https://golang.org/doc/install#tarball
    curl -kL https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz | sudo tar -C /usr/local/ -xzf - \
    && echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.profile \
    && . $HOME/.profile \
    && go version
}

get_docker() {
    which docker > /dev/null 2>&1 && return
    echo "Installing docker ..."
    sudo apt-get remove docker docker-engine docker.io containerd runc 2> /dev/null

    curl -kfsSL https://download.docker.com/linux/ubuntu/gpg \
        | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
        | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update \
    && sudo apt-get install -y docker-ce docker-ce-cli containerd.io
}

common_install() {
    apt_install_pkgs \
    && get_go \
    && get_docker \
    && sudo_docker
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

keng_license_server_img() {
    ixia_c_img keng-license-server
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
    if [ -f "$HOME/.docker/config.json" ]
    then
        grep ghcr.io "$HOME/.docker/config.json" > /dev/null && return 0
    fi
    echo "Logging into docker repo ghcr.io"
    echo "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" | docker login -u "biplamal" --password-stdin ghcr.io
}

logout_ghcr() {
    docker logout ghcr.io
}

wait_for_sock() {
    start=$SECONDS
    TIMEOUT_SECONDS=30
    if [ ! -z "${3}" ]
    then
        TIMEOUT_SECONDS=${3}
    fi
    echo "Waiting for ${1}:${2} to be ready (timeout=${TIMEOUT_SECONDS}s)..."
    while true
    do
        nc -z -v ${1} ${2} && return 0

        elapsed=$(( SECONDS - start ))
        if [ $elapsed -gt ${TIMEOUT_SECONDS} ]
        then
            echo "${1}:${2} to be ready after ${TIMEOUT_SECONDS}s"
            exit 1
        fi
        sleep 0.1
    done

}

sudo_docker() {
    groups | grep docker > /dev/null 2>&1 && return
    sudo groupadd docker
    sudo usermod -aG docker $USER

    sudo docker version
    echo "Please logout, login again and re-execute previous command"
    exit 0
}

get_kind() {
    which kind > /dev/null 2>&1 && return
    echo "Installing kind ${KIND_VERSION} ..."
    go install sigs.k8s.io/kind@${KIND_VERSION}
}

kind_cluster_exists() {
    kind get clusters | grep kind > /dev/null 2>&1
}

kind_create_cluster() {
    kind_cluster_exists && return
    echo "Creating kind cluster ..."
    kind create cluster --config=deployments/k8s/kind.yaml --wait ${TIMEOUT_SECONDS}s
}

kind_get_kubectl() {
    echo "Copying kubectl from kind cluster to host ..."
    rm -rf kubectl
    docker cp kind-control-plane:/usr/bin/kubectl ./ \
    && sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && sudo cp -r $HOME/.kube /root/ \
    && rm -rf kubectl
}

setup_kind_cluster() {
    echo "Setting up kind cluster ..."
    get_kind \
    && kind_create_cluster \
    && kind_get_kubectl
}

mk_metallb_config() {
    prefix=$(docker network inspect -f '{{.IPAM.Config}}' kind | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+" | tail -n 1)

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

    echo "$yml" | sed "s/^        //g" | tee deployments/k8s/metallb.yaml > /dev/null
}

get_metallb() {
    echo "Setting up metallb ..."
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/${METALLB_VERSION}/config/manifests/metallb-native.yaml \
    && wait_for_pods metallb-system \
    && mk_metallb_config \
    && echo "Applying metallb config map for exposing internal services via public IP addresses ..." \
    && cat deployments/k8s/metallb.yaml \
    && kubectl apply -f deployments/k8s/metallb.yaml
}

get_meshnet() {
    echo "Installing meshnet-cni (${MESHNET_COMMIT}) ..."
    rm -rf deployments/k8s/meshnet-cni
    oldpwd=${PWD}
    cd deployments/k8s

    git clone https://github.com/networkop/meshnet-cni && cd meshnet-cni && git checkout ${MESHNET_COMMIT} \
    && cat manifests/base/daemonset.yaml | sed "s#image: networkop/meshnet:latest#image: ${MESHNET_IMAGE}#g" | tee manifests/base/daemonset.yaml.patched > /dev/null \
    && mv manifests/base/daemonset.yaml.patched manifests/base/daemonset.yaml \
    && kubectl apply -k manifests/base \
    && wait_for_pods meshnet \
    && cd ${oldpwd}
}

get_ixia_c_operator() {
    echo "Installing keng-operator ${IXIA_C_OPERATOR_YAML} ..."
    load_image_to_kind $(ixia_c_operator_image) \
    && kubectl apply -f ${IXIA_C_OPERATOR_YAML} \
    && wait_for_pods ixiatg-op-system
}

rm_ixia_c_operator() {
    echo "Removing keng-operator ${IXIA_C_OPERATOR_YAML} ..."
    kubectl delete -f ${IXIA_C_OPERATOR_YAML} \
    && wait_for_no_namespace ixiatg-op-system
}


get_kne() {
    which kne > /dev/null 2>&1 && return
    echo "Installing KNE ${KNE_VERSION} ..."
    CGO_ENBLED=0 go install github.com/openconfig/kne/kne_cli@${KNE_VERSION} \
    && mv $(which kne_cli) $(dirname $(which kne_cli))/kne
}

get_kubemod() {
    return
    kubectl label namespace kube-system admission.kubemod.io/ignore=true --overwrite \
    && kubectl apply -f https://raw.githubusercontent.com/kubemod/kubemod/v0.15.3/bundle.yaml \
    && wait_for_pods kubemod-system
}

setup_k8s_plugins() {
    echo "Setting up K8S plugins ..."
    get_metallb \
    && get_meshnet \
    && get_ixia_c_operator \
    && get_kne
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

load_image_to_kind() {
    echo "Loading ${1}"

    login_ghcr \
    && docker pull "${1}" \
    && kind load docker-image "${1}" \
    || return 1

    if [ "${2}" = "local" ]
    then
        localimg="$(echo ${1} | cut -d: -f1):local"
        docker tag "${1}" "${localimg}" \
        && kind load docker-image "${localimg}"
    fi
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
            echo "Waiting for pod/${p} in namespace ${n} (timeout=${TIMEOUT_SECONDS}s)..."
            kubectl wait -n ${n} pod/${p} --for condition=ready --timeout=${TIMEOUT_SECONDS}s
        done
    done
}

wait_for_no_namespace() {
    start=$SECONDS
    echo "Waiting for namespace ${1} to be deleted (timeout=${TIMEOUT_SECONDS}s)..."
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

        elapsed=$(( SECONDS - start ))
        if [ $elapsed -gt ${TIMEOUT_SECONDS} ]
        then
            err "Namespace ${1} not deleted after ${TIMEOUT_SECONDS}s" 1
        fi
    done
}

new_k8s_cluster() {
    common_install \
    && setup_kind_cluster \
    && setup_k8s_plugins \
    && load_ixia_c_images
}

rm_k8s_cluster() {
    echo "Deleting kind cluster ..."
    kind delete cluster 2> /dev/null
    rm -rf $HOME/.kube
}

kne_topo_file() {
    path=deployments/k8s/kne-manifests
    echo ${path}/${1}.yaml
    
}

kne_namespace() {
    grep -E "^name" $(kne_topo_file ${1}) | cut -d\  -f2 | sed -e s/\"//g
}
 
create_ixia_c_kne() {
    echo "Creating KNE ${1} topology ..."
    ns=$(kne_namespace ${1})
    topo=$(kne_topo_file ${1})
    case $3 in 
        google )
            kubectl create secret -n ixiatg-op-system generic license-server --from-literal=image="ghcr.io/open-traffic-generator/licensed/keng-license-server:latest"
        ;;
        vendor )
            kubectl create secret -n ixiatg-op-system generic license-server --from-literal=addresses="0.0.0.0"
        ;;
    esac
    kubectl apply -f deployments/ixia-c-config.yaml \
    && kne create ${topo} \
    && wait_for_pods ${ns} \
    && kubectl get pods -A \
    && kubectl get services -A \
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
            
                kneb2b )
                    create_ixia_c_kne ixia-c-b2b ${3}
                ;;
                *   )
                    echo "unsupported topo type: ${2}"
                    exit 1
                ;;
            esac
        ;;
        rm  )
            case $2 in
                kneb2b )
                    rm_ixia_c_kne ixia-c-b2b
                ;;
                *   )
                    echo "unsupported topo type: ${2}"
                    exit 1
                ;;
            esac
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
        # shift positional arguments so that arg 2 becomes arg 1, etc.
        cmd=${1}
        shift 1
        ${cmd} ${@} || usage
    ;;
esac

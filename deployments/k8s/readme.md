# Deploy Ixia-C in Kubernetes

This section hosts [kustomize](https://kustomize.io/) manifests for deploying various Ixia-C topologies in Kubernetes cluster.

### Prerequisites

- At least **2 x86 CPU cores**, **7GB RAM** and **30GB Free Hard Disk Space**
- Recommended OS is **Ubuntu 22.04 LTS** release.
- Go **1.20+**
- **Docker Engine** (Community Edition) - Needed when using kind for setting up K8S cluster

> Please make sure that current working directory is `deployments/k8s`.

### Initial Steps

1. Clone repository

    ```bash
    git clone --recurse-submodules https://github.com/open-traffic-generator/ixia-c.git
    cd ixia-c/deployments/k8s
    ```

2. Setup a Kubernetes cluster using [kind](https://kind.sigs.k8s.io/)

    ```bash
    # install kind
    go install sigs.k8s.io/kind@v0.20.0
    # create cluster with custom configuration
    kind create cluster --config=kind.yaml --wait 30s
    # install compatible kubectl
    sudo docker cp kind-control-plane:/usr/bin/kubectl /usr/local/bin/kubectl
    sudo chmod 0755 /usr/local/bin/kubectl
    # ensure all pods are ready
    kubectl wait --for=condition=Ready pods --all --all-namespaces
    ```

3. (Optional) Load container images to cluster if offline images are preferred

    Images to be used are specified in `components/images/kustomization.yaml`.

    ```bash
    yml=components/images/kustomization.yaml
    for i in $(seq $(grep -c newName ${yml}))
    do
        cap=$(grep -A1 -m${i} newName ${yml} | tail -n 2)
        img=$(grep -A1 -m${i} newName ${yml} | tail -n 2 | grep newName | cut -d: -f2 | cut -d\  -f2)
        img=${img}:$(grep -A1 -m${i} newName ${yml} | tail -n 2 | grep newTag | cut -d\" -f2)
        docker pull "${img}" && kind load docker-image "${img}"
    done
    ```

### Deploy Topology and Run Tests (Stateless traffic on eth0)

1. Deploy topology consisting of two Ixia-c port pods and one KENG controller pod

    Topology manifests are kept inside `overlays/two-traffic-ports-eth0` which specifies `port1` and `port2`.
    * iptables rule is configured on both ports to drop UDP/TCP packets destined for ports 7000-8000
    * number of ports can be increased by adding new port dirs similar to `port1` and using it in rest of the files

    ```bash
    # deploy Ixia-c with two ports that only support stateless traffic over eth0
    kubectl apply -k overlays/two-traffic-ports-eth0
    # ensure all Ixia-c pods are ready
    kubectl wait --for=condition=Ready pods --all -n ixia-c
    ```

2. Generate test pre-requisites

    The sample test requires `conformance/test-config.yaml` which is auto-generated:
    * KENG controller / port endpoints
    * common port / flow properties
    * values like port pod IPs, gateway MAC on tx port, etc.

    ```bash
    overlays/two-traffic-ports-eth0/gen-test-config.sh ../../conformance/test-config.yaml
    # check contents
    cat ../../conformance/test-config.yaml
    ```

3. Run sample test

    The test being run for this specific topology is `conformance/feature/b2b/packet/udp/udp_port_value_eth0_test.go`

    ```bash
    cd ../../conformance
    CGO_ENABLED=0 go test -v -count=1 -p=1 -timeout 3600s -tags="all" -run="^TestUdpPortValueEth0$" ./...
    ```

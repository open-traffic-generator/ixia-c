# Deploy Ixia-C in Kubernetes

This section hosts [kustomize](https://kustomize.io/) manifests for deploying various Ixia-C topologies in Kubernetes cluster.

### Prerequisites

- Recommended OS is Ubuntu LTS release.
- At least 2 CPU cores
- At least 6GB RAM
- At least 10GB Free Hard Disk Space
- Go 1.17+ or Python 3.6+ (with pip)
- Docker Engine (Community Edition)

> Please make sure that current working directory is `deployments/k8s`.

### Steps

1. Clone repository

    ```bash
    git clone --recurse-submodules https://github.com/open-traffic-generator/ixia-c.git
    cd ixia-c/deployments/k8s
    ```

2. Setup a Kubernetes cluster using [kind](https://kind.sigs.k8s.io/)

    ```bash
    # install kind
    go install sigs.k8s.io/kind@v0.16.0
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
        img=$(grep -A1 -m${i} newName ${yml} | tail -n 2 | grep newName | cut -d\  -f4)
        img=${img}:$(grep -A1 -m${i} newName ${yml} | tail -n 2 | grep newTag | cut -d\" -f2)
        docker pull "${img}" && kind load docker-image "${img}"
    done
    ```

4. Deploy one of provided ixia-c topologies

    For this example, topology manifests are kept inside `overlays/two-traffic-ports-eth0` which configures `port1` and `port2`.

    ```bash
    # deploy ixia-c with two ports that only support stateless traffic over eth0
    kubectl apply -k overlays/two-traffic-ports-eth0
    # ensure all ixia-c pods are ready
    kubectl wait --for=condition=Ready pods --all -n ixia-c
    ```

5. Setup Tests

    The tests require `conformance/test-config.yaml` to run against specified port/test configurations. It needs to be generated for different topologies.

    ```bash
    overlays/two-traffic-ports-eth0/gen-test-config.sh ../../conformance/test-config.yaml
    # check contents
    cat ../../conformance/test-config.yaml
    ```

6. Run Tests

    The test being run for this specific topology is `conformance/features/flows/headers/udp/udp_header_eth0_test.go`

    ```bash
    cd ../../conformance
    CGO_ENABLED=0 go test -v -count=1 -p=1 -timeout 3600s -tags="all" -run="^TestUdpHeaderEth0$" ./...
    ```

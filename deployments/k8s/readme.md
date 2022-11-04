

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

3. Deploy one of provided ixia-c topologies

    ```bash
    # deploy ixia-c with two ports that only support data plane traffic over eth0
    kubectl apply -k overlays/two-dp-ports-eth0
    # ensure all ixia-c pods are ready
    kubectl wait --for=condition=Ready pods --all -n ixia-c
    ```

4. Setup Tests

    ```bash

    ```
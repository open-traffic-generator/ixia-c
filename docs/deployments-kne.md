# Deploy Ixia-c using KNE

Ixia-c can be deployed in the k8s environment by using the [Kubernetes Network Emulation](https://github.com/openconfig/kne) that consists of the following services:

* **operator**: Serves API request from the clients and manages workflow across one or more traffic engines.
* **controller**: Serves API request from the clients and manages workflow across one or more traffic engines.
* **traffic-engine**: Generates, captures, and processes the traffic from one or more network interfaces (on linux-based OS).
* **protocol-engine**: Emulates layer3 networks and protocols such as BGP, ISIS, and etc (on linux-based OS).
* **gnmi-server**: Captures statistics from one or more network interfaces (on linux-based OS).

## System Prerequisites

### CPU and RAM

Following are the recommended resources for a basic use-case.

- `keng-operator`: Each instance requires at least 1 CPU core and 2GB RAM.
- `keng-controller`: Each instance requires at least 1 CPU core and 2GB RAM.
- `otg-gnmi-server`: Each instance requires at least 1 CPU core and 2GB RAM.
- `ixia-c-traffic-engine`: Each instance requires 2 dedicated CPU cores and 3GB dedicated RAM.
- `ixia-c-protocol-engine`: Each instance requires 4 dedicated CPU cores and 1GB dedicated RAM per port.

### OS and Software Prerequisites

- x86_64 Linux Distribution (Centos 7+ or Ubuntu 18+ have been tested)
- Docker 19+ (as distributed by https://docs.docker.com/)
- Go 1.17+
- kind 0.18+

## Install KNE

* The main use case we are interested in is the ability to bring up arbitrary topologies to represent a production topology. This would require multiple vendors as well as traffic generation and end hosts.

  ```sh
    go install github.com/openconfig/kne/kne@latest
  ```

## Deploy keng-operator

* Ixia Operator defines CRD for Ixia network device (IxiaTG) and can be used to build up different network topologies with network devices from other vendors. Network interconnects between the topology nodes can be setup with various container network interface (CNI) plugins for Kubernetes for attaching multiple network interfaces to the nodes.

  ```sh
    kubectl apply -f https://github.com/open-traffic-generator/keng-operator/releases/download/v0.3.5/ixiatg-operator.yaml
  ```

## Apply configmap

* The various Ixia component versions to be deployed is derived from the Ixia release version as specified in the IxiaTG config. These component mappings are captured in ixia-configmap.yaml for each Ixia release. The configmap, as shown in the snippet below, comprise of the Ixia release version ("release"), and the list of qualified component versions, for that release. Ixia Operator first tries to access these details from Keysight published releases; if unable to so, it tries to locate them in Kubernetes configmap. This allows users to have the operator load images from private repositories, by updating the configmap entries. Thus, for deployment with custom images, the user is expected to download release specific ixia-configmap.yaml from published releases. Then, in the configmap, update the specific container image "path" / "tag" fields and also update the "release" to some custom name. Start the operator first as specified in the deployment section below, before applying the configmap locally. After this the operator can be used to deploy the containers and services.

  * For community users,

    ```json
      apiVersion: v1
      kind: ConfigMap
      metadata:
          name: ixiatg-release-config
          namespace: ixiatg-op-system
      data:
          versions: |
              {
                "release": "1.13.0-9",
                "images": [
                      {
                          "name": "controller",
                          "path": "ghcr.io/open-traffic-generator/keng-controller",
                          "tag": "1.13.0-9"
                      },
                      {
                          "name": "gnmi-server",
                          "path": "ghcr.io/open-traffic-generator/otg-gnmi-server",
                          "tag": "1.14.14"
                      },
                      {
                          "name": "traffic-engine",
                          "path": "ghcr.io/open-traffic-generator/ixia-c-traffic-engine",
                          "tag": "1.8.0.90"
                      },
                      {
                          "name": "protocol-engine",
                          "path": "ghcr.io/open-traffic-generator/ixia-c-protocol-engine",
                          "tag": "1.00.0.404"
                      },
                      {
                          "name": "ixhw-server",
                          "path": "ghcr.io/open-traffic-generator/keng-layer23-hw-server",
                          "tag": "1.13.0-5"
                      }
                  ]
              }
    ```

  * For commercial users, `LICENSE_SERVERS` needs to be specified for `keng-controller` deployment.

    ```json
      apiVersion: v1
      kind: ConfigMap
      metadata:
          name: ixiatg-release-config
          namespace: ixiatg-op-system
      data:
          versions: |
              {
                "release": "1.13.0-9",
                "images": [
                      {
                          "name": "controller",
                          "path": "ghcr.io/open-traffic-generator/keng-controller",
                          "tag": "1.13.0-9",
                          "env": {
                                "LICENSE_SERVERS": "ip/hostname of license server"
                            }
                      },
                      {
                          "name": "gnmi-server",
                          "path": "ghcr.io/open-traffic-generator/otg-gnmi-server",
                          "tag": "1.14.14"
                      },
                      {
                          "name": "traffic-engine",
                          "path": "ghcr.io/open-traffic-generator/ixia-c-traffic-engine",
                          "tag": "1.8.0.90"
                      },
                      {
                          "name": "protocol-engine",
                          "path": "ghcr.io/open-traffic-generator/ixia-c-protocol-engine",
                          "tag": "1.00.0.404"
                      },
                      {
                          "name": "ixhw-server",
                          "path": "ghcr.io/open-traffic-generator/keng-layer23-hw-server",
                          "tag": "1.13.0-5"
                      }
                  ]
              }
    ```

  ```sh
    # After saving the configmap snippet in a yaml file
    kubectl apply -f ixiatg-configmap.yaml
  ```

## Deploy the topology

* The following snippet shows a simple KNE b2b topology.

  ```yaml
  name: ixia-c
  nodes:
    - name: otg
      vendor: KEYSIGHT
      version: 1.13.0-9
      services:
        8443:
          name: https
          inside: 8443
        40051:
          name: grpc
          inside: 40051
        50051:
          name: gnmi
          inside: 50051
  links:
    - a_node: otg
      a_int: eth1
      z_node: otg
      z_int: eth2
  ```

  ```sh
  # After saving the topology snippet in a yaml file
  kne create topology.yaml
  ```

* After deployment, you are now ready to run a test using this topology.

## Destroy/Remove the topology

  ```sh
  # delete a particular topology
  kne delete topology.yaml
  ```

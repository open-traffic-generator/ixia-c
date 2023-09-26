# Deployment Guide

- [Table of Contents](readme.md)
  - Deployment Guide
    - [Overview](#overview)
    - [Bootstrap](#bootstrap)
    - Deployment types
      - [Docker deployments](#using-docker-compose)
      - [Containerlab deployments](deployments_containerlab.md)
      - [KNE deployments](deployments_kne.md)
    - [Diagnostics](#diagnostics)
    - [Test Suite](#test-suite)
    - [One-arm Scenario](#one-arm-scenario)
    - [Two-arm Scenario](#two-arm-scenario)
    - [Three-arm Mesh Scenario](#three-arm-mesh-scenario)

## Overview

Ixia-c is distributed / deployed as a multi-container application consisting of the following services:

* **controller**: Serves API request from the clients and manages workflow across one or more traffic engines.
* **traffic-engine**: Generates, captures, and processes traffic from one or more network interfaces (on linux-based OS).
* **app-usage-reporter**: (Optional) Collects anonymous usage report from the controller and uploads it to the Keysight Cloud, with minimal impact on the host resources.

All these services are available as docker images on [GitHub Open-Traffic-Generator repository](https://github.com/orgs/open-traffic-generator/packages). To use specific versions of these images, see [Ixia-c Releases](releases.md) .

![ixia-c-aur](res/ixia-c-aur.drawio.svg "ixia-c-aur")

> Once the services are deployed, [snappi-tests](https://github.com/open-traffic-generator/snappi-tests/tree/3ffe20f) (a collection of [snappi](https://pypi.org/project/snappi/) test scripts and configurations) can be setup to run against Ixia-c.

## Bootstrap

The Ixia-c services can either all be deployed on the same host or each on separate hosts (as long as they are mutually reachable over the network). There is no boot-time dependency between them, which allows **horizontal scalability** without interrupting the existing services.

You can establish a connectivity between the services in two ways. The options are as follows:

- **controller & traffic-engine**: The client pushes a traffic configuration to the controller, containing the `location` of the traffic engine.
- **controller & app-usage-reporter**: The Controller periodically tries to establish connectivity with the `app-usage-reporter` on a `location`, which can be overridden by using the controller's deployment parameters.

>The **location** (network address) of the traffic-engine and the app-usage-reporter must be reachable from the controller, even if they are not reachable from the client scripts.

## Deployment types

### Using docker-compose

Deploying multiple services manually (along with the required parameters) is not always applicable in some scenarios. For convenience, the [deployments](../deployments) directory consists of the following `docker-compose` files:

- `*.yml`: Describes the services for a given scenario and the deployment parameters that are required to start them.
- `.env`: Holds the default parameters, that are used across all `*.yml` files. For example, the name of the interface, the version of docker images, and etc.

If a concerned `.yml` file does not include certain variables from `.env`, those can then safely be ignored.  
Follwoing is the example of a usual workflow, by using  `docker-compose`.

```sh
# change default parameters if needed; e.g. interface name, image version, etc.
vi deployments/.env
# deploy and start services for community users
docker-compose -f deployments/<scenario>.yml up -d
# stop and remove services deployed
docker-compose -f deployments/<scenario>.yml down
```

On most of the systems, `docker-compose` needs to be installed separately even if the docker is already installed. For more information, see [docker prerequisites](prerequisites.md#docker) .

>All the scenarios that are mentioned in the following sections, describe both manual and automated (requiring docker-compose) steps.

### Deployment Parameters

#### Controller

  | Controller Parameters       | Optional  | Default                 | Description                                                     |
  |-----------------------------|-----------|-------------------------|-----------------------------------------------------------------|
  | --debug                     |   Yes     | false                   | Enables high volume logs with debug info for better diagnostics.|
  | --disable-app-usage-reporter|   Yes     | false                   | Disables sending of usage data to the app-usage-reporter.              |
  | --http-port                 |   Yes     | 8443                     | TCP port for HTTP server.                                       |
  | --aur-host                  |   Yes     | https://localhost:5600  | Overrides the location of the app-usage-reporter.                       |
  | --accept-eula               |   No      | NA                      | Indicates that the user has accepted EULA, otherwise the controller will not boot up. |
  | --license-servers           |   No      | NA                      | Indicates the ip address of license servers for commercial users. |

  Docker Parameters:

- `--net=host`: It is recommended to allow the use of the host network stack, in order to address the traffic-engine containers using `localhost` instead of `container-ip`, when deployed on the same host.
- `-d`: This starts the container in background.

  Example:

  ```bash
  # For community users
  docker run --net=host -d ghcr.io/open-traffic-generator/ixia-c-controller --accept-eula --debug --http-port 5050

  # For commercial users
  docker run --net=host -d ghcr.io/open-traffic-generator/ixia-c-controller --accept-eula --debug --http-port 5050 --license-servers="ip/hostname of license server"
  ```

#### Traffic Engine

  | Environment Variables       | Optional  | Default                 | Description                                                     |
  |-----------------------------|-----------|-------------------------|-----------------------------------------------------------------|
  | ARG_IFACE_LIST              |   No      | NA                      | Name of the network interface to bind to. It must be visible to the traffic-engine's network namespace. For example, `virtual@af_packet,eth1` where `eth1` is the interface name and `virtual@af_packet` indicates that the interface is managed by the host kernel's network stack.|
  | OPT_LISTEN_PORT             |   Yes     | "5555"                  | TCP port on which the controller can establish connection with the traffic-engine.|
  | OPT_NO_HUGEPAGES            |   Yes     | "No"                    | If set to `Yes`, it disables hugepages in the OS. The hugepages needs to be disabled when the network interfaces are managed by the host kernel's stack.|

  Docker Parameters:

- `--net=host`: This is required if the traffic-engine needs to bind to a network interface that is visible in the host network stack but not inside the docker's network.
- `--privileged`: This is required because the traffic-engine needs to exercise capabilities that require elevated privileges.
- `--cpuset-cpus`: The traffic-engine usually requires 1 shared CPU core for management activities and 2 exclusive CPU cores, each for the transmit engine and receive engine. The shared CPU core can be shared across multiple traffic-engines. For example, `--cpuset-cpus="0,1,2"` which indicates that cpu0 is shared, cpu1 is used for transmit and cpu2 is used for receive. If CPU cores are not specified, any arbitrary CPU cores will be chosen.
    > If enough CPU cores are not provided, the available CPU cores may be shared among management, transmit, and the receive engines, that can occasionally result in lower performance.
- `-d`: This starts the container in background.

  Example:

  ```bash
  docker run --net=host --privileged -d         \
    -e OPT_LISTEN_PORT="5555"                   \
    -e ARG_IFACE_LIST="virtual@af_packet,eth1"  \
    -e OPT_NO_HUGEPAGES="Yes"                   \
    --cpuset-cpus="0,1,2"                       \
    ghcr.io/open-traffic-generator/ixia-c-traffic-engine
  ```

## Diagnostics

Check and download controller logs:

```sh
docker exec <container-id> cat logs/controller.log
# follow logs
docker exec <container-id> tail -f logs/controller.log
# check stdout output
docker logs <container-id>
# download logs
docker cp <container-id>:$(docker exec <container-id> readlink -f logs/controller.log) ./
```

Check and download traffic-engine logs:

```sh
docker exec <container-id> cat /var/log/usstream/usstream.log
# follow logs
docker exec <container-id> tail -f /var/log/usstream/usstream.log
# check stdout output
docker logs <container-id>
# download logs
docker cp <container-id>:/var/log/usstream/usstream.log ./
```

## Test Suite

## One-arm Scenario

> TODO: diagram

* Automated

  ```bash
  docker-compose -f deployments/raw-one-arm.yml up -d # community users
  # optionally stop and remove services deployed
  docker-compose -f deployments/raw-one-arm.yml down # community users
  ```

* Manual

  ```bash
  # start controller and app usage reporter

  # community users
  docker run --net=host -d ghcr.io/open-traffic-generator/ixia-c-controller --accept-eula
  # commercial users
  docker run --net=host -d ghcr.io/open-traffic-generator/ixia-c-controller --accept-eula --license-servers="ip/hostname of license server"
  docker run --net=host -d ghcr.io/open-traffic-generator/ixia-c-app-usage-reporter

  # start traffic engine on network interface eth1, TCP port 5555 and cpu cores 0, 1, 2
  docker run --net=host --privileged -d         \
    -e OPT_LISTEN_PORT="5555"                   \
    -e ARG_IFACE_LIST="virtual@af_packet,eth1"  \
    -e OPT_NO_HUGEPAGES="Yes"                   \
    --cpuset-cpus="0,1,2"                       \
    ghcr.io/open-traffic-generator/ixia-c-traffic-engine
  ```

## Two-arm Scenario

> TODO: diagram

* Automated

  ```bash
  docker-compose -f deployments/raw-two-arm.yml up -d # community users
  # optionally stop and remove services deployed
  docker-compose -f deployments/raw-two-arm.yml down # community users
  ```

* Manual

  ```bash
  # start controller and app usage reporter
  # community users
  docker run --net=host -d ghcr.io/open-traffic-generator/ixia-c-controller --accept-eula
  # commercial users
  docker run --net=host -d ghcr.io/open-traffic-generator/ixia-c-controller --accept-eula --license-servers="ip/hostname of license server"
  docker run --net=host -d ghcr.io/open-traffic-generator/ixia-c-app-usage-reporter

  # start traffic engine on network interface eth1, TCP port 5555 and cpu cores 0, 1, 2
  docker run --net=host --privileged -d         \
    -e OPT_LISTEN_PORT="5555"                   \
    -e ARG_IFACE_LIST="virtual@af_packet,eth1"  \
    -e OPT_NO_HUGEPAGES="Yes"                   \
    --cpuset-cpus="0,1,2"                       \
    ghcr.io/open-traffic-generator/ixia-c-traffic-engine

  # start traffic engine on network interface eth2, TCP port 5556 and cpu cores 0, 3, 4
  docker run --net=host --privileged -d         \
    -e OPT_LISTEN_PORT="5556"                   \
    -e ARG_IFACE_LIST="virtual@af_packet,eth2"  \
    -e OPT_NO_HUGEPAGES="Yes"                   \
    --cpuset-cpus="0,3,4"                       \
    ghcr.io/open-traffic-generator/ixia-c-traffic-engine
  ```

## Three-arm Mesh Scenario

This scenario binds traffic engine to the management network interface, that belongs to the container which in turn is a part of the docker0 network.

> TODO: diagram

* Automated

  ```bash
  docker-compose -f deployments/raw-three-arm-mesh.yml up -d # community users
  # optionally stop and remove services deployed
  docker-compose -f deployments/raw-three-arm-mesh.yml down # community users
  ```

* Manual

  ```bash
  # start controller and app usage reporter
  # community users
  docker run --net=host -d ghcr.io/open-traffic-generator/ixia-c-controller --accept-eula
  # commercial users
  docker run --net=host -d ghcr.io/open-traffic-generator/ixia-c-controller --accept-eula --license-servers="ip/hostname of license server"
  docker run --net=host -d ghcr.io/open-traffic-generator/ixia-c-app-usage-reporter

  # start traffic engine on network interface eth0, TCP port 5555 and cpu cores 0, 1, 2
  docker run --privileged -d                    \
    -e OPT_LISTEN_PORT="5555"                   \
    -e ARG_IFACE_LIST="virtual@af_packet,eth0"  \
    -e OPT_NO_HUGEPAGES="Yes"                   \
    -p 5555:5555                                \
    --cpuset-cpus="0,1,2"                       \
    ghcr.io/open-traffic-generator/ixia-c-traffic-engine

  # start traffic engine on network interface eth0, TCP port 5556 and cpu cores 0, 3, 4
  docker run --privileged -d                    \
    -e OPT_LISTEN_PORT="5555"                   \
    -e ARG_IFACE_LIST="virtual@af_packet,eth0"  \
    -e OPT_NO_HUGEPAGES="Yes"                   \
    -p 5556:5555                                \
    --cpuset-cpus="0,3,4"                       \
    ghcr.io/open-traffic-generator/ixia-c-traffic-engine

  # start traffic engine on network interface eth0, TCP port 5557 and cpu cores 0, 5, 6
  docker run --privileged -d                    \
    -e OPT_LISTEN_PORT="5555"                   \
    -e ARG_IFACE_LIST="virtual@af_packet,eth0"  \
    -e OPT_NO_HUGEPAGES="Yes"                   \
    -p 5557:5555                                \
    --cpuset-cpus="0,5,6"                       \
    ghcr.io/open-traffic-generator/ixia-c-traffic-engine
  ```

### TODO: Multi-port per TE container

## Tests

### Clone Tests

  ```sh
    # Git clone sanppi-tests repo from github
    # This repository consists of end-to-end test scripts written in [snappi](https://github.com/open-traffic-generator/snappi).
    git clone https://github.com/open-traffic-generator/snappi-tests.git
    cd snappi-tests
  ```

### Setup Tests

  Ensure that the client setup meets the [Python Prerequisites](prerequisites.md#software-prerequisites).

* **Install `snappi`.**

    ```sh
      python -m pip install --upgrade "snappi"
    ```

* **Install test dependencies**

    ```sh
      python -m pip install --upgrade -r requirements.txt
    ```

* **Ensure that a `sample test` script executes successfully. For more information, see [test details](#test-details).**

    ```sh
      # provide intended API Server and port addresses
      vi tests/settings.json
      # run a test
      python -m pytest tests/raw/test_tcp_unidir_flows.py
    ```

## Test Details

The test scripts are based on `snappi client SDK` (auto-generated from the [Open Traffic Generator Data Model](https://github.com/open-traffic-generator/models)) and have been written by using `pytest`.  

You can access the Open Traffic Generator Data Model from any browser by using [https://<controller-host-ip>/docs/](https://<controller-host-ip>/docs/) and start scripting.

The test directory structure is as follows:

* `snappi-tests/tests/settings.json`: Global test configuration, that includes `controller` host, `traffic-engine` host, and `speed` settings.
* `snappi-tests/configs/`: Contains pre-defined traffic configurations in JSON, which can be loaded by test scripts.
* `snappi-tests/tests`: Contains end-to-end test scripts covering the most of the common use-cases.
* `snappi-tests/tests/utils/`: Contains the most commonly required helpers, that are used throughout the test scripts.
* `snappi-tests/tests/env/bin/python`: Python executable (inside virtual environment) to be used for test execution.

The most of the test scripts use the following format:

* `snappi-tests/tests/raw/test_tcp_unidir_flows.py`: For unidirectional flow use case.
* `snappi-tests/tests/raw/test_tcp_bidir_flows.py`: For using pre-defined JSON traffic config & bidirectional flow use case.
* `snappi-tests/tests/raw/test_basic_flow_stats.py`: For basic flow statistics validation use case.
* `<test to validate capture>`: For validating capture. TODO
* `<test to cover multiple protocol fields for different variation like fixed, list, counter>`: Some examples from gtpv2 [ethernet - ipv4 - udp - gtpv2 - ipv6] TODO
* `<test script for one arm testing>`: For one arm scenario TODO

To execute batch tests marked as `sanity`:

```sh
tests/env/bin/python -m pytest tests/py -m "sanity"
```

**NOTE on tests/settings.json**:

* When `controller` and `traffic-engine`s are located on separate systems (remote)

  ```json
  {
   "controller": "https://<controller-ip>",
    "ports": [
        "<traffic-engine-ip>:5555",
        "<traffic-engine-ip>:5556"
    ]
  }
  ```

* When `controller` and `traffic-engine`s are located on the same system (local - raw sockets)

  ```json
  {
   "controller": "https://localhost:8443",
    "ports": [
        "localhost:5555",
        "localhost:5556"
    ]
  }
  ```

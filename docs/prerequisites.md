# Ixia-c Prerequisites

* [Table of Contents](readme.md)

## System Prerequisites

### CPU and RAM

Recommended resources for basic use-case are as mentioned below,

- `ixia-c-controller`      - each instance requires at least 1 CPU core and 2GB RAM.
- `ixia-c-traffic-engine`  - each instance requires 2 dedicated CPU cores and 3GB dedicated RAM.
- `ixia-c-protocol-engine` - each instance requires 4 dedicated CPU cores and 1GB dedicated RAM per port.

For more granularity on resource requirements for advanced deployments, please refer to [Resource requirement for advanced deployments](#resource-requirement-for-advanced-deployments).

### OS and Software

- x86_64 Linux Distribution (Centos 7+ or Ubuntu 18+ have been tested)
- Docker 19+ (as distributed by https://docs.docker.com/)
- For test-environment,
  - Python 3.6+ (with `pip`) or
  - Go 1.17+

## Software Prerequisites

### Docker
- Docker Engine (Community Edition)

### Python

  - **Please make sure you have `python` and `pip` installed on your system.**

    You may have to use `python3` or `absolute path to python executable` depending on Python Installation on system, instead of `python`.

    ```sh
      python -m pip --help
    ```
    
    Please see [pip installation guide](https://pip.pypa.io/en/stable/installing/), if you don't see a help message.

  - **It is recommended that you use a python virtual environment for development.**

      ```sh
        python -m pip install --upgrade virtualenv
        # create virtual environment inside `env/` and activate it.
        python -m virtualenv env
        # on linux
        source env/bin/activate
        # on windows
        env\Scripts\activate on Windows
    ```

> If you do not wish to activate virtual env, you can use `env/bin/python` (or `env\scripts\python` on Windows) instead of `python`.


## Network Interface Prerequisites

In order for `ixia-c-traffic-engine` to function, several settings need to be tuned on the host system as described below.

1. Ensure existing network interfaces are `Up` and have `Promiscuous` mode enabled.
- following example illustrates above for a sample configured interface `eth1`

   ```sh
   # check interface details
   ip addr
   # configure as required
   ip link set eth1 up
   ip link set eth1 promisc on
   ```

2. (Optional) To deploy `ixia-c-traffic-engine` against veth interface pairs, you need to create them as follows:

   ```sh
   # create veth pair veth1 and veth2
   ip link add veth1 type veth peer name veth2
   ip link set veth1 up
   ip link set veth2 up
   ```

## Resource requirement for advanced deployments

The minimum memory and cpu requirements for each ixia-c components are captured in the following table. Kubernetes metrics server has been used to collect resource usage data. The memory represents the minimum working set memory required, and for protocol and traffic engines, varies depending on the number of co-located ports e.g. when multiple ports are added to a 'group' for LAG use-cases when a single test container has more than one test NIC connected to the DUT. The figures are in Mi or MB per container and does not include shared or cached memory across multiple containers/pods in a system.

                | --------------- | ------- | ------- | ------- | ------- | ------- |
                | Component       | 1 Port  | 2 Port  | 4 Port  | 6 Port  | 8 Port  |
                |                 | Default |         |         |         |         |
                | --------------- | ------- | ------- | ------- | ------- | ------- |
                | Protocol Engine |   350   |   420   |   440   |   460   |   480   |
                | --------------- | ------- | ------- | ------- | ------- | ------- |
                | Traffic Engine  |    60   |    70   |    90   |   110   |   130   |
                | --------------- | ------- | ------- | ------- | ------- | ------- |
                | Controller      |    25*  |         |         |         |         |
                | --------------- | ------- | ------- | ------- | ------- | ------- |
                | gNMI            |    15*  |         |         |         |         |
                | --------------- | ------- | ------- | ------- | ------- | ------- |

Note: Controller and gNMI have a fixed minimum memory requirement and is currently not dependent on number of test ports for the topology.

The cpu resource figures are in millicores.

                | ---------- | -------- | ------- | ---------- | ----- |
                |            | Protocol | Traffic | Controller | gNMI  |
                |            | Engine   | Engine  |            |       |
                | ---------- | -------- | ------- | ---------- | ----- |
                | Min CPU    |   200    |   200   |     10     |   10  |
                | ---------- | -------- | ------- | ---------- | ----- |

### Minimum and maximum resource usage based on various test configurations

Depending on the nature of test run, the memory and cpu resource requirements may vary across all ixia-c components. The following table captures the memory usage for LAG scenarios with varying numbers of member ports. The minimum value represents initial memory on topology deployment and maximum value indicates the peak memory usage during the test run. Figures are in Mi or MB.

                | ---------- | ------- | ------ | ------ | ------ | ------ | ------ |
                | Component  | Min/Max | 1 Port | 2 Port | 4 Port | 6 Port | 8 Port |
                | ---------- | ------- | ------ | ------ | ------ | ------ | ------ |
                |            | Max     |   348  |   423  |   455  |   464  |   492  |
                | Protocol   | ------- | ------ | ------ | ------ | ------ | ------ |
                | Engine     | Min     |   323  |   360  |   360  |   360  |   360  |
                | ---------- | ------- | ------ | ------ | ------ | ------ | ------ |
                |            | Max     |    58  |    68  |    90  |   111  |   134  |
                | Traffic    | ------- | ------ | ------ | ------ | ------ | ------ |
                | Engine     | Min     |    47  |    49  |    49  |    49  |    49  |
                | ---------- | ------- | ------ | ------ | ------ | ------ | ------ |
                |            | Max     |    21  |    21  |    23  |    24  |    25  |
                | Controller | ------- | ------ | ------ | ------ | ------ | ------ |
                |            | Min     |    13  |    13  |    13  |    13  |    13  |
                | ---------- | ------- | ------ | ------ | ------ | ------ | ------ |
                |            | Max     |    14  |    14  |    14  |    14  |    14  |
                | gNMI       | ------- | ------ | ------ | ------ | ------ | ------ |
                |            | Min     |     7  |     7  |     7  |     7  |     7  |
                | ---------- | ------- | ------ | ------ | ------ | ------ | ------ |

Following is the memory usage variation with scaling in control plane. The variation is on the number of BGP sessions (1K, 5K and 10K), in a back to back setup. Figures are in Mi or MB.

                | ---------- | ------- | ------ | ------ | ------ |
                | Component  | Min/Max |   1K   |   5K   |  10K   |
                | ---------- | ------- | ------ | ------ | ------ |
                |            | Max     |   516  |   906  |  1367  |
                | Protocol   | ------- | ------ | ------ | ------ |
                | Engine     | Min     |   323  |   323  |   323  |
                | ---------- | ------- | ------ | ------ | ------ |
                |            | Max     |    53  |   149  |   259  |
                | Controller | ------- | ------ | ------ | ------ |
                |            | Min     |    12  |    12  |    12  |
                | ---------- | ------- | ------ | ------ | ------ |
                |            | Max     |     7  |     7  |     7  |
                | gNMI       | ------- | ------ | ------ | ------ |
                |            | Min     |     7  |     7  |     7  |
                | ---------- | ------- | ------ | ------ | ------ |

Following is the memory usage variation with scaling in data plane. The variation is on the number of MPLS flows (10, 1K and 4K), in a back to back setup with labels provided by RSVP-TE control plane. Figures are in Mi or MB.

                | ---------- | ------- | ------ | ------ | ------ |
                | Component  | Min/Max |   10   |   1K   |   4K   |
                | ---------- | ------- | ------ | ------ | ------ |
                |            | Max     |    58  |    59  |    95  |
                | Traffic    | ------- | ------ | ------ | ------ |
                | Engine     | Min     |    47  |    47  |    47  |
                | ---------- | ------- | ------ | ------ | ------ |
                |            | Max     |    18  |    46  |   120  |
                | Controller | ------- | ------ | ------ | ------ |
                |            | Min     |    12  |    12  |    12  |
                | ---------- | ------- | ------ | ------ | ------ |
                |            | Max     |    10  |    17  |    28  |
                | gNMI       | ------- | ------ | ------ | ------ |
                |            | Min     |     7  |     7  |     7  |
                | ---------- | ------- | ------ | ------ | ------ |


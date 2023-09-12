# Ixia-c Prerequisites

* [Table of Contents](readme.md)

## System Prerequisites

### CPU and RAM

Recommended resources for basic use-case are as mentioned below,

- `ixia-c-controller`      - each instance requires at least 1 CPU core and 2GB RAM.
- `ixia-c-traffic-engine`  - each instance requires 2 dedicated CPU cores and 3GB dedicated RAM.
- `ixia-c-protocol-engine` - each instance requires 4 dedicated CPU cores and 1GB dedicated RAM per port.

For more granularity on resource requirements for advanced deployments, please refer to [Resource requirement for advanced deployments](reference_advanced_deployments.md).

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


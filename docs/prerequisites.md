# Ixia-c Prerequisites

## System Prerequisites

### CPU and RAM

The recommended resources for a basic use-case are as follows:

* `ixia-c-controller`: Each instance requires at least 1 CPU core and 2GB RAM.
* `ixia-c-traffic-engine`: Each instance requires 2 dedicated CPU cores and 3GB dedicated RAM.

* `ixia-c-protocol-engine`: Each instance requires 4 dedicated CPU cores and 1GB dedicated RAM per port.

For more granularity on resource requirements for advanced deployments, see [Resource requirements](reference/resource-requirements.md).

### OS and Software

* x86_64 Linux Distribution (Centos 7+ or Ubuntu 18+ have been tested)
* Docker 19+ (as distributed by <https://docs.docker.com/>)
* For test-environment,
    * Python 3.6+ (with `pip`) or
    * Go 1.17+

## Software Prerequisites

### Docker

* Docker Engine (Community Edition)

### Python

* **Ensure that you have `python` and `pip` installed on your system.**

    You may have to use `python3` or `absolute path to python executable` depending on the Python Installation on your system.

    ```sh
      python -m pip --help
    ```

    If you do not see a help message, see [pip installation guide](https://pip.pypa.io/en/stable/installing/), .

  * **It is recommended that you use a python virtual environment for development.**

    ```sh
        python -m pip install --upgrade virtualenv
        # create virtual environment inside `env/` and activate it.
        python -m virtualenv env
        # on linux
        source env/bin/activate
        # on windows
        env\Scripts\activate on Windows
    ```

> If you do not want to activate the virtual env, use `env/bin/python` (or `env\scripts\python` on Windows) instead of `python`.

## Network Interface Prerequisites

In order for `ixia-c-traffic-engine` to function, several settings need to be tuned on the host system. They are as follows:

1. Ensure that all the existing network interfaces are `Up` and have `Promiscuous` mode enabled.

* The following example illustrates a sample configured interface `eth1`

    ```sh
    # check interface details
      ip addr
    # configure as required
      ip link set eth1 up
      ip link set eth1 promisc on
    ```

2. (Optional) You need to create the `veth` interface pairs, to deploy the `ixia-c-traffic-engine` against them.

   ```sh
   # create veth pair veth1 and veth2
   ip link add veth1 type veth peer name veth2
   ip link set veth1 up
   ip link set veth2 up
   ```

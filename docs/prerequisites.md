# Ixia-c Prerequisites

* [Table of Contents](readme.md)

## System Prerequisites

### CPU and RAM

- `controller` - each instance requires at least 1 CPU core and 2GB RAM.
- `traffic-engine` - each instance requires 2 dedicated CPU cores and 3GB dedicated RAM (FIXME).

### OS and Software

- x86_64 Linux Distribution (Centos 7+ or Ubuntu 18+ have been tested)
- Python 2.7+ or Python 3.6+
- Docker 19+ (as distributed by https://docs.docker.com/)

## Software Prerequisites

### Docker

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

In order for Ixia-c Traffic Engine to function, several settings need to be tuned on the host system as described below.

1. Ensure existing network interfaces are `Up` and have `Promiscuous` mode enabled.

   ```sh
   # check interface details
   ip addr
   # configure as required
   ip link set eth1 up
   ip link set eth1 promisc on
   ```

2. (Optional) To deploy `traffic-engine` against veth interface pairs, you need to create them as follows:

   ```sh
   # create veth pair veth1 and veth2
   ip link add veth1 type veth peer name veth2
   ip link set veth1 up
   ip link set veth2 up
   ```
3. (Optional) To deploy traffic-engine against dpdk interface pairs, you need to configure them as follows:

  ``` sh
  # configure huge pages: each instance of traffic-engine requires 2GB of memory in huge pages;
  # this creates 3GB of memory in huge pages suitable for a single instance of traffic-engine.
  # to use multiple instances, please increase the number of huge pages accordingly.
  mkdir -p /mnt/huge
  mount -t hugetlbfs nodev /mnt/huge
  echo 1536 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
  # ensure it has been correctly set
  cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

  # get dpdk dev-bind script
  curl -sL https://raw.githubusercontent.com/DPDK/dpdk/main/usertools/dpdk-devbind.py --output dpdk-devbind.py

  # get NIC type and the PCI address using
  lshw -c network -businfo

  # load vfio_pci kernel module, if not already loaded
  modprobe vfio_pci

  # enable NOIOMMU mode
  echo Y > /sys/module/vfio/parameters/enable_unsafe_noiommu_mode

  # bind required test interfaces to vfio-pci (from output of 'lshw -c network -businfo')
  python dpdk-devbind.py --bind vfio-pci 0000:0b:00.0
  python dpdk-devbind.py --bind vfio-pci 0000:13:00.0

  # check status of aforementioned binding
  python dpdk-devbind.py --status
```


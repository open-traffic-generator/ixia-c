## What is Ixia-c Commercial Version?

Ixia-c Commercial is an extended modern, powerful and API-driven traffic generator designed to cater to the needs of hyper scalers, network hardware vendors and hobbyists alike.

It is a well supported commercial version, [Keysight Elastic Network Generator](https://www.keysight.com/us/en/products/network-test/protocol-load-test/keysight-elastic-network-generator.html) by [Keysight](https://www.keysight.com), with no restrictions on **performance and scalability**. Scripts written for the free version are **compatible** with this version.

It can be distributed / deployed as a multi-container application consisting of a [controller](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-controller), a [traffic-engine](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine) and an [app-usage-reporter](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter).

As a reference implementation of [Open Traffic Generator API](https://github.com/open-traffic-generator/models), Ixia-c supports client SDKs in various languages, most prevalent being [snappi](https://pypi.org/project/snappi/) (Python SDK).

## Free v/s Commercial Ixia-c

| Component                                               | Free               | Commercial         |
|---------------------------------------------------------|--------------------|--------------------|
| Features - Data Plane - Traffic Engine with Raw-Socket  |        Yes         |      Yes           |
| Features - Data Plane - Traffic Engine with DPDK        |        No          |      Yes           |
| Scale Per Test - # of Ports                             |        4           |      1024          |
| Scale Per Test - # of Flows                             |        256         |      256           |
| License                                                 |        Free        |      Paid          |


## How to access Ixia-c Commercial Version?

* Create [GitHub](https://github.com/) account.

*  Reach us over <a href="docs/support.md"><img alt="Slack Status" src="https://img.shields.io/badge/slack-support-blue?logo=slack"></a> to access commercial version of Ixia-c.

* Once access is provided by [Keysight](https://www.keysight.com), you need to do docker login using your Github username and personal-access-token. [Read more](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

```bash
  docker login ghcr.io -u <username>
```

## Ixia-c Commercial Version Docker Images

| Component                     | Version                                                                     | Docker Image      |
|-------------------------------|-----------------------------------------------------------------------------|-------------------|
| ixia-c-controller             | [0.0.1-3027](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-controller)       | ghcr.io/open-traffic-generator/licensed/ixia-c-controller   |
| ixia-c-traffic-engine         | [1.4.1.29](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)     | ghcr.io/open-traffic-generator/ixia-c-traffic-engine      |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter) | ghcr.io/open-traffic-generator/ixia-c-app-usage-reporter     |


### Quick Start

Before proceeding, please ensure [system prerequisites](/docs/prerequisites.md) are met and DPDK interfaces have been configured as mentioned in [network interface requirements](#network-interface-requirement).

* Deploy Ixia-c with DPDK PCI Passthrough mode

  ```bash
  # start commercial ixia-c controller
  docker run -d --network=host ghcr.io/open-traffic-generator/licensed/ixia-c-controller:0.0.1-3027 --accept-eula
  docker run --net=host -d ghcr.io/open-traffic-generator/ixia-c-app-usage-reporter:0.0.1-37

  # start ixia-c traffic engine on dpdk interface with PCI address 0000:0b:00.0, on TCP port 5555
    docker run --privileged -d \
    -e OPT_LISTEN_PORT='5555' \
    -e ARG_IFACE_LIST='pci@0000:0b:00.0' \
    -p 5555:5555 \
    -v /mnt/huge:/mnt/huge \
    -v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages \
    -v /sys/bus/pci/drivers:/sys/bus/pci/drivers \
    -v /sys/devices/system/node:/sys/devices/system/node \
    ghcr.io/open-traffic-generator/ixia-c-traffic-engine:1.4.1.29

  ```

  > Once the containers are up, accessing https://controller-ip/docs/ will open up an interactive REST API documentation. Check out [deployment guide](docs/deployments.md) for more details.

### Network Interface Requirements

``` bash
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



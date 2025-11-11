<h1 align="center">
  <br>
  Ixia-C
  <br>
</h1>

<h4 align="center">
  Ixia-C - A powerful traffic generator based on <a href="https://github.com/open-traffic-generator/models" target="_blank">Open Traffic Generator API</a>
</h4>

<p align="center">
  <a href="https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller"><img alt="Release v1.41.0-1" src="https://img.shields.io/badge/release-v1.41.0--1-brightgreen"></a>
  <a href="https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.41.0/artifacts/openapi.yaml"><img alt="Open Traffic Generator v1.41.0" src="https://img.shields.io/badge/open--traffic--generator-v1.41.0-brightgreen"></a>
  <a href="https://pypi.org/project/snappi/1.41.0"><img alt="snappi v1.41.0" src="https://img.shields.io/badge/snappi-v1.41.0-brightgreen"></a>
  <a href="docs/news.md"><img alt="news" src="https://img.shields.io/badge/-news-blue?logo=github"></a>
  <a href="docs/contribute.md"><img alt="news" src="https://img.shields.io/badge/-contribute-blue?logo=github"></a>
  <a href="docs/support.md"><img alt="Slack Status" src="https://img.shields.io/badge/slack-support-blue?logo=slack"></a>
</p>

<p align="center">
  <a href="#quick-start">Quick Start</a> &nbsp;•&nbsp;
  <a href="#key-features">Key Features</a> &nbsp;•&nbsp;
  <a href="docs/user-guide-introduction.md">Documentation</a> &nbsp;•&nbsp;
  <a href="docs/usecases.md">Use Cases</a> &nbsp;•&nbsp;
  <a href="docs/roadmap.md">Roadmap</a> &nbsp;•&nbsp;
  <a href="docs/faq.md">FAQ</a>
  <br>
</p>

### What is Ixia-C ?

- A modern, powerful and **API-driven** traffic generator designed to cater to the needs of hyper-scalers, network hardware vendors and hobbyists alike.

- **Free for basic use-cases** and distributed / deployed as a multi-container application consisting primarily of a [controller](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller), a [traffic-engine](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine) and a [protocol-engine](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine).

- As a reference implementation of [Open Traffic Generator API](https://github.com/open-traffic-generator/models), supports client SDKs in various languages, most prevalent being [snappi](https://github.com/open-traffic-generator/snappi) (Python SDK) and [gosnappi](https://github.com/open-traffic-generator/snappi/tree/main/gosnappi).

<p align="center">
<img src="docs/res/ixia-c.drawio.svg" alt="Ixia-C deployment for two-arm test with DUT">
</p>

> [Keysight](https://www.keysight.com) also offers a well supported commercial version, [Keysight Elastic Network Generator (KENG)](https://www.keysight.com/us/en/products/network-test/protocol-load-test/keysight-elastic-network-generator.html), with no restrictions on **performance and scalability**. Scripts written for the community version are **compatible** with this version.

### Quick Start

Please ensure that following prerequisites are met by the setup:
  - At least **2 x86_64 CPU cores** and **7GB RAM**, preferably running **Ubuntu 22.04 LTS** OS
  - **Python 3.8+** (and **pip**) or **Go 1.19+**
  - **Docker Engine** (Community Edition)


#### 1. Deploy Ixia-C

```bash
# clone this repository
git clone --recurse-submodules https://github.com/open-traffic-generator/ixia-c.git && cd ixia-c

# create a veth pair and deploy ixia-c containers where one traffic-engine is bound
# to each interface in the pair, and controller is configured to figure out how to
# talk to those traffic-engine containers
cd conformance && ./do.sh topo new dp
```

#### 2. Setup and run standalone test using [snappi](https://github.com/open-traffic-generator/snappi) or [gosnappi](https://github.com/open-traffic-generator/snappi/tree/main/gosnappi)

```bash
# change dir to conformance if you haven't already
cd conformance

# setup python virtual environment and install dependencies
./do.sh prepytest

# run standalone snappi test that configures and sends UDP traffic
# upon successful run, flow metrics shall be printed on console
./do.sh pytest examples/test_quickstart.py

# optionally, go equivalent of the test can be run like so
./do.sh gotest examples/quickstart_test.go
```

> Checkout the contents of [test_quickstart.py](https://github.com/open-traffic-generator/conformance/blob/22563e20fe512ef13baf44c1bc69bc59f87f6c25/examples/test_quickstart.py) and equivalent [quickstart_test.go](https://github.com/open-traffic-generator/conformance/blob/22563e20fe512ef13baf44c1bc69bc59f87f6c25/examples/quickstart_test.go) for quick explanation on test steps.

#### 3. Optionally, run test using [curl](https://curl.se/)

We can also pass equivalent **JSON configuration** directly to **controller**, just by using **curl**.
The description of each node in the configuration is detailed in self-updating  [online documentation](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.41.0/artifacts/openapi.yaml).


```bash
# push traffic configuration
curl -skL https://localhost:8443/config -H "Content-Type: application/json" -d @conformance/examples/quickstart_config.json

# start transmitting configured flows
curl -skL https://localhost:8443/control/state -H "Content-Type: application/json" -d @conformance/examples/quickstart_control.json

# fetch flow metrics
curl -skL https://localhost:8443/monitor/metrics -H "Content-Type: application/json" -d @conformance/examples/quickstart_metrics.json
```

### Key Features

* High Performance
  * Run on servers or Keysight hardware (commercial version only)
  * Generate kbps to Tbps of traffic using same script
  * 10Gbps @ 64 byte frame size using one Xeon class core (commercial version only)
  * Built using [DPDK](https://www.dpdk.org)
* Fast REST API for automation
  * Easily integrate with test frameworks like [pytest](https://www.pytest.org)
  * Easily integrate into CI/CD pipelines with Jenkins, GitHub, GitLab
* Up to 256 flows per port.  Each Flow supports:
  * Packet Templates for Ethernet, VLAN, VXLAN, GTPv1, GTPv2, IPv4, IPv6, ICMP, ICMPv6, GRE, UDP, & TCP.  More protocols are on the way.
  * Ability to use tools like Scapy to add headers for unsupported protocols.
  * Manipulation of any field in the packet headers
  * Patterns to modify common packet header fields to generate millions of unique packets
  * Ability to track flows based on common packet header fields
  * Configurable frame size
  * Rate specification in pps (packets per second) or % line-rate
  * Ability to send bursts
* Statistics
  * Per-port and per-flow
  * One way latency measurements (min, max, average) on a per flow basis
* Capture
  * Packets with filters
  * Write to PCAP or redirect to tcpdump

## Copyright notice

© Copyright Keysight Technologies, Inc. 2021, 2022, 2023


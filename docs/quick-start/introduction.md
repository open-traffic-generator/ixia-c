## What is Ixia-c ?

- A modern, powerful and **API-driven** traffic generator designed to cater to the needs of hyper-scalers, network hardware vendors and hobbyists alike.

- **Free for basic use-cases** and distributed / deployed as a multi-container application consisting primarily of a [controller](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller), a [traffic-engine](https://github.com/orgs/open-traffic-generator/packages/container/package/Ixia-c-traffic-engine) and a [protocol-engine](https://github.com/orgs/open-traffic-generator/packages/container/package/Ixia-c-protocol-engine).

- As a reference implementation of [Open Traffic Generator API](https://github.com/open-traffic-generator/models), supports client SDKs in various languages, most prevalent being [snappi](https://github.com/open-traffic-generator/snappi) (Python SDK) and [gosnappi](https://github.com/open-traffic-generator/snappi/tree/main/gosnappi).

<p align="center">
<img src="/res/ixia-c.drawio.svg" alt="Ixia-c deployment for two-arm test with DUT">
</p>

## Quick Start

Please ensure that following prerequisites are met by the setup:

* At least **2 x86_64 CPU cores** and **7GB RAM**, preferably running **Ubuntu 22.04 LTS** OS
* **Python 3.8+** (and **pip**) or **Go 1.19+**
* **Docker Engine** (Community Edition)


### 1. Deploy Ixia-c

```bash
# clone this repository
git clone --recurse-submodules https://github.com/open-traffic-generator/Ixia-c.git && cd Ixia-c

# create a veth pair and deploy Ixia-c containers where one traffic-engine is bound
# to each interface in the pair, and controller is configured to figure out how to
# talk to those traffic-engine containers
cd conformance && ./do.sh topo new dp
```

### 2. Setup and run standalone test using [snappi](https://github.com/open-traffic-generator/snappi) or [gosnappi](https://github.com/open-traffic-generator/snappi/tree/main/gosnappi)

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

> Checkout the contents of [test_quickstart.py](https://github.com/open-traffic-generator/conformance/blob/22563e20fe512ef13baf44c1bc69bc59f87f6c25/examples/test_quickstart.py) and equivalent [quickstart_test.go](https://github.com/open-traffic-generator/conformance/blob/22563e20fe512ef13baf44c1bc69bc59f87f6c25/examples/quickstart_test.go) for quick explanation on test steps

### 3. Optionally, run test using [curl](https://curl.se/)

We can also pass equivalent **JSON configuration** directly to **controller**, just by using **curl**.
The description of each node in the configuration is detailed in self-updating  [online documentation](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.13.0/artifacts/openapi.yaml).


```bash
# push traffic configuration
curl -skL https://localhost:8443/config -H "Content-Type: application/json" -d @conformance/examples/quickstart_config.json

# start transmitting configured flows
curl -skL https://localhost:8443/control/state -H "Content-Type: application/json" -d @conformance/examples/quickstart_control.json

# fetch flow metrics
curl -skL https://localhost:8443/monitor/metrics -H "Content-Type: application/json" -d @conformance/examples/quickstart_metrics.json
```

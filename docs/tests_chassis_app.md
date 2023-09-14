# Ixia Chassis/Appliances tests
 This section describes how to use KENG with Keysight's Ixia hardware chassis.

**Prerequisites**

To run KENG tests with Ixia hardware, the following prerequisites must be satisfied:

- You must have access to Keysight Elastic Network Generator (KENG) images and a valid KENG license. For information on how to deploy and activate a KENG license, see the Licensing section of the User Guide).
- The test hardware must be Keysight Ixia Novus or AresOne [Network Test Hardware](https://www.keysight.com/us/en/products/network-test/network-test-hardware.html) with [IxOS](https://support.ixiacom.com/ixos-software-downloads-documentation) 9.20 Patch 4 or higher.  
**NOTE:**  Currently, only Linux-based IxOS platforms are supported with KENG.
- There must be physical link connectivity between the test ports on the Keysight Ixia Chassis and the devices under test (DUTs).
- You must have a Linux host or virtual machine (VM) with sudo permissions and Docker support.

	Below is an example of deploying an Ubuntu VM otg using [multipass](https://multipass.run/).  You can deploy using the means that you are most familiar with.

	`multipass launch 22.04 -n otg -c4 -m8G -d32G`

	`multipass shell otg`

- [Docker](https://docs.docker.com/engine/install/ubuntu/). Depending on your Linux distribution, follow the steps outlined at one of the following URLs:
  - [Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
  - [Debian](https://docs.docker.com/engine/install/debian/)
  - [CentOS](https://docs.docker.com/engine/install/centos/)

	After docker is installed, add the current user to the docker group:

	`sudo usermod -aG docker $USER`

- Python3 (version 3.9 or higher), pip and virtualenv
	
	Use the following command to install Python, pip, and virtualenv:

	`sudo apt install python3 python3-pip python3.10-venv -y`

- [Go](https://go.dev/dl/) version 1.19 or later, if gRPC or gNMI API access is needed.

	Use the following command to install Go:

	`sudo snap install go --channel=1.19/stable --classic`

- git and envsubst commands (typically installed by default)

	Use the following command to install git and envsubst if they are not already installed:

	`sudo apt install git gettext-base -y`

**Deployment Layout**

The image below shows a complete topology of a KENG test environement.

To run tests with KENG, the tests must be written using the  OpenTrafficGenerator (OTG) API and gNMI APIs.

If KENG is deployed successfully, the services shown in the block labeled Keysight Elastic Network Generator will be running.

The KENG services interact with the Keysight Ixia hardware chassis to configure protocols and data traffic.

![ ](res/hw-server.drawio.svg)

**Deploying KENG**

The Docker Compose tool provides is a convenient way to deploy and bootstrap KENG.

Tests cannot be run until the KENG services are deployed and running.

The following procedure shows an example of how to deploy using Docker Compose.


1. Copy the contents shown below into a `compose.yaml` file.



```
services:
  ixia-c-controller:
    image: ghcr.io/open-traffic-generator/licensed/ixia-c-controller:0.0.1-4139
    restart: always
    depends_on:
      ixia-c-ixhw-server:
        condition: service_started
    command:
      - "--accept-eula"
      - "--debug"
      - "--ixia-c-ixhw-server"
      - "ixia-c-ixhw-server:5001"
    ports:
      - "40051:40051"
logging:
      driver: "local"
      options:
        max-size: "100m"
        max-file: "10"
        mode: "non-blocking"
  ixia-c-ixhw-server:
    image: ghcr.io/open-traffic-generator/ixia-c-ixhw-server:0.11.10-2
    restart: always
    command:
      - "dotnet"
      - "otg-ixhw.dll"
      - "--trace"
      - "--log-level"
      - "trace"
    logging:
      driver: "local"
      options:
        max-size: "100m"
        max-file: "10"
        mode: "non-blocking"
  ixia-c-gnmi-server:
    image: ghcr.io/open-traffic-generator/ixia-c-gnmi-server:1.11.16
    restart: always
    depends_on:
      ixia-c-controller:
        condition: service_started
    command:
      - "-http-server"
      - "https://ixia-c-controller:8443"
      - "--debug"
    ports:
      - "50051:50051"
logging:
      driver: "local"
      options:
        max-size: "100m"
        max-file: "10"
        mode: "non-blocking"
```

2. Start the Compose tool:
  
	`docker compose up -d`

 
3. Use the `docker ps` command to verify that KENG services are running:

	`docker ps`

The list of containers should include:
- `ixia-c-controller`
- `ixia-c-ixhw-server`
- `ixia-c-gnmi-server`

When the controller and ixhw-server services are running, the deployment is bootstrapped ready to run a test.

**Sample Test**

Before attempting the sample test, the deployment must be bootstrapped and KENG services running as described in the deployment section above.

The sample test uses 2 back-to-back ports on a chassis and is named `otg-flows.py` in the example shown below.

1. Use the following commands to set up `virtualenv` for Python:

	`python3 -m venv venv`

	`source venv/bin/activate`

	`pip install -r requirements.txt`

2. To run flows using the `snappi` script and report port metrics, use:

	`otg-flows.py -m port`

3. To run flows using the snappi script reporting port flow, use:

	`otg-flows.py -m flow`

```
# Sample Test ?otg-flows.py?
#!/usr/bin/env python3
# Copyright ? 2023 Open Traffic Generator
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

import sys, os
import argparse
import snappi

def port_metrics_ok(api, req, packets):
    res = api.get_metrics(req)
    print(res)
    if packets == sum([m.frames_tx for m in res.port_metrics]) and packets == sum([m.frames_rx for m in res.port_metrics]):
        return True

def flow_metrics_ok(api, req, packets):
    res = api.get_metrics(req)
    print(res)
    if packets == sum([m.frames_tx for m in res.flow_metrics]) and packets == sum([m.frames_rx for m in res.flow_metrics]):
        return True

def wait_for(func, timeout=15, interval=0.2):
    """
    Keeps calling the `func` until it returns true or `timeout` occurs
    every `interval` seconds.
    """
    import time

    start = time.time()

    while time.time() - start <= timeout:
        if func():
            return True
        time.sleep(interval)

    print("Timeout occurred !")
    return False

def arg_metric_check(s):
    allowed_values = ['port', 'flow']
    if s in allowed_values:
        return s
    raise argparse.ArgumentTypeError(f"metric has to be one of {allowed_values}")

def parse_args():
    # Argument parser
    parser = argparse.ArgumentParser(description='Run OTG traffic flows')

    # Add arguments to the parser
    parser.add_argument('-m', '--metric',    required=False, help='metrics to monitor: port | flow',
                                             default='port',
                                             type=arg_metric_check)
    # Parse the arguments
    return parser.parse_args()

def main():
    """
    Main function
    """
    # Parameters
    args = parse_args()

    API = "https://localhost:8443"
   #Replace with values matching your setup/equipment. For example, if IxOS management IP is 10.10.10.10 and you need to use ports 14 and 15 in the slot number 2:
  # P1_LOCATION ="10.10.10.10;2;14"
  # P2_LOCATION ="10.10.10.10;2;15"

    api = snappi.api(location=API, verify=False)
    cfg = api.config()

    # config has an attribute called `ports` which holds an iterator of type
    # `snappi.PortIter`, where each item is of type `snappi.Port` (p1 and p2)
    p1, p2 = cfg.ports.port(name="p1", location=P1_LOCATION).port(name="p2", location=P2_LOCATION)

    # config has an attribute called `flows` which holds an iterator of type
    # `snappi.FlowIter`, where each item is of type `snappi.Flow` (f1, f2)
    f1, f2 = cfg.flows.flow(name="flow p1->p2").flow(name="flow p2->p1")

    # and assign source and destination ports for each
    f1.tx_rx.port.tx_name, f1.tx_rx.port.rx_name = p1.name, p2.name
    f2.tx_rx.port.tx_name, f2.tx_rx.port.rx_name = p2.name, p1.name

    # configure packet size, rate and duration for both flows
    f1.size.fixed, f2.size.fixed = 128, 256
    for f in cfg.flows:
        # send 1000 packets and stop
        f.duration.fixed_packets.packets = 1000
        # send 1000 packets per second
        f.rate.pps = 1000
        # allow fetching flow metrics
        f.metrics.enable = True

    # configure packet with Ethernet, IPv4 and UDP headers for both flows
    eth1, ip1, udp1 = f1.packet.ethernet().ipv4().udp()
    eth2, ip2, udp2 = f2.packet.ethernet().ipv4().udp()

    # set source and destination MAC addresses
    eth1.src.value, eth1.dst.value = "00:AA:00:00:04:00", "00:AA:00:00:00:AA"
    eth2.src.value, eth2.dst.value = "00:AA:00:00:00:AA", "00:AA:00:00:04:00"

    # set source and destination IPv4 addresses
    ip1.src.value, ip1.dst.value = "10.0.0.1", "10.0.0.2"
    ip2.src.value, ip2.dst.value = "10.0.0.2", "10.0.0.1"

    # set incrementing port numbers as source UDP ports
    udp1.src_port.increment.start = 5000
    udp1.src_port.increment.step = 2
    udp1.src_port.increment.count = 10

    udp2.src_port.increment.start = 6000
    udp2.src_port.increment.step = 4
    udp2.src_port.increment.count = 10

    # assign list of port numbers as destination UDP ports
    udp1.dst_port.values = [4000, 4044, 4060, 4074]
    udp2.dst_port.values = [8000, 8044, 8060, 8074, 8082, 8084]

    # print resulting otg configuration
    print(cfg)

    # push configuration to controller
    api.set_config(cfg)

    # start transmitting configured flows
    ts = api.control_state()
    ts.traffic.flow_transmit.state = snappi.StateTrafficFlowTransmit.START
    api.set_control_state(ts)

    # Check if the file argument is provided
    if args.metric == 'port':
        # create a port metrics request and filter based on port names
        req = api.metrics_request()
        req.port.port_names = [p.name for p in cfg.ports]
        # include only sent and received packet counts
        req.port.column_names = [req.port.FRAMES_TX, req.port.FRAMES_RX]

        # fetch port metrics
        res = api.get_metrics(req)

        # wait for port metrics to be as expected
        expected = sum([f.duration.fixed_packets.packets for f in cfg.flows])
        assert wait_for(lambda: port_metrics_ok(api, req, expected)), "Metrics validation failed!"

    elif args.metric == 'flow':
        # create a flow metrics request and filter based on port names
        req = api.metrics_request()
        req.flow.flow_names = [f.name for f in cfg.flows]

        # fetch metrics
        res = api.get_metrics(req)

        # wait for flow metrics to be as expected
        expected = sum([f.duration.fixed_packets.packets for f in cfg.flows])
        assert wait_for(lambda: flow_metrics_ok(api, req, expected)), "Metrics validation failed!"

if __name__ == '__main__':
    sys.exit(main())
```




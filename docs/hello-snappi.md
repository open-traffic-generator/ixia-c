<div align="center">
  <h1>Hello, <img width="150" height="30px" src="https://github.com/open-traffic-generator/snappi/blob/main/snappi-logo.png" alt="snappi"></img> !</h1>
  <h4>Your first snappi script</h4>
</div>

- [Table of Contents](readme.md)
  - Hello, snappi !
    * [Use Case](#use-case)
    * [Setup](#setup)
    * [Create API Handle](#create-api-handle)
    * [Config](#config)
    * [Ports](#ports)
    * [Config](#config)
    * [Layer1](#layer1)
    * [Capture](#capture)
    * [Flows](#flows)
    * [Protocol Headers](#protocol-headers)
    * [Start Capture and Traffic](#start-capture-and-traffic)
    * [Fetch and Validate Metrics](#fetch-and-validate-metrics)
    * [Fetch and Validate Captures](#fetch-and-validate-captures)
    * [Putting It All Together](#putting-it-all-together)

### Use Case

In this tutorial, we will walk through some key elements required to write a **snappi script** exercising the topology below.

* Send 1000 UDP packets back and forth between interfaces eth1 & eth2 at a rate of 1000 packets per second.
* Ensure that indeed correct number of valid UDP packets are received on both ends using port capture and port metrics.

The script [hello_snappi.py](https://github.com/open-traffic-generator/snappi-tests/tree/820fac6/scripts/hello_snappi.py) covers this extensively.
<div align="center">
  <img src="res/ixia-c.drawio.svg"></img>
</div>

### Setup

We start by setting up the topology as described above using [deployment steps for two-arm scenario](deployments.md#two-arm-scenario).

```sh
git clone --recurse-submodules https://github.com/open-traffic-generator/ixia-c && cd ixia-c
docker-compose -f deployments/raw-two-arm.yml up -d
```

And installing python packages:

* [snappi](https://pypi.org/project/snappi/) - client SDK auto-generated from [Open Traffic Generator API](https://github.com/open-traffic-generator/models).
* [dpkt](https://pypi.org/project/dpkt/) - for processing `.pcap` files.

```sh
python -m pip install --upgrade snappi==0.6.12 dpkt
```

### Create API Handle

The first step in any snappi script is to import the `snappi` package and instantiate an `api` object, where `location` parameter takes the HTTPS address of the controller and `verify` is used to turn off insecure certificate warning. 

If the controller is deployed with a non-default TCP port using [deployment parameters](deployments.md#deployment-parameters), it must be specified explicitly in the address (default is 443).

```python
import snappi
api = snappi.api(location='https://localhost', verify=False)
# or with non-default TCP port
api = snappi.api(location='https://localhost:8080', verify=False)
```

<details>
<summary><b>Expand</b> this section for details on an optional parameter <code>ext</code> which specifies <i>snappi extension</i> to be loaded.</summary><br/>

If a traffic generator doesn't natively support [Open Traffic Generator API](https://github.com/open-traffic-generator/models), snappi can be extended to write a translation layer to bridge the gap. An example is [snappi extension for IxNetwork](https://pypi.org/project/snappi-ixnetwork/) which can be installed using `python -m pip install --upgrade snappi[ixnetwork]`.

```python
import snappi
# location here refers to HTTPS address of IxNetwork API Server
api = snappi.api(location="https://localhost", ext='ixnetwork', verify=False)
```

</details>

### Config

We now need to construct traffic configuration to be sent to controller. We'll need `api` object created previously, which acts as a handle for:

* Creating new objects for API request (or response)

  ```python
  cfg = api.config()
  ```

  > `api.config()` is a factory function for creating an empty `snappi.Config` object, which encapsulates the parameters that controller needs to configure different aspects of traffic generator. In next sections, we'll discuss in details about these configuration parameters.

* Initiating API requests (and getting back response)

  ```python
  # this pushes object of type `snappi.Config` to controller
  api.set_config(cfg)
  # this retrieves back object of type `snappi.Config` from controller
  cfg = api.get_config()
  ```

  > By default, API requests in snappi are made over HTTPS with payloads as a JSON string. Since each object in snappi inherits `SnappiObject` or `SnappiIter`, they all share a common method called `.serialize()` and `deserialize()`, used internally during API requests, for valid conversion to / from a JSON string. We'll discuss about more such conveniences offered by snappi along the way.

<details>
<summary><b>Expand</b> this section for details on how to effectively navigate through <a href="https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.7/openapi.yaml">snappi API documentation</a>.</summary><br/>

The objects and methods (for API calls) in snappi are auto-generated from an [Open API Generator YAML file](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.7/openapi.yaml). This file adheres to [OpenAPI Specification](https://github.com/OAI/OpenAPI-Specification), which can (by design) also be rendered as an interactive API documentation.

[ReDoc](https://redocly.github.io/redoc/) is an open-source tool that does this. It accepts a link to valid OpenAPI YAML file and generates a document where all the methods (for API calls) are mentioned in the left navigation bar and for each selected method, there's a request / response body description in the center of the page. These descriptions lay out the entire object tree documenting each node in details.

The snappi API documentation linked above will always point to API version **v0.6.7**. To use a different API version instead:

* Identify API version by opening <a href="https://github.com/open-traffic-generator/snappi/releases/download/v0.6.12/models-release">this link</a> in a browser and replacing **v0.6.12** in URL with intended snappi version.

* Open <a href="https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.7/openapi.yaml">this link</a> in a browser after replacing **v0.6.7** in URL with intended API version.

</details>

### Ports

Each instance of a **traffic-engine** is usually referred to as a `port`. They're used to send or receive traffic (as they're directly bound to network interfaces) and hence, the config object we created previously needs to know about their:
* `name` - to uniquely identify each port.
* `location` - a DNS name or TCP socket address of traffic-engine (format is specific to a given traffic-engine implementations).

Note, unlike config, creating a new port using `p = api.port()` is not required (and hence not supported), because `snappi.Port` is never used directly as an API request or response.

```python
# config has an attribute called `ports` which holds an iterator of type
# `snappi.PortIter`, where each item is of type `snappi.Port` (p1 and p2)
p1, p2 = cfg.ports.port(name="p1", location="localhost:5555").port(
    name="p2", location="localhost:5556"
)
```

> Instead of using `append()`, we use factory method `.port()` on `cfg.ports` which instantiates `snappi.Port`, appends it to `cfg.ports` and returns the entire iterator (so that it can be unpacked or accessed like a simple list). This is applicable to other iterators in snappi, e.g. flows, capture and layer1.

<details>
<summary><b>Expand</b> this section for more examples on snappi iterators.</summary>

```python
p = cfg.ports.port(name='p1').port(name='p2')
assert p[0].name == 'p1'

p = cfg.ports.port(name='p3')
assert p[2].name == 'p3'

# This will remove 3rd index port
cfg.ports.remove(2)
p4 = cfg.ports.port(name='p4')[-1]
assert p4.name == 'p4'

# This will clear all the ports
cfg.ports.clear()
p5 = cfg.ports.port(name='p5')[0]
assert p5.name == 'p5'

p6 = cfg.ports.add(name='p6')
assert p6.name == 'p6'

p7 = p6.clone()
p7.name = 'p7'
cfg.ports.append(p7)
assert p7.name == 'p7'
```

</details>

### Layer1

The `ports` we configured previously may require setting `layer1` (physical layer) properties like speed, MTU, promiscuous mode, etc.

```python
# config has an attribute called `layer1` which holds an iterator of type
# `snappi.Layer1Iter`, where each item is of type `snappi.Layer1` (ly)
ly = cfg.layer1.layer1(name="ly")[-1]
ly.speed = ly.SPEED_1_GBPS
# set same properties on both ports
ly.port_names = [p1.name, p2.name]
```

> Note how instead of setting an arbitrary value to `ly.speed`, we set an enum value (all uppercase) defined in `ly`'s namespace. These enum values are detailed in snappi API documentation.

### Capture

Since we also intend to start capturing packets on both ports, we enable `capture` like so.

```python
# config has an attribute called `captures` which holds an iterator of type
# `snappi.CaptureIter`, where each item is of type `snappi.Capture` (cp)
cp = cfg.captures.capture(name="cp")[-1]
cp.port_names = [p1.name, p2.name]
```

### Flows

We now get to the meat of our script, the part that sets up the traffic `flows`! Each flow in snappi can be characterized based on **tx/rx endpoints**, **duration**, **packet contents / rate / size**, etc.

Here we configure two flows, one originating from port `p1` and the other from port `p2`.

```python
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
```

Optionally, flow duration and rate could be configured like so:

```python
# send packets for 5 seconds and stop (we could also specify duration in terms
# of continuous or bursts)
f.duration.fixed_seconds.seconds = 5
# send packets at 50% of configured speed (we could also specify absolute rates
# in terms of bps, kbps, etc.)
f.rate.percentage = 50
```

Note that `f.rate` is **polymorphic** in nature, in that, it can only be used to set either `pps` or `percentage`, but not both. A special attribute `choice` is used in such cases, which holds the name of attribute currently in use.

In snappi, `f.rate.choice` is automatically set based on the attribute that was last accessed. e.g.

```python
f.rate.pps = 100
print(f.rate.serialize())

# output
{
  "choice": "pps",
  "pps": 100
}
```

>We are able to set (or access) `f1.rate.pps` without instantiating object of type `snappi.FlowRate` held by `f1.rate`. This is because **accessing an uninitialized attribute** automatically initializes it with the type of object it holds.  

### Protocol Headers

Packets sent out in a `flow` needs to be described in terms of underlying **protocol** and **payload** contents. If no such description is provided, a simple ethernet frame is configured by default.  

Here's how we construct our packet by adding Ethernet, IPv4 and UDP headers (strictly in an order it should appear in TCP/IP stack).

```python
# configure packet with Ethernet, IPv4 and UDP headers for both flows
eth1, ip1, udp1 = f1.packet.ethernet().ipv4().udp()
eth2, ip2, udp2 = f2.packet.ethernet().ipv4().udp()
```

`f1.packet` is an iterator which holds items of type `snappi.FlowHeader` (a **polymorphic** type instead of **non-polymorphic** types we've seen so far). Hence, snappi automatically does following under the hood:

```python
eth1, ip1, udp1 = f.packet.header().header().header()
# set enum choice for each header and initialize intended object with empty
# fields just by accessing it
eth1.choice = e.ETHERNET
eth1.ethernet
ip1.choice = i.IPV4
ip1.ipv4
udp1.choice = u.UDP
udp1.udp
```

At this point, the headers still contain default field values. Next, we'll assign specific values to various header fields.

> The checksum and length fields in most headers are automatically calculated and inserted before sending out the packet.

#### Setup Ethernet

For Ethernet header, we simply assign static source and destination MAC address value. The ethernet type field is *automatically* set to `0x800` since the next header is IPv4.

```python
# set source and destination MAC addresses
eth1.src.value, eth1.dst.value = "00:AA:00:00:04:00", "00:AA:00:00:00:AA"
eth2.src.value, eth2.dst.value = "00:AA:00:00:00:AA", "00:AA:00:00:04:00"
```

#### Setup IPv4

For IPv4 header as well, we assign static source and destination IPv4 address value. The IP protocol field is *automatically* set to `0x11` since the next protocol in the stack is UDP.

```python
# set source and destination IPv4 addresses
ip1.src.value, ip1.dst.value = "10.0.0.1", "10.0.0.2"
ip2.src.value, ip2.dst.value = "10.0.0.2", "10.0.0.1"
```

#### Setup UDP

With UDP header, we'll do something more interesting. Instead of assigning a single (fixed) value for header fields, which we did previously, we'll assign multiple values.

We can achieve this in snappi by using `increment`, `decrement` and `list` patterns.

```python
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
```

The snippet above will result in a sequence of packets as shown in the figure below.
<div align="center">
  <br>
  <img src="res/hello-snappi-packets.png"></img>
</div>
<br>

> The patterns for headers fields in snappi provide a very flexible way to generate millions of unique packets to test DuT functionalities, like hashing based on 5-tuple. Checkout [common snappi constructs](snappi-constructs.md) for more details.

### Start Capture and Traffic

Now that we've added all the intended configuration parameters to `cfg`, we need to:
* Push it to the controller, so that connection with intended traffic-engines can be established and intended configuration is applied (to each one of them).
* Start capturing packets on configured ports
* Start sending packets from configured ports

Every time `api.set_config()` is called, it essentially resets the state of the controller by **tearing down** any previous connections with traffic-engines and **overriding** any previous configuration. If the call fails at some point, `api.get_config()` will return an empty config.

```python
# push configuration to controller
api.set_config(cfg)

# start packet capture on configured ports
cs = api.capture_state()
cs.state = cs.START
api.set_capture_state(cs)

# start transmitting configured flows
ts = api.transmit_state()
ts.state = ts.START
api.set_transmit_state(ts)
```

> Transmit or capture will be started on all configured flows or ports, respectively, unless one provides specific flow or port names. e.g. `cs.port_names = ['p1']`, `ts.flow_names = ['f1']`. 

### Fetch and Validate Metrics

Since we're sending 1000 packets, at a rate of 1000 packets per second, it should take 1 second for transmit to be complete. We can validate the same using `metrics`.

The API supports different kinds of metrics, but we'll focus on `port_metrics` which are similar to linux network interface stats.

```python
# create a port metrics request and filter based on port names
req = api.metrics_request()
req.port.port_names = [p.name for p in cfg.ports]
# include only sent and received packet counts
req.port.column_names = [req.port.FRAMES_TX, req.port.FRAMES_RX]

# fetch port metrics
res = api.get_metrics(req)

# calculate total frames sent and received across all configured ports
total_tx = sum([m.frames_tx for m in res.port_metrics])
total_rx = sum([m.frames_rx for m in res.port_metrics])
expected = sum([f.duration.fixed_packets.packets for f in cfg.flows])

assert expected == total_tx and total_rx >= expected
```

> Note, usually this snippet will need to be executed multiple times until the assertion in the end stands true or timeout occurs. We use a function called `wait_for()` in `hello_snappi.py` script to achieve this.

### Fetch and Validate Captures

Validation using metrics is limited to counters (e.g. total transmitted, total received). To really inspect each packet received, we can use the capture API.

This API is a little different from others, in that:
* It returns a sequence of raw bytes (representing `.pcap` file) instead of a JSON string.
* It needs to be fed to a tool that can inspect `.pcap` files. e.g. `dpkt` or `tcpdump`

This snippet uses `dpkt` to ensure each packet received is a valid UDP packet.

```python
for p in cfg.ports:
  # create capture request and filter based on port name
  req = api.capture_request()
  req.port_name = p.name
  # fetch captured pcap bytes and feed it to pcap parser dpkt
  pcap = dpkt.pcap.Reader(api.get_capture(req))
  for _, buf in pcap:
      # check if current packet is a valid UDP packet
      eth = dpkt.ethernet.Ethernet(buf)
      assert isinstance(eth.data.data, dpkt.udp.UDP)
```

Optionally following snippet can be used in order to do `tcpdump -r cap.pcap` (inspect captures using tcpdump).

```python
pcap_bytes = api.get_capture(req)
with open('cap.pcap', 'wb') as p:
  p.write(pcap_bytes.read())
```

### Putting It All Together

`snappi` provides a fair level of abstraction and ease-of-use while constructing traffic configuration compared to doing the [equivalent in JSON](https://github.com/open-traffic-generator/snappi-tests/tree/820fac6/configs/hello_snappi.json). More such comparisons can be found in [common snappi constructs](snappi-constructs.md).

There's more to snappi than what we've presented here, e.g. per-flow metrics, latency measurements, custom payloads, etc. It will be worthwhile browsing through [snappi-tests](https://github.com/open-traffic-generator/snappi-tests/tree/820fac6) for more such examples, pytest-based test scripts and utilities.

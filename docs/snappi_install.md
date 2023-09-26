# Installing Snappi

The procedures explained in this section helps to install and configure snappi for an Open Traffic Generator API.

The test scripts written in **gosnappi**, and the auto-generated Go SDK, can be executed against any traffic generator that conforms to [Open Traffic Generator API](https://github.com/open-traffic-generator/models).

[Ixia-c](https://github.com/open-traffic-generator/ixia-c) is one of such reference implementations of the Open Traffic Generator API.

## To install Snappi for the Go language, do the following:

### Setup the client

```sh
go get github.com/open-traffic-generator/snappi/gosnappi
```

### Start Testing

```Go
package examples

import (
	"encoding/hex"
	"testing"
	"time"

	"github.com/open-traffic-generator/snappi/gosnappi"
)

func TestQuickstart(t *testing.T) {
	// Create a new API handle to make API calls against OTG
	api := gosnappi.NewApi()

	// Set the transport protocol to HTTP
	api.NewHttpTransport().SetLocation("https://localhost:8443")

	// Create a new traffic configuration that will be set on OTG
	config := api.NewConfig()

	// Add a test port to the configuration
	ptx := config.Ports().Add().SetName("ptx").SetLocation("veth-a")

	// Configure a flow and set previously created test port as one of endpoints
	flow := config.Flows().Add().SetName("f1")
	flow.TxRx().Port().SetTxName(ptx.Name())
	// and enable tracking flow metrics
	flow.Metrics().SetEnable(true)

	// Configure number of packets to transmit for previously configured flow
	flow.Duration().FixedPackets().SetPackets(100)
	// and fixed byte size of all packets in the flow
	flow.Size().SetFixed(128)

	// Configure protocol headers for all packets in the flow
	pkt := flow.Packet()
	eth := pkt.Add().Ethernet()
	ipv4 := pkt.Add().Ipv4()
	udp := pkt.Add().Udp()
	cus := pkt.Add().Custom()

	eth.Dst().SetValue("00:11:22:33:44:55")
	eth.Src().SetValue("00:11:22:33:44:66")

	ipv4.Src().SetValue("10.1.1.1")
	ipv4.Dst().SetValue("20.1.1.1")

	// Configure repeating patterns for source and destination UDP ports
	udp.SrcPort().SetValues([]int32{5010, 5015, 5020, 5025, 5030})
	udp.DstPort().Increment().SetStart(6010).SetStep(5).SetCount(5)

	// Configure custom bytes (hex string) in payload
	cus.SetBytes(hex.EncodeToString([]byte("..QUICKSTART SNAPPI..")))

	// Optionally, print JSON representation of config
	if j, err := config.ToJson(); err != nil {
		t.Fatal(err)
	} else {
		t.Log("Configuration: ", j)
	}

	// Push traffic configuration constructed so far to OTG
	if _, err := api.SetConfig(config); err != nil {
		t.Fatal(err)
	}

	// Start transmitting the packets from configured flow
	ts := api.NewTransmitState()
	ts.SetState(gosnappi.TransmitStateState.START)
	if _, err := api.SetTransmitState(ts); err != nil {
		t.Fatal(err)
	}

	// Fetch metrics for configured flow
	req := api.NewMetricsRequest()
	req.Flow().SetFlowNames([]string{flow.Name()})
	// and keep polling until either expectation is met or deadline exceeds
	deadline := time.Now().Add(10 * time.Second)
	for {
		metrics, err := api.GetMetrics(req)
		if err != nil || time.Now().After(deadline) {
			t.Fatalf("err = %v || deadline exceeded", err)
		}
		// print YAML representation of flow metrics
		t.Log(metrics)
		if metrics.FlowMetrics().Items()[0].Transmit() == gosnappi.FlowMetricTransmit.STOPPED {
			break
		}
		time.Sleep(100 * time.Millisecond)
	}
}
```

## To install Snappi for the Python language, do the following:

### Setup the Client
 
```sh
python -m pip install --upgrade snappi 
```

### Start Testing

```python
import datetime
import time
import snappi
import pytest


@pytest.mark.example
def test_quickstart():
    # Create a new API handle to make API calls against OTG
    # with HTTP as default transport protocol
    api = snappi.api(location="https://localhost:8443")

    # Create a new traffic configuration that will be set on OTG
    config = api.config()

    # Add a test port to the configuration
    ptx = config.ports.add(name="ptx", location="veth-a")

    # Configure a flow and set previously created test port as one of endpoints
    flow = config.flows.add(name="flow")
    flow.tx_rx.port.tx_name = ptx.name
    # and enable tracking flow metrics
    flow.metrics.enable = True

    # Configure number of packets to transmit for previously configured flow
    flow.duration.fixed_packets.packets = 100
    # and fixed byte size of all packets in the flow
    flow.size.fixed = 128

    # Configure protocol headers for all packets in the flow
    eth, ip, udp, cus = flow.packet.ethernet().ipv4().udp().custom()

    eth.src.value = "00:11:22:33:44:55"
    eth.dst.value = "00:11:22:33:44:66"

    ip.src.value = "10.1.1.1"
    ip.dst.value = "20.1.1.1"

    # Configure repeating patterns for source and destination UDP ports
    udp.src_port.values = [5010, 5015, 5020, 5025, 5030]
    udp.dst_port.increment.start = 6010
    udp.dst_port.increment.step = 5
    udp.dst_port.increment.count = 5

    # Configure custom bytes (hex string) in payload
    cus.bytes = "".join([hex(c)[2:] for c in b"..QUICKSTART SNAPPI.."])

    # Optionally, print JSON representation of config
    print("Configuration: ", config.serialize(encoding=config.JSON))

    # Push traffic configuration constructed so far to OTG
    api.set_config(config)

    # Start transmitting the packets from configured flow
    ts = api.transmit_state()
    ts.state = ts.START
    api.set_transmit_state(ts)

    # Fetch metrics for configured flow
    req = api.metrics_request()
    req.flow.flow_names = [flow.name]
    # and keep polling until either expectation is met or deadline exceeds
    start = datetime.datetime.now()
    while True:
        metrics = api.get_metrics(req)
        if (datetime.datetime.now() - start).seconds > 10:
            raise Exception("deadline exceeded")
        # print YAML representation of flow metrics
        print(metrics)
        if metrics.flow_metrics[0].transmit == metrics.flow_metrics[0].STOPPED:
            break
        time.sleep(0.1)
```

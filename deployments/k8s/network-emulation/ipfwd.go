package main

import (
	"log"
	"time"

	"github.com/open-traffic-generator/snappi/gosnappi"
)

func main() {

	// This test configures one IPv4 interface on tx and rx test port each
	// and sends IPv4 packets with src IP address of interface on tx port
	// and dst IP address of interface on rx port. The packets are sent only
	// after ARP entries have been learned from corresponding DUT interfaces
	// and flow metrics is used to validate tx and rx counters.

	testConst := map[string]interface{}{
		"apiLocation":    "https://localhost:8443",
		"txPortLocation": "eth1",
		"rxPortLocation": "eth2",
		"speed":          "speed_1_gbps",
		"pktRate":        uint64(50),
		"pktCount":       uint32(100),
		"pktSize":        uint32(128),
		"txMac":          "00:00:01:01:01:01",
		"txIp":           "1.1.1.1",
		"txGateway":      "1.1.1.2",
		"txPrefix":       uint32(24),
		"rxMac":          "00:00:01:01:01:02",
		"rxIp":           "2.2.2.1",
		"rxGateway":      "2.2.2.2",
		"rxPrefix":       uint32(24),
	}

	api := gosnappi.NewApi()
	api.NewHttpTransport().SetLocation(testConst["apiLocation"].(string)).SetVerify(false)

	log.Println("Constructing OTG configuration ...")
	c := otgConfig(testConst)

	log.Println("Pushing OTG configuration ...")
	if wrn, err := api.SetConfig(c); err != nil {
		log.Fatal(err)
	} else {
		for _, w := range wrn.Warnings() {
			log.Println("WARNING:", w)
		}
	}

	log.Println("Waiting for ARP entries for configured interfaces ...")
	for start := time.Now(); !ipNeighborsOk(api, testConst); time.Sleep(time.Millisecond * 500) {
		if time.Second*30 < time.Until(start) {
			log.Fatal("Timed out waiting for ARP entries")
		}
	}

	log.Println("Starting flow transmission ...")
	cs := gosnappi.NewControlState()
	cs.Traffic().FlowTransmit().SetState(gosnappi.StateTrafficFlowTransmitState.START)
	if wrn, err := api.SetControlState(cs); err != nil {
		log.Fatal(err)
	} else {
		for _, w := range wrn.Warnings() {
			log.Println("WARNING:", w)
		}
	}

	log.Println("Waiting for flow metrics ...")
	for start := time.Now(); !flowMetricsOk(api, testConst); time.Sleep(time.Millisecond * 500) {
		if time.Second*30 < time.Until(start) {
			log.Fatal("Timed out waiting for ARP entries")
		}
	}
}

func otgConfig(tc map[string]interface{}) gosnappi.Config {
	c := gosnappi.NewConfig()

	ptx := c.Ports().Add().SetName("ptx").SetLocation(tc["txPortLocation"].(string))
	prx := c.Ports().Add().SetName("prx").SetLocation(tc["rxPortLocation"].(string))

	c.Layer1().Add().
		SetName("ly").
		SetPortNames([]string{ptx.Name(), prx.Name()}).
		SetSpeed(gosnappi.Layer1SpeedEnum(tc["speed"].(string)))

	dtx := c.Devices().Add().SetName("dtx")
	drx := c.Devices().Add().SetName("drx")

	dtxEth := dtx.Ethernets().
		Add().
		SetName("dtxEth").
		SetMac(tc["txMac"].(string)).
		SetMtu(1500)

	dtxEth.Connection().SetPortName(ptx.Name())

	dtxIp := dtxEth.
		Ipv4Addresses().
		Add().
		SetName("dtxIp").
		SetAddress(tc["txIp"].(string)).
		SetGateway(tc["txGateway"].(string)).
		SetPrefix(tc["txPrefix"].(uint32))

	drxEth := drx.Ethernets().
		Add().
		SetName("drxEth").
		SetMac(tc["rxMac"].(string)).
		SetMtu(1500)

	drxEth.Connection().SetPortName(prx.Name())

	drxIp := drxEth.
		Ipv4Addresses().
		Add().
		SetName("drxIp").
		SetAddress(tc["rxIp"].(string)).
		SetGateway(tc["rxGateway"].(string)).
		SetPrefix(tc["rxPrefix"].(uint32))

	flow := c.Flows().Add()
	flow.SetName("ftxV4")
	flow.Duration().FixedPackets().SetPackets(tc["pktCount"].(uint32))
	flow.Rate().SetPps(tc["pktRate"].(uint64))
	flow.Size().SetFixed(tc["pktSize"].(uint32))
	flow.Metrics().SetEnable(true)

	flow.TxRx().Device().
		SetTxNames([]string{dtxIp.Name()}).
		SetRxNames([]string{drxIp.Name()})

	ftxV4Eth := flow.Packet().Add().Ethernet()
	ftxV4Eth.Src().SetValue(dtxEth.Mac())

	ftxV4Ip := flow.Packet().Add().Ipv4()
	ftxV4Ip.Src().SetValue(tc["txIp"].(string))
	ftxV4Ip.Dst().SetValue(tc["rxIp"].(string))

	log.Printf("Config:\n%v\n", c)
	return c
}

func ipNeighborsOk(api gosnappi.Api, tc map[string]interface{}) bool {
	count := 0

	log.Println("Getting IPv4 neighbors ...")
	req := gosnappi.NewStatesRequest()
	// query to fetch states for all configured IPv4 interfaces
	req.Ipv4Neighbors()
	states, err := api.GetStates(req)
	if err != nil {
		log.Fatal(err)
	}

	log.Printf("IPv4 Neighbors Metrics:\n%v\n", states)
	for _, n := range states.Ipv4Neighbors().Items() {
		if n.HasLinkLayerAddress() {
			for _, key := range []string{"txGateway", "rxGateway"} {
				if n.Ipv4Address() == tc[key].(string) {
					count += 1
				}
			}
		}
	}

	return count == 2
}

func flowMetricsOk(api gosnappi.Api, tc map[string]interface{}) bool {
	pktCount := uint64(tc["pktCount"].(uint32))

	log.Println("Getting flow metrics ...")
	req := gosnappi.NewMetricsRequest()
	// query to fetch metrics for all configured flows
	req.Flow()
	metrics, err := api.GetMetrics(req)
	if err != nil {
		log.Fatal(err)
	}

	log.Printf("Flow Metrics:\n%v\n", metrics)
	for _, m := range metrics.FlowMetrics().Items() {
		if m.Transmit() != gosnappi.FlowMetricTransmit.STOPPED ||
			m.FramesTx() != pktCount ||
			m.FramesRx() != pktCount {
			return false
		}

	}

	return true
}

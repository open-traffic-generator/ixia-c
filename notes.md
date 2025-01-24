#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.19.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.19.0/artifacts/openapi.yaml)         |
| snappi                        | [1.19.0](https://pypi.org/project/snappi/1.19.0)        |
| gosnappi                      | [1.19.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.19.0)        |
| keng-controller               | [1.19.0-18](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.426](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.19.0-9](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.19.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.19.0-18](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.1](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.1/artifacts.tar)         |


# Release Features(s)

* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for GUEv1 IPv4/v6 over UDP traffic.
    ```go
        f1Ip1 := f1.Packet().Add().Ipv4()​
        f1Ip1.Src().SetValue("1.1.1.1")​
        f1Ip1.Dst().SetValue("1.1.1.2")​
        ​
        f1Udp := f1.Packet().Add().Udp()​
        f1Udp.SrcPort().SetValue(30000)​
        f1Udp.DstPort().SetValue(6080)​
        // IPv4 Over UDP​
        f1Ip2 := f1.Packet().Add().Ipv4()​
        f1Ip2.Src().SetValues([]string{​
            "2.2.2.1",​
            "2.2.2.2",​
            "2.2.2.3",​
            "2.2.2.4",​
        })​
        f1Ip2.Dst().SetValue("3.3.3.1")​
    ```

* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for MPLS Over UDP traffic.
    ```go
        //udp Dst port as 6635​
        f1Udp := f1.Packet().Add().Udp()​
        f1Udp.DstPort().SetValue(6635)​
        f1Udp.SrcPort().SetValue(65530)​
        //mpls over udp​
        f1Mpls1 := f1.Packet().Add().Mpls()​
        f1Mpls1.Label().SetValue(10001)​
        f1Mpls1.BottomOfStack().SetValue(0)
        f1Mpls2 := f1.Packet().Add().Mpls()​
        f1Mpls2.Label().SetValue(10011)​
        //ipv4 over mpls over udp​
        f1MplsIp := f1.Packet().Add().Ipv4()​
        f1MplsIp.Dst().SetValues([]string{​
            "20.20.20.1",​
            "20.20.20.2",​
            "20.20.20.3",​
            "20.20.20.4",​
        })​
        f1MplsIp.Src().SetValue("10.10.10.1")
    ```
    Note: MPLS Over UDP with DTLS is not supported.

* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Egress tracking is now supported for UDP, TCP(src/dst port fields), MPLS and IPv4/v6 inner header fields when encapsulated inside UDP/TCP.
    ```go
        //egress tracking
        f1.EgressPacket().Add().Ethernet()
        f1.EgressPacket().Add().Ipv4()
        f1.EgressPacket().Add().Udp()
        f1.EgressPacket().Add().Mpls()
        mplsLabelTracking := f1.EgressPacket().Add().Mpls()
        tr1 := mplsLabelTracking.Label().MetricTags().Add()
        tr1.SetName("MplsLabelEgressTracking")
        tr1.SetOffset(17)
        tr1.SetLength(3)
    ```
	
### Bug Fix(s)
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where configs with RSVP and multiple Loopback interfaces was throwing error similar to `"loopback p2.d2.lo and lo.d not compatible"` on `set_config`.
* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue where config with large number of route ranges was causing error similar to `"grpc: received message larger than max (114278270 vs. 104857600)"` on `set_config` is fixed by increasing the default gRPC receive buffer size to 1GB.
    - Note that for Ixia Chassis & Appliances(Novus, AresOne) the buffer can now be controlled by setting the environment variable of `keng-controller` as given below.
        ```sh
            command:
                ...
                - "--grpc-max-msg-size"​
                - "500"
        ```
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where `set_config` was throwing error if Traffic Engineering was enabled for ISIS interface, but Priority BandWidths were not explicitly specified.
* <b><i>Ixia-C, UHD400</i></b>: Issue is fixed where DHCPv4 was intermittently crashing on stop.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where OSPFv2 Router Ids were not getting set properly when multiple OSPFv2 Routers were configured on a port. 


#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
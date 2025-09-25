### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.40.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.40.0/artifacts/openapi.yaml)         |
| snappi                        | [1.40.0](https://pypi.org/project/snappi/1.40.0)        |
| gosnappi                      | [1.40.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.40.0)        |
| keng-controller               | [1.40.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.482](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.40.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.40.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.40.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.8](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.8/artifacts.tar)         |


### Release Features(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for `LACP` header in flow. [details](https://github.com/open-traffic-generator/models/pull/435)
    ```go
        f1Eth := flow.Packet().Add().Ethernet()
        f1Eth.Src().SetValue("00:00:00:00:00:AA")
        f1Eth.Dst().SetValue("01:80:C2:00:00:02")

        f1Lacp := flow.Packet().Add().Lacp()
        f1Lacpdu := f1Lacp.Lacpdu()

        f1LacpActor := f1Lacpdu.Actor()
        f1LacpActor.SystemPriority().SetValue(32768)
        f1LacpActor.SystemId().SetValue("00:00:00:00:00:AA")
        f1LacpActor.Key().SetValue(13)
        f1LacpActor.PortPriority().SetValue(32768)
        f1LacpActor.PortNumber().SetValue(25)
        f1LacpActor.ActorState().Activity.SetValue(1)
        f1LacpActor.ActorState().Aggregation.SetValue(1)
        f1LacpActor.ActorState().Collecting.SetValue(1)

        f1LacpPartner := f1Lacpdu.Partner()
        f1LacpPartner.SystemPriority().SetValue(32768)
        f1LacpPartner.SystemId().SetValue("00:0c:29:1e:a2:6d")
        f1LacpPartner.Key().SetValue(1)
        f1LacpPartner.PortPriority().SetValue(32768)
        f1LacpPartner.PortNumber().SetValue(1)
        f1LacpPartner.PartnerState().Distributing.SetValue(1)  
    ```

    Note: `flows[i].metrics.enable` should be set to `false`, to ensure that instrumentation data is not appended to the `LACP` PDU being transmitted on the wire.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for fetching user specified packet slice from captured packets. [details](https://github.com/open-traffic-generator/models/pull/436)
    ```go
        // Capture Slice: get N number of packets starting from Mth packet 
        captureRequest = gosnappi.NewCaptureRequest()
        captureRequest.SetPortName("p1")
        captureRequest.Packets().Slice().Initial().SetStart(10).SetCount(50)
    ```

### Bug Fix(s): 
* <b><i>Ixia-C, UHD400</i></b>: Issue is fixed where if `devices[i].bgp.ipv4/6_interfaces[j].peers[k].capability.route_refresh` was explicitly set to `false`, the IPv6 capability would not be advertised in the BGP Open message, resulting in IPv6 routes not getting installed in this specific scenario.

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
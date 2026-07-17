### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.58.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.58.0/artifacts/openapi.yaml)         |
| snappi                        | [1.58.0](https://pypi.org/project/snappi/1.58.0)        |
| gosnappi                      | [1.58.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.58.0)        |
| keng-controller               | [1.58.0-12](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.544](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.533](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.58.0-4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.4.0](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.58.1](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.58.0-12](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |
| <b>ARM64</b>                                  |
| keng-controller-arm64         | [1.58.0-12](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller-arm64)    |
| ixia-c-traffic-engine-arm64   | [1.8.0.563](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine-arm64)       |


### Release Feature(s):
* <b><i>Ixia-C</i></b>: Support added for extended IPv6 routing header type 4(IPv6 SR) in flows.
    ```go
        // go-snappi snippet​
        f1Eth := f1.Packet().Add().Ethernet()​
        ...
        f1Ip := f1.Packet().Add().Ipv6()​
        ...​

        // IPv6 SR Header ​
        f1ExtHdr := f1.Packet().Add().Ipv6ExtensionHeader()​
        f1SR := f1ExtHdr.Routing().SegmentRouting()​​
        f1SegList := f1SR.SegmentList()​
        f1SegList.Add().Segment().SetValue("5000:0:0:1:0:0:0:1")​
        f1SegList.Add().Segment().SetValue("1000:0:0:1:0:0:0:1")​
        ...
    ```

### Bug Fix(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where, BGP protocol `set_control_state` would return error `"Error occurred while starting protocol ... Unable find type: Ixia.Aptixia.Cpf.pcpu.BgpIpv4PeerPCPU"` intermittently, in setups where a chassis is being used concurrently by IxNetwork and Keng users. This would happen in certain scenarios when the protocol start from both the clients would occur very close to each other.

* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne) & UHD400</i></b>: Issue is fixed where, during a ISIS graceful restart, ISIS does not maintain existing adjacency with the DUT that is already up when the graceful restart is triggered.
 
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where, for a lag with multiple member ports, flows were not switching to available active member ports when the member port being used for transmission of packets for the flow was going down.

* <b><i>otg-gnmi-server</i></b>: Issue is fixed, gNMI is silently failing for batch queries where only the first provided path was being processed. This will now throw a clear error `"Batch query is not supported. The SubscriptionList must contain exactly one path (wildcards are allowed), but received <n>"`.

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
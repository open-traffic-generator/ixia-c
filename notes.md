### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.62.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.62.0/artifacts/openapi.yaml)         |
| snappi                        | [1.62.0](https://pypi.org/project/snappi/1.62.0)        |
| gosnappi                      | [1.62.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.62.0)        |
| keng-controller               | [1.62.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.544](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.537](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.62.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.4.4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.62.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.62.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |
| <b>ARM64</b>                                  |
| keng-controller-arm64         | [1.62.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller-arm64)    |
| ixia-c-traffic-engine-arm64   | [1.8.0.563](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine-arm64)       |


### Release Feature(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for OSPFv2 Segment Routing for Emulated and Simulated OSPFv2 Routers.
    - To configure OSPFv2 Segment Routing at router level, use the following snippet.
    ```go
        sr := ospf.SegmentRouting()
        sr.SetAlgorithms([]uint32{0})
        sr.SrgbRanges().Add().SetStartingSid(16000).SetRange(8000)
        sr.SrlbRanges().Add().SetStartingSid(15000).SetRange(1000)

        // Configure Node SID as per below snippet.
        routes := ospf.V4Routes().Add().SetName("node_sid_route")
        routes.Addresses().Add().
          SetAddress("1.1.1.1").
          SetPrefix(32)
        routes.RouteOrigin().IntraArea().Flags().
          SetNFlag(true).
          SetAFlag(false)

        routes.PrefixSids().Add().
          SetSidIndices([]uint32{1}).
          SetNpFlag(true).
          SetMFlag(false).
          SetEFlag(false).
          SetAlgorithm(0)​
    ```
  
    - To configure Adjacency-SID under `devices[i].ospfv2.interfaces[i].adjacency_sids[j]` use the following snippet.
    ```go
        ospfIntf.AdjacencySids().Add().
          SetSidIndices([]uint32{401}).
          SetBFlag(false).
          SetGFlag(false).
          SetPFlag(true).
          SetWeight(10)​
    ```

    - To configure OSPFv2 routes with Prefix SIDs, use the following snippet.
      ```go
        srRoutes := ospf.V4Routes().Add().SetName("sr_routes")
        srRoutes.Addresses().Add().
          SetAddress("10.10.10.0").
          SetPrefix(24).
          SetCount(1000)
        srRoutes.PrefixSids().Add().
          SetSidIndices([]uint32{100}).
          SetNpFlag(true).
          SetAlgorithm(0)
      ```

    - To configure traffic using Segment Routing MPLS Labels use the following snippet.
    ```go
        eth := flow.Packet().Add().Ethernet()​
        eth.Src().SetValue(ethIntf.Mac())​
        eth.Dst().Auto()​
        mpls := flow.Packet().Add().Mpls()​
        mpls.Label().SetValue(uint32(16002))​ // Set the Segment Routing MPLS Label to which traffic has to be steered.​
        ip := flow.Packet().Add().Ipv4()
        ip.Src().SetValue("10.10.10.1")
        ip.Dst().SetValue("11.11.11.1")
    ```
  
    Note: gNMI support will be available in later releases for `get_states` enhancements.

* <b><i>gosnappi</i></b>: gosnappi `>=v1.62.0` required go version `>=1.26`.

### Bug Fix(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: An attempted fix is included for the issue where `set_control_state.traffic.flow_transmit.state=start` was returning error `"Sequence contained null element (Parameter 'values')"`.
* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne) & UHD400</i></b>: Issue is fixed where two ports with identical locations were being incorrectly accepted. This will now return an error that duplicate port locations are not allowed.


### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
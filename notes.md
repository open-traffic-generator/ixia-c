#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.24.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.24.0/artifacts/openapi.yaml)         |
| snappi                        | [1.24.0](https://pypi.org/project/snappi/1.24.0)        |
| gosnappi                      | [1.24.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.24.0)        |
| keng-controller               | [1.24.0-4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.438](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.24.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.24.2](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.24.0-4](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.3]( https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.3/artifacts.tar)         |


# Release Features(s):
* <b><i>Ixia-C & UHD400</i></b>: Support added for ISIS Simulated Topology. [More Details](https://github.com/open-traffic-generator/models/pull/327)
  - Configuration for ISIS attributes for newly introduced simulated routers are identical to configuration for currently supported directly connected emulated routers.
  -  `devices[i].ethernets[j].connection.simulated_link`​ is introduced to create a simulated ethernet connection to build a Simulated Topology.
  ```go
    simulatedRouterEthernet := simulatedRouter.Ethernets().Add().
                SetName("simRtrEth").
                SetMac("00:00:11:02:02:02")
    simulatedRouterEthernet.Connection().SimulatedLink().SetRemoteSimulatedLink("connRtrSimEth")

    connectedRouterSimulatedEthernet := connectedRouter.Ethernets().Add().
                SetName("connRtrSimEth").
                SetMac("00:00:01:01:01:01")
    connectedRouterSimulatedEthernet.Connection().SimulatedLink().SetRemoteSimulatedLink("simRtrEth")
  ```
  - BGP/BGP+/RSVP-TE can also be configured on loopback interfaces on the simulated devices.
  Note: `get_metrics/states` APIs are only applicable for the connected emulated routers and not for the simulated routers.

* <b><i>Ixia-C & UHD400</i></b>: Support added for ISIS Segment Routing for emulated ISIS routers.
    - To configure Router Capability with Segment Routing in `devices[i].isis.segment_routing.router_capability` use the following snippet.
    ```go
        srCap := rtrCap.SrCapability()​
        srCap.Flags().SetIpv4Mpls(true).SetIpv6Mpls(true)​
        srCap.SrgbRanges().Add().SetStartingSid(uint32(srStartingSid)).SetRange(uint32(srRange))​
    ```
    - To configure routes with Node-SID or Prefix-SID under `devices[i].isis.v4/6_routes[j].prefix_sids[0]` use the following snippet.
    ```go
        isisV4Route.PrefixSids().Add().​
            SetSidIndex(sidOffset).​
            SetRFlag(true).​
            SetNFlag(true).​
            SetPFlag(true).​
            SetAlgorithm(1)​
    ```
    - To configure Adjacency-SID under `devices[i].isis.interfaces[0].adjacency_sids[j]` use the following snippet.
    ```go
        isisInterface.AdjacencySids().Add().​
	        SetSidIndex(sidOffset).​
	        SetPFlag(true).
            SetWeight(10)​
    ```
    - To configure traffic using Segment Routing MPLS Labels use the following snippet.
    ```go
        eth := flow.Packet().Add().Ethernet()​
        eth.Src().SetValue(ethIntf.Mac())​
        eth.Dst().Auto()​
        mpls := flow.Packet().Add().Mpls()​
        mpls.Label().SetValue(uint32(900010))​ // Use the Segment Routing MPLS Label to which traffic has to be steered.​
    ```
    Note: MPLS headers in flows is not yet supported for UHD400.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne), UHD400</i></b>: gNMI support added to retrieve timestamp of the last link state change event of the test port. [More Details](https://github.com/open-traffic-generator/models-yang/pull/40)
    ```gNMI
        ports/port[name=*]/state/last-change
    ```
    Note: Please update kne to latest if the setup is upgraded to this build , otherwise gnmi failures might be seen while fetching port metrics.

### Bug Fix(s)
* <b><i>Ixia-C & UHD400</i></b>:  Issue is fixed where DHCPv6 was intermittently crashing on stop.


#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Non default virtual wiring configuration can result in ARP failures and traffic loss due to dropped packets on the rx path.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
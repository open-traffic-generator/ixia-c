#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.24.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.24.0/artifacts/openapi.yaml)         |
| snappi                        | [1.24.0](https://pypi.org/project/snappi/1.24.0)        |
| gosnappi                      | [1.24.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.24.0)        |
| keng-controller               | [1.24.0-15](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.443](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.24.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.24.2](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.24.0-15](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.5](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.5/artifacts.tar)         |


# Release Features(s):
* <b><i>Ixia-C, UHD400, Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for ISIS Segment Routing for  Emulated and Simulated ISIS Routers.
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
        mpls.Label().SetValue(uint32(900010))​ // Set the Segment Routing MPLS Label to which traffic has to be steered.​
    ```
    Note: MPLS headers in flows is not yet supported for UHD400.

    - To configure ISIS on simulated routers, please refer to previous release notes.

* <b><i>UHD400</i></b>: Support added to send flows over DHCPv4/6 endpoints.
  ```go
    clientToServerFlow := config.Flows().Add()
    clientToServerFlow.SetName(flowName).
      TxRx().Device().
      SetTxNames([]string{"p1d1dhcpv4_1"}).
      SetRxNames([]string{"p2d1ipv4"})
    clientToServerFlowIp := f1.Packet().Add().Ipv4()
    // will be populated automatically by the DHCP Client with the the dynamically allocated IP.
    clientToServerFlowIp.Src().Auto().Dhcp()
    …
    // will be populated automatically by the DHCP Server with the the dynamically allocated IP to DHCP client 
    serverToClientFlowIp.Dst().Auto().Dhcp()
  ```

* <b><i>Ixia-C, UHD400, Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added in RSVP-TE Egress emulation to automatically respond to a Path message with Label Recording Desired flag set in Session Attribute with a RRO in the Resv message with corresponding Label Sub Object included.  
    - User needs to set the following flag `devices[i].rsvp.lsp_ipv4_interfaces[j].p2p_ingress_ipv4_lsps[k].session_attribute.label_recording_desired`.



### Bug Fix(s)
* <b><i>UHD400</i></b>: Issue is fixed non default VLAN wiring was not working properly, resulting in ARP/ND failures.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where Label Sub Objects were not being returned correctly for RSVP-TE learned information (`rsvp_lsps[i].rros[k].reported_label`) 
* <b><i>Ixia-C, UHD400</i></b>: Issue is fixed where fetching ISIS learned information containing LSPs with Router Capability without any Segment Routing Sub TLV would result in an error <i>"grpc: failed to unmarshal the received message: proto: cannot parse invalid wire-format data"</i> in certain conditions.


#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.19.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.19.0/artifacts/openapi.yaml)         |
| snappi                        | [1.19.0](https://pypi.org/project/snappi/1.19.0)        |
| gosnappi                      | [1.19.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.19.0)        |
| keng-controller               | [1.19.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.241](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.424](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.19.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.19.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.19.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.1](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.1/artifacts.tar)         |


# Release Features(s)

* <b><i>Ixia-C</i></b>: Support added to send flows over DHCPv6 endpoints.
  ```go
    f1 := config.Flows().Add()​
    f1.SetName(flowName).​
      TxRx().Device().​
      SetTxNames([]string{"p1d1dhcpv6_1"}).​
      SetRxNames([]string{"p2d1ipv6"})​
    f1Ip := f1.Packet().Add().Ipv6()​
    // will be populated automatically with the the dynamically allocated Ip to DHCP client​
    f1Ip.Src().Auto().Dhcp()​
    …​
    f2Ip.Dst().Auto().Dhcp()​
  ```

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added to retrieve timestamp of the last link state change event of the test port. [More Details](https://github.com/open-traffic-generator/models/pull/398)
  - This can be retrieved by accessing `port_metrics[i].last_change`.
  
    Note:
      - As mentioned in the `Known Issues`, ports being used in the tests must be rebooted once after upgrading to the latest version of `keng-layer23-hw-server`. 
      - Test ports and DUT must be time synced to the same time source if link state change timestamps need to be co-related.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for RSVP over ISIS Simulated Topology.
  ```go
    // Create RSVP neighbor on interface connected to DUT.
    // Note that get_states and get_metrics are supported only for the connected RSVP neighbors.
    p2RsvpNeighbor := p2d1.Rsvp().SetName("p2RsvpNbr")
    p2RsvpNeighbor.Ipv4Interfaces().
            Add().SetIpv4Name(p2d1Ipv4.Name()).
            SetNeighborIp(p2d1Ipv4.Gateway())

    // Create RSVP ingress LSPs on the loopback behind the simulated topology.
    fromLoRsvpIngress := fromLoRsvpLsp.P2PIngressIpv4Lsps().Add().SetName("ingressLsp")
    fromLoRsvpIngress.SetRemoteAddress("1.1.1.1").SetTunnelId(100)

    // Create RSVP egress endpoint on the loopback behind the simulated topology.
    toLoRsvpLsp := toLoRsvpPeer.LspIpv4Interfaces().Add().SetIpv4Name("loopback")
    toLoRsvpLspEgress := toLoRsvpLsp.P2PEgressIpv4Lsps().SetName("egressLsp")

    // Note: for TE SPF to work properly on DUT, ensure you have added TrafficEngineering to all ISIS interfaces.
    te = p2d1IsisIntf.TrafficEngineering().Add().SetMetricLevel(10)
    te.PriorityBandwidths().
            SetPb0(125000000).
            ...
            SetPb7(125000000)
  ```


	
### Bug Fix(s)
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where `set_config` was failing with the error `"BgpIPRouteRange is missing"` when IPv4 routes with IPv6 next-hops (RFC5549) was configured.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where `get_states` on `bgpv4/6_prefixes` was returning error `"Error occurred while fetching bgp_prefix states:Length cannot be less than zero. (Parameter 'length')"` if the prefix contained `as_path` with multiple segments.

* <b><i>Ixia-C, UHD400</i></b>: Issue is fixed where `get_states` for `isis` was returning IPv6 prefixes in upper case causing prefix match for IPv6 prefixes to fail in tests.

* <b><i>Ixia-C</i></b>: Issue is fixed where `set_config` was failing with error `"Error occurred while setting Traffic config (Layer1 only) for user common:Error fetching stats for port port9: unsuccessful Response: Port 7 is not added"` when the traffic engine was deployed in multi nic mode (e.g. for lag setups with 8 ports).

* <b><i>Ixia-C</i></b>: Issue is fixed where the traffic engine was crashing on deployment using a single cpu core (`--cpuset-cpus="0-1"`).

* <b><i>VM Licensing</i></b>: Issue is fixed for users using the VM License Server where,  after a reboot, license-server VM serving multiple keng-controller(s) did not come up and tests running with those controller(s) started failing.



#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
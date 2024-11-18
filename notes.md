#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.16.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.16.0/artifacts/openapi.yaml)         |
| snappi                        | [1.16.0](https://pypi.org/project/snappi/1.16.0)        |
| gosnappi                      | [1.16.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.16.0)        |
| keng-controller               | [1.16.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.193](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.415](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.16.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.14.16](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.16.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.1](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.1/artifacts.tar)         |


# Release Features(s)

* <b><i>Ixia-C, UHD400</i></b>: Support added for DHCPv6 Client and Server in control plane.
  - User will be the able to configure DHCPv6 Client and Server by the following code snippet.
  ```go
    // Configure a DHCP Client
      dhcpv6client := d1Eth1.Dhcpv6Interfaces().Add().
        SetName("p1d1dhcpv61")

      dhcpv6client.IaType().Iata()
      dhcpv6client.DuidType().Llt()

      // Configure a DHCPv6 Server
      d1Dhcpv6Server := d2.DhcpServer().Ipv6Interfaces().Add().
        SetName("p2d1Dhcpv6Server1").

      d1Dhcpv6ServerPool := d1Dhcpv6Server.SetIpv6Name("p2d1ipv6").
        Leases().Add().
        SetLeaseTime(3600)
      IaType := d1Dhcpv6ServerPool.IaType().Iata()
      IaType.
        SetStartAddress("2000:0:0:1::100").
        SetStep(1).
        SetSize(10).
        SetPrefixLen(64) 
  ```

* <b><i>UHD400</i></b>: Support of Egress Flow tracking for multiple flows is added any location of supported fields upto 10 bits.
  - Supported fields are `ethernet.src/dst`, `vlan.id`, `vlan.priority`, `ipv4.src/dst`, `ipv4.precedence`, `ipv6.src/dst`, `ipv6.traffic_class`.
  ```go
    eth := flow.EgressPacket().Add().Ethernet()
    ipv4 := flow.EgressPacket().Add().Ipv4()
    ipv4Tag := ipv4.Dst().MetricTags().Add()
    ipv4Tag.SetName("flow_ipv4_dst")
    ipv4Tag.SetOffset(22)
    ipv4Tag.SetLength(10)
  ```

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for ISIS Simulated Topology. [More Details](https://github.com/open-traffic-generator/models/pull/327)
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
  Note: `get_metrics/states` APIs are only applicable for the connected emulated routers and not for the simulated routers.

* <b><i>Ixia-C, UHD400, Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for fetching `lldp_neighbors[i].custom_tlvs[j].information` as hex bytes using `get_states` API. [More details](https://github.com/open-traffic-generator/models/pull/392)
	
### Bug Fix(s)
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where for certain scenarios such as retrieving large control capture buffer or fetching `get_metrics/states` for large amount of data results in errors similar to <i>"grpc: received message larger than max (7934807 vs. 4194304)"</i>. 
  - For such scenarios note that the grpc receive buffer on the client should also be locally increased if necessary from default value of 4 MB.

* <b><i>Ixia-C</i></b>: Issue is fixed for LLDP where, when multiple custom tlvs are configured to be sent, sometimes the bytes in the `information` field in the outgoing LLDP PDUs were corrupted.


#### Known Issues
* <b><i>Ixia-C, UHD400</i></b>: When the DHCPv6 client type is configured as IANAPD, DHCPv6 Server `get_states` doesn't show IAPD addresses
* <b><i>Ixia-C, UHD400</i></b>: When DHCPv6 Server is configured with multiple pools, The DHCPv6 clients are not accepting addresses from different pools.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
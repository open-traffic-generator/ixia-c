#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.8.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.8.0/artifacts/openapi.yaml)         |
| snappi                        | [1.8.0](https://pypi.org/project/snappi/1.8.0)        |
| gosnappi                      | [1.8.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.8.0)        |
| keng-controller               | [1.8.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.25](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.393](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.8.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.30](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.14.8](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.8.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.3.5](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.3/1.3.5/artifacts.tar)         |


# Release Features(s)

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for DHCPv6 Client and Server in control plane. [details](https://github.com/open-traffic-generator/models/pull/369)
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
  Note: Support for `devices[i].dhcp_server.ipv6_interfaces[j].options` and `devices[i].dhcp_server.ipv6_interfaces[j].leases[k].ia_type.choice.iapd/ianapd` will be available in the subsequent sprints.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: gNMI support added to fetch control plane metics and states of DHCPv6 [Client](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-dhcpv6client.txt) and [Server](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-dhcpv6server.txt).
  - User able for DHCPv6 Client/Server metrics using following gNMI paths.
   ```gNMI
    // dhcpv6 client
    dhcpv6-clients/dhcpv6-client[name=*]/state/counters

    // dhcpv6 server
    dhcpv6-servers/dhcpv6-server[name=*]/state/counters​
   ```
  - User able for DHCPv6 Client/Server states using following gNMI paths.
   ```gNMI
    // dhcpv6 client
    dhcpv6-clients/dhcpv6-client[name=*]/state/interface

    // dhcpv6 server
    dhcpv6-servers/dhcpv6-server[name=*]/state/interface
   ```


#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
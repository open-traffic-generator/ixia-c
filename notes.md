#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.12.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.12.0/artifacts/openapi.yaml)         |
| snappi                        | [1.12.0](https://pypi.org/project/snappi/1.12.0)        |
| gosnappi                      | [1.12.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.12.0)        |
| keng-controller               | [1.12.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.25](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.398](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.12.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.30](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.14.12](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.12.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.3.5](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.3/1.3.5/artifacts.tar)         |


# Release Features(s)

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for DHCPv6 client interfaces to be used as source/destination for device traffic.
  - In this the learned IPv6 address from the DHCPv6 server is automatically populated in `ipv6.src/dst` if the choice is set to auto.dhcp.
  ```go
    clientToServerFlow.SetName("ClientToServer").TxRx().Device().
    SetTxNames([]string{"DHCPv6ClientName"}).
    SetRxNames([]string{"DHCPv6ServerInterfaceName"})
    clientToServerFlow.Packet().Add().Ethernet()
    clientToServerFlowIp := clientToServerFlow.Packet().Add().Ipv6()
    clientToServerFlowIp.Src().Auto().Dhcp()
    
    serverToClientFlow.SetName("ServerToClient").TxRx().Device().
        SetTxNames([]string{"DHCPv6ServerInterfaceName"}).
        SetRxNames([]string{"DHCPv6ClientName"})
    serverToClientFlow.Packet().Add().Ethernet()
    serverToClientFlowIp := serverToClientFlow.Packet().Add().Ipv6()
    serverToClientFlowIp.Dst().Auto().Dhcp()
  ```
  Note: For DHCPv6 client to DHCPv6 server each flow supports only one source endpoint in tx_rx.device.tx_names, hence a separate flow has to be configured for each DHCPv6 client if packet[i].ipv6.src.auto.dhcp is set.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for `devices[i].ethernets[j].dhcpv6_interfaces[k].options/options_request` and `devices[i].dhcp_server.ipv6_interfaces[j].options`.
  ```go
        // Configure a DHCPv6 Client
        dhcpv6Client := d1Eth1.Dhcpv6Interfaces().Add().
          SetName("DHCPv6-Client")
        
        .........

        //options
        dhcpv6Client.Options().VendorInfo().
          SetEnterpriseNumber(1000).
          OptionData().
          Add().
          SetCode(88).
          SetData("enterprise")
        dhcpv6Client.Options().VendorInfo().AssociatedDhcpMessages().All()

        //option request
        dhcpv6Client.OptionsRequest().Request().Add().BootfileUrl()
        dhcpv6Client.OptionsRequest().Request().Add().Custom().SetType(3)
        dhcpv6Client.OptionsRequest().AssociatedDhcpMessages().All()

        // Configure a DHCPv6 Server
        dhcpv6Server := d2.DhcpServer().Ipv6Interfaces().Add().
          SetName("DHCPv6-Server")

        ............
        dhcpv6Server.Options().BootfileUrl().SetUrl("URL").AssociatedDhcpMessages().All()
	      dhcpv6Server.Options().Dns().SetPrimary("8::8").SecondaryDns().Add().SetIp("9::9")
  ```

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for `devices[i].dhcp_server.ipv6_interfaces[j].leases[k].ia_type.choice.iapd/ianapd`.
  ```go
        // Configure a DHCPv6 Server
        dhcpv6Server := d2.DhcpServer().Ipv6Interfaces().Add().
          SetName("DHCPv6-Server")

        dhcpv6ServerPool := dhcpv6Server.SetIpv6Name("p2d1ipv6").
          Leases().Add().
          SetLeaseTime(3600)
        IaType := dhcpv6ServerPool.IaType().Iapd()
        IaType.
          SetAdvertisedPrefixLen(64).
          SetStartPrefixAddress("2000:0:0:100::0").
          SetPrefixStep(1).
          SetPrefixSize(10)
  ```

* <b><i>Ixia-c</i></b>: Support added for sending Organizational tlvs in LLDP PDUs.
  ```go
    lldp := config.Lldp().Items()[0]

    orgInfos1 := lldp.OrgInfos().Add()
    orgInfos1.Information().SetInfo("AABB11")
    orgInfos1.SetOui("1abcdf").SetSubtype(1)
  ```
  Note: Received Organizational tlvs can be seen in the `get_states` response of `lldp_neighbors`.


#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
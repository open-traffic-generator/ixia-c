#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.5.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.5.0/artifacts/openapi.yaml)         |
| snappi                        | [1.5.1](https://pypi.org/project/snappi/1.5.0)        |
| gosnappi                      | [1.5.1](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.5.0)        |
| keng-controller               | [1.5.1-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.12](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.383](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.5.1-3](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.29](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.14.2](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.5.1-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.2.8](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.2/1.2.8/artifacts.tar)         |


# Release Features(s)
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for DHCPv4 Client and Server in control plane. [details](https://github.com/open-traffic-generator/models/pull/371)
  - User will be the able to configure DHCPv4 Client and Server by the following code snippet. More comprehensive [B2B example](https://github.com/open-traffic-generator/featureprofiles/blob/dev-dhcp/feature/dhcp/dhcpv4_client_server_b2b_test.go) 
  ```go
    // Configure a DHCP Client
      dhcpclient := d1Eth1.Dhcpv4Interfaces().Add().
          SetName("p1d1dhcpv41")
  
      dhcpclient.FirstServer()
      dhcpclient.ParametersRequestList().
          SetSubnetMask(true).
          SetRouter(true).
          SetRenewalTimer(true)

    // Configure a DHCP Server
      d2Dhcpv4Server := d2.DhcpServer().Ipv4Interfaces().Add().
          SetName("p2d1dhcpv4server")
  
      d2Dhcpv4Server.SetIpv4Name("p2d1ipv4").AddressPools().
          Add().SetName("pool1").
          SetLeaseTime(3600).
          SetStartAddress("100.1.100.1").
          SetStep(1).
          SetCount(1).
          SetPrefixLength(16).Options().SetRouterAddress("100.1.0.1").SetEchoRelayWithTlv82(true)
  ``` 

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: gNMI support added to fetch DHCPv4 Client and Server statistics. 
  - [DHCPv4 Client](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-dhcpv4client.txt)

  ```gNMI
    # Combined metrics and states information
    dhcpv4-clients/dhcpv4-client[name=clientName]/state

    # Metrics information 
    dhcpv4-clients/dhcpv4-client[name=clientName]/state/counters

    # States information
    dhcpv4-clients/dhcpv4-client[name=clientName]/state/interface
  ```
  - [DHCPv4 Server](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-dhcpv4server.txt)

  ```gNMI
    # Combined metrics and states information
    dhcpv4-servers/dhcpv4-servers[name=serverName]/state

    # Metrics information
    dhcpv4-servers/dhcpv4-servers[name=serverName]/state/counters
    
    # States information
    dhcpv4-servers/dhcpv4-servers[name=serverName]/state/leases (For now it will return empty responses.)
  ```
    Note: Support for `GetStates`/`dhcpv4-servers/dhcpv4-servers[name=serverName]/state/leases` of DHCP Server will be provided in subsequent release. 

### Bug Fix(s)
* <b><i>UHD400</i></b>: An issue has been detected whereby some internal certificates used in the UHD400 solution has expired.
  The most common manifestation of this is that despite proper ARP resolution, packets of `flows` of type `device` might not get forwarded by the DUT, resulting in 0 `rx` statistics.
  This issue is visible for UHD400/ixia-c releases up to `v1.5.0-1`.

* <b><i>UHD400</i></b>: An issue has been fixed where, Despite proper ARP resolution, packets of `flows` of type `device` might not get forwarded by the DUT, resulting in 0 `rx` statistics.
  This issue is visible for UHD400/ixia-c releases up to `v1.5.0-1`.


#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `set_control_state.protocol.all.start` can get stuck till the time all DHPCv4 clients receive the leased IPv4 addresses from the DHCPv4 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
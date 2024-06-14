#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.5.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.5.1/artifacts/openapi.yaml)         |
| snappi                        | [1.5.1](https://pypi.org/project/snappi/1.5.1)        |
| gosnappi                      | [1.5.1](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.5.1)        |
| keng-controller               | [1.5.1-12](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.12](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.383](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.5.1-6](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.29](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.14.2](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.5.1-12](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.2.9](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.2/1.2.9/artifacts.tar)         |


# Release Features(s)
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: gNMI support for `GetStates` of DHCP Server added.
  - [DHCPv4 Server](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-dhcpv4server.txt)

  ```gNMI
    # States information
    dhcpv4-servers/dhcpv4-servers[name=serverName]/state/leases
  ```
* <b><i>UHD400</i></b>: Value-list support added for IPv4 `dscp` field.
  ```go
    flowEth := flow.Packet().Add().Ethernet()
    .... 
    ipv4 := flow.Packet().Add().ipv4()
	  ipv4.Src().SetValue(srcAddr)
	  ipv4.Dst().SetValue(dstAddr)
	  ipv4.Priority().Dscp().Phb().SetValues([]uint32{10,12,14,18 ...})
  ```

### Bug Fix(s)
* <b><i>Ixia-C</i></b>: Issue where withdrawing BGP/BGP+ routes using `set_control_state.protocol.route.withdraw` was failing in multi-nic topology is fixed.
* <b><i>Ixia Chassis & Appliances(AresOne)</i></b>: Issue where after running BGP/BGP+ tests on multi-nic ports would result intermittently in `context deadline` errors for subsequent tests/sub tests is fixed.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue where after running tests involving continuous connect/reconnect of test ports for long duration (e.g. 2 - 3 hrs) would result in intermittent `context deadline` errors for a bunch of consecutive tests is fixed.


#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4 clients receive the leased IPv4 addresses from the DHCPv4 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
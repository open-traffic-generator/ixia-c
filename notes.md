#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.13.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.13.0/artifacts/openapi.yaml)         |
| snappi                        | [1.13.0](https://pypi.org/project/snappi/1.13.0)        |
| gosnappi                      | [1.13.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.13.0)        |
| keng-controller               | [1.13.0-9](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.90](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.404](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.13.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.14.14](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.13.0-9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.4.0](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.4/1.4.0/artifacts.tar)         |


# Release Features(s)

* <b><i>Keng-Operator</i></b>: go version is upgraded to use `v1.23` along with security updates.

* <b><i>Ixia-C</i></b>: Support added to send flows over DHCPv4 endpoints.
  ```go
    f1 := config.Flows().Add()​
    f1.SetName(flowName).​
      TxRx().Device().​
      SetTxNames([]string{"p1d1dhcpv4_1"}).​
      SetRxNames([]string{"p2d1ipv4"})​
    f1Ip := f1.Packet().Add().Ipv4()​
    // will be populated automatically with the the dynamically allocated Ip to DHCP client​
    f1Ip.Src().Auto().Dhcp()​
    …​
    f2Ip.Dst().Auto().Dhcp()​
  ```

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for LLDP.
  ```go
    // LLDP configuration.​
    lldp := config.Lldp().Add()​
    lldp.SystemName().SetValue(lldpSrc.systemName)​
    lldp.SetName(lldpSrc.otgName)​
    lldp.Connection().SetPortName(portName)​
    lldp.ChassisId().MacAddressSubtype().​
      SetValue(lldpSrc.macAddress)​
  ```
	
### Bug Fix(s)
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: There was degradation in time taken for starting large number of  BGP/BGP+ peers on one port. This issue is fixed.​

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: There was an exception being returned from `set_config` on creating multiple loopbacks in a device and configuring protocols on top of that. This issue is fixed.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If multiple routes are received by a BGP/BGP+ peer with some having MED/Local Preference and some not having MED/Local Preference, in `get_states` MED/Local Preference were not being correctly returned. This issue is fixed.


#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
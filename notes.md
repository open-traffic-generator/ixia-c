### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.55.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.55.0/artifacts/openapi.yaml)         |
| snappi                        | [1.55.0](https://pypi.org/project/snappi/1.55.0)        |
| gosnappi                      | [1.55.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.55.0)        |
| keng-controller               | [1.55.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.544](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.530](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.55.0-3](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.4.0](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.55.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.55.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |


### Release Feature(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for CFM packet header for `op_code` of type `ccm`, `lbm` and `lbr` in flows. [details](https://github.com/open-traffic-generator/models/pull/468)
  - User can configure CCM message using following snippet,
    ```go
        flow1.Packet().Add().Ethenet()
        cfmPdu := flow1.Packet().Add().Cfm()
        ...
        cfmPdu.SetMdLevel(0)
        ccm := cfmPdu.OpCode().Ccm()
        ...
        ccm.MaEndpointIdentifier().SetValue(1000)
        cfm := ccm.EthernetOamProtocol().Cfm()
        cfm.MdName().SetCharStr("testdomain")
        cfm.ShortMaName().SetCharStr("test")
    ```
  - User can configure LBM message using following snippet,
    ```go
      flow2.Packet().Add().Ethenet()
      cfmPdu := flow2.Packet().Add().Cfm()
      cfmPdu.SetMdLevel(0)
      lbm := cfm.OpCode().Lbm()
      lbm.TransactionId().SetValue(100)
    ```
         
### Bug Fix(s):
* <b><i>Ixia-C</i></b>: Issue is fixed where `flow[i].packet[j].ipv4.options[k].choice=router_alert` was resulting in error `"Flow <name> has IPv4 options specified, which is currently supported for OTG-HW only"` on `set_config`. This was affecting tests which required RSVP raw traffic flows.

* <b><i>Ixia-C & UHD400</i></b>: Issue is fixed where if previously tests had been run which had loopback interfaces configured, running BMP tests in active mode would intermittently result in a `ixia-c-protocol-engine` crash.

* <b><i>Ixia-C & UHD400</i></b>: Issue is fixed where if previously tests had been run which had loopback interfaces configured, running BMP tests in passive mode would result in BMP session not coming up.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where sometimes errors from `keng-layer23-hw-server` was not being propagated to the test program where the error message exceeded 8000 bytes.

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
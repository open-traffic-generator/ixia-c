### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.51.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.51.0/artifacts/openapi.yaml)         |
| snappi                        | [1.51.0](https://pypi.org/project/snappi/1.51.0)        |
| gosnappi                      | [1.51.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.51.0)        |
| keng-controller               | [1.51.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.517](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.51.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.51.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.51.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |


### Release Feature(s):
* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne) & UHD400</i></b>: Support added for allowing user to specify a delay between Notification and FIN for BGP/BGP+ `set_control_action`. [details](https://github.com/open-traffic-generator/models/pull/460)
    - User can enable BGP/BGP+ FIN delay using following snippet, 
        ```go
            ceaseAction := gosnappi.NewControlAction()
            ceaseAction.Protocol().Bgp().Notification().
                        SetNames([]string{"BGP4.peer"}).
                        Custom().SetCode(6).SetSubcode(6).
                        SetFinDelay(500) // wait for 500 millisecond before tearing down connection.

         ```
    Note: Normally DUT will initiate the TCP FIN on receiving the Notification before the time expires.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for `flows[i].packet.ipv4.options.timestamp` and `flows[i].packet.ipv4.options.end_of_options`. [details](https://github.com/open-traffic-generator/models/pull/464)
    - IPv4 `timestamp` option can be configured using following snippet,
    ```go
        ipv4 := gosnappi.NewConfig().Flows().Add().Packet().Add().Ipv4()
        ts := ipv4.Options().Add().Timestamp()
        tsFormat := ts.Format().Timestamps().Add() // Other options for ts format are Format().AddressAndTimestamps() and Format().PrespecifiedAddressAndTimestamps()
    ```
    
    - IPv4 `end_of_options` option can be added using following snippet,
    ```go
        ipv4.Options().Add().EndOfOptions()
    ```

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
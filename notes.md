### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.28.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.28.0/artifacts/openapi.yaml)         |
| snappi                        | [1.28.2](https://pypi.org/project/snappi/1.28.2)        |
| gosnappi                      | [1.28.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.28.2)        |
| keng-controller               | [1.28.0-33](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.448](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.28.0-10](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.28.3](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.28.0-33](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.6](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.6/artifacts.tar)         |


### Release Features(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for `tx/rx_rate_bps` in `flow_metrics`.

    ```sh
        # flow Tx rate in bits per second
        flows/flow[name=*]/state/out-rate

        # flow Rx rate in bits per second
        flows/flow[name=*]/state/in-rate
    ```

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for `tx/rx_l1_rate_bps` in `flow_metrics`.
    Note: This is not yet supported while fetching flow metrics using gNMI.

* <b><i>UHD400</i></b>:Support added for single MPLS header in flows [Segment Routing, Static MPLS & MPLSoUDPoIPv4].
    ```go
        f1Eth := f1.Packet().Add().Ethernet()​
        ...​
        f1Mpls := f1.Packet().Add().Mpls()​
        f1Mpls.Label().SetValue(100)​​​
    ```
    Notes:
        1. UDP checksum is always zero which can result in failure for UDP over IPv6 tunneling use-cases.
        2. TCP checksum is always zero which can result in failure for tunneling use-cases.
        3. Egress Tracking on MPLS label header is not supported.

### Bug Fix(s)
* <b><i>Ixia-C</i></b>: Issue is fixed where MPLS over GRE in flows was resulting in malformed packets to be transmitted.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where OSPFv2 DB Descriptor PDUs were carrying MTU value as zero resulting OSPFv2 sessions to be stuck in ExStart state with certain DUTs.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where flow transmit state wouldn't move to `stopped` unless `flow_transmit.stop` was explicitly executed for fixed duration flows.


### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.61.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.61.0/artifacts/openapi.yaml)         |
| snappi                        | [1.61.0](https://pypi.org/project/snappi/1.61.0)        |
| gosnappi                      | [1.61.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.61.0)        |
| keng-controller               | [1.61.0-9](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.544](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.536](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.61.0-4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.4.0](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.61.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.61.0-9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |
| <b>ARM64</b>                                  |
| keng-controller-arm64         | [1.61.0-9](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller-arm64)    |
| ixia-c-traffic-engine-arm64   | [1.8.0.563](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine-arm64)       |


### Release Feature(s):
* <b><i>Ixia-C</i></b>: Support added for `packet_loss_duration` in flow metrics.
    - User needs to enable `packet_loss_duration` flow option during configuration to allow publishing of this metric.
        ```go
            config.Options().FlowOptions().SetPacketLossDuration(true)
        ```
    - To retrieve the metric use the following snippet.
        ```go
            for _, m := range flowMetrics.Items() {
                if m.HasPacketLossDuration() {
                    lossDuration := m.PacketLossDuration().Value()
                }
            }
        ```
    Note: gNMI Support will be available in a future release.

* <b><i>Ixia-C</i></b>: Support added for enabling and fetching `data-integrity` port statistics in `set_config` and `get_metrics`. [details](https://github.com/open-traffic-generator/models/pull/454)
    - To configure enable `data-integrity` at global level.
    ```go
        cfg.Options().PortOptions().SetDataIntegrity(true)
    ```
    - to fetch `data-integrity` metrics use the following snippet. 
        ```go
            req := gosnappi.NewMetricsRequest()
            reqPort := req.Port()
            reqPort.SetPortNames([]string{"port1", "port2"})
            res, err := client.GetMetrics(req)
        ```
        - If `data-integrity` is enabled, new object called `data-integrity` will be returned in the `port` metrics which will contain two new fields `total-frames-rx` and `error-frames-rx`.

    - gNMI support [details](https://github.com/open-traffic-generator/models-yang/pull/51):
        ```
            ports/port[name=*]/state/data-integrity
        ```
      Note: `featureprofiles` users needs to sync to latest otherwise retrieval of OTG Port counters/state using gNMI might give incorrect results.
    
    Note: Only frames generated from flows will have `data-integrity` enabled.

* <b><i>Ixia-C & UHD400</i></b>: Support added for enabling/disabling Overload Bit for ISIS simulated routers on the fly. [details](https://github.com/open-traffic-generator/models/pull/479)
    ```go
         setAction := gosnappi.NewControlAction()
            setOlBit := setAction.Protocol().Isis().UpdateOverloadBit()
            setOlBit.SetRouterNames([]string{"isis-sim1", "isis-sim2"})
            setOlBit.Set()/Unset()
        client.Api().SetControlAction(setAction)
    ```

* <b><i>Ixia-C & UHD400</i></b>: Support added for changing the metric of ISIS Simulated Links on the fly. [details](https://github.com/open-traffic-generator/models/pull/476)
    ```go
        cu := gosnappi.NewConfigUpdate()
        cu.Protocols().Isis().Interfaces().Add().
            SetNames([]string{"sim-link1", "sim-link2"}).
            Attributes().Add().SetMetric(100)
        // Additional groups of simulated links can be added 
        // for which metric has to be changed to a different value.
        msg1, err := client.UpdateConfig(cu)
    ```


### Bug Fix(s):
* <b><i>Ixia-C</i></b>: Issue is fixed where `get_metrics` was returning error `"panic: runtime error: index out of range [1] with length 0"` intermittently in some scenarios when it was invoked immediately after `set_control_state.traffic.flow_transmit.stop`.


### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.33.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.33.0/artifacts/openapi.yaml)         |
| snappi                        | [1.33.3](https://pypi.org/project/snappi/1.33.3)        |
| gosnappi                      | [1.33.3](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.33.3)        |
| keng-controller               | [1.33.0-28](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.462](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.33.0-8](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.33.5](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.33.0-28](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.9](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.9/artifacts.tar)         |


### Release Features(s):
* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne) & UHD400</i></b>: Support added for ISIS Graceful Restart(both helper & restarting roles) in Unplanned Mode[RFC 8706]. [details](https://github.com/open-traffic-generator/models/pull/423)
    - To configure Graceful Restart,
        ```go
            isisRtr.GracefulRestart().SetHelperMode(true)
        ```
    - To trigger Unplanned Graceful Restart,
        ```go
            grAction := gosnappi.NewControlAction()
            isisRestart := grAction.Protocol()
                .Isis().InitiateRestart()
            isisRestart.SetRouterNames([]string{"isisRtr"})
                .Unplanned()
                .SetHoldingTime(30)
                .SetRestartAfter(20)

            if _, err := gosnappi.NewApi().SetControlAction(grAction); err != nil {
                t.Fatal(err)
            }
        ```
    - New metrics exposed in ISIS `get_metrics` are `gr_initiated`,`gr_succeeded`,`neighbor_gr_initiated`,`neighbor_gr_succeeded`.
    - New `get_states` option `isis_adjacencies` is introduced to access adjacency information per ISIS neighbor including received Graceful Restart TLV.

* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne) & UHD400</i></b>: gNMI support added to fetch `gr-initiated`,`gr-succeeded`,`neighbor-gr-initiated`,`neighbor-gr_succeeded` and `adjacencies` for ISIS.
    ```gNMI
    // To fetch ISIS gr-initiated,gr-succeeded,neighbor-gr-initiated,neighbor-gr_succeeded counters
    isis-routers/isis-router[name=*]/state/counters

    // To fetch ISIS adjacencies state
    isis-routers/isis-router[name=*]/state/adjacencies/state/adjacencies[neighbor-system-id=*][interface-name=*]/state
    ```

    Note: `featureprofiles` users needs to sync to latest otherwise retrieval of OTG ISIS counters/state using gNMI might give incorrect results.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Version compatibility check added for IxOS installed on chassis.
    - `set_config` will now return error, if ports are present in the configuration connected to chassis with IxOS version `< 9.20EA`.
    - `set_config` will now return warning, if ports are present in the configuration connected to chassis with IxOS version `> 11.00EA`.

* <b><i>UHD400</i></b>: support added to enable capture on multiple test ports.
    ```go
        c1 := config.Captures().Add().SetName("Capture")
        c1.SetPortNames([]string{"p1", "p2"})

        s := gosnappi.NewControlState()
        s.Port().
            Capture().
            SetPortNames([]string{"p1", "p2"}).
            SetState(gosnappi.StatePortCaptureState.START/STOP)
    ```

* <b><i>Snappi</i></b>: Support added to set `maximum_receive_buffer_size`  and `chunk_size` in `MB` for gRPC streaming API creation.
    ```py
        grpc_api = snappi.api(location="localhost:40051",
                          transport=snappi.Transport.GRPC)

        grpc_api.enable_grpc_streaming = True
        grpc_api.chunk_size = 2 # 2 MB instead of default 4 MB

        grpc_api.maximum_receive_buffer_size = 10 # 10 MB instead of default 4 MB
        
    ```
    Note: `gosnappi` already supports both feature.


### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
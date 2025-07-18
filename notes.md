### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.33.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.33.0/artifacts/openapi.yaml)         |
| snappi                        | [1.33.0](https://pypi.org/project/snappi/1.33.0)        |
| gosnappi                      | [1.33.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.33.0)        |
| keng-controller               | [1.33.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.461](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.33.0-3](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.33.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.33.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.7](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.7/artifacts.tar)         |


### Release Features(s):
* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne), UHD400</i></b>:Support added to enable communication between snappi/gosnappi client and `keng-controller` in streaming mode.
    - User needs to enable grpc streaming while creating connection with `keng-controller`.
    ```go
    api := gosnappi.NewApi()​
    grpcTransport := api.NewGrpcTransport().​
    SetClientConnection(conn).​
    SetRequestTimeout(30 * time.Second)​
    grpcTransport.SetLocation(addr).EnableGrpcStreaming().SetStreamChunkSize(100)​ // max 100 MB per chunk
    ```
    Note: 
        - If `StreamChunkSize` is not explicitly specified in streaming mode, default chunk size of 4 MB will be used.
        - By default client will communicate in non-streaming mode as earlier.



### Bug Fix(s):
* <b><i>Ixia-C, UHD400</i></b>: Issue is fixed where, for iBGP sessions, if `as-path` segments were explicitly specified for a route, the local AS was being incorrectly prepended to the transmitted as-path, resulting in the DUT dropping the route.


### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
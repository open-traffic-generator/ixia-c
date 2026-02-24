### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.45.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.45.0/artifacts/openapi.yaml)         |
| snappi                        | [1.45.0](https://pypi.org/project/snappi/1.45.0)        |
| gosnappi                      | [1.45.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.45.0)        |
| keng-controller               | [1.45.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.504](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.45.0-4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.45.1](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.45.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |


### Release Feature(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for enabling and fetching `data-integrity` port statistics in `set_config` and `get_metrics`. [details](https://github.com/open-traffic-generator/models/pull/454)
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
    
    Note: Only frames generated from flows will have `data-integrity` enabled.

* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne) & UHD400</i></b>: Support added for capturing `rx` packets on ports using `pcapng` format.
    ```go
        c1 := config.Captures().Add().SetName("Capture")
        c1.SetPortNames([]string{"port1"})
        c1.SetFormat("pcapng")

    ```

* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne) & UHD400</i></b>: gNMI support is added for `link-bandwidth` subtype in `transitive_2octet_as_type` under `extended_communities` for BGP/BGP+ routes in `get_states`. [details](https://github.com/open-traffic-generator/models-yang/pull/50)
    ```
      bgp-peers/bgp-peer[name=*]/unicast-ipv4-prefixes/unicast-ipv4-prefix/state/extended-community[i]/structured/transitive_2octet_as_type/link_bandwidth_subtype

      bgp-peers/bgp-peer[name=*]/unicast-ipv6-prefixes/unicast-ipv6-prefix/state/extended-community[i]/structured/transitive_2octet_as_type/link_bandwidth_subtype
    ```

### Bug Fix(s):
* <b><i>Ixia-C & UHD400</i></b>: Issue is fixed in BGP/BGP+ where the pod/container would sometimes restart on trying to start BGP for the first time with `ixstack_bgp_accept_check` backtrace present in the protocol-engine logs, especially on slower systems.

* <b><i>Ixia-C & UHD400</i></b>: The default mode of transmission of BGPv4 routes from BGP peers is changed from `MP_REACH/UNREACH` to `Traditional REACH/UNREACH`, to bring it in sync with default behavior of Ixia Chassis & Appliances(Novus, AresOne).

* <b><i>otg-gnmi-server</i></b>: Issue is fixed in `models-yang` due to which error `schema "lsp-id": "192000002001-00-00" does not match regular expression pattern "^([0-9a-fA-F]*)$"` would be seen during gNMI client validation when accessing ISIS `lsp-id` using `/isis-routers/isis-router[name=*]/state/link-state-database/lsp-states/lsps[lsp-id=*][pdu-type=*]/state/lsp-id`.

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
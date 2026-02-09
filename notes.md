### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.44.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.44.0/artifacts/openapi.yaml)         |
| snappi                        | [1.44.0](https://pypi.org/project/snappi/1.44.0)        |
| gosnappi                      | [1.44.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.44.0)        |
| keng-controller               | [1.44.0-8](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.501](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.44.0-8](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.44.1](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.44.0-8](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |


### Release Feature(s):
* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne) & UHD400</i></b>: Support added for `link_bandwidth_subtype` in `transitive_2octet_as_type` under `extended_communities` for BGP/BGP+ routes in `set_config` and `get_states`. [details](https://github.com/open-traffic-generator/models/pull/455)
    - To configure:
        ```go
            ext_comm := route.ExtendedCommunities().Add()
            ext_comm.Transitive2OctetAsType().LinkBandwidthSubtype().
                            SetGlobal2ByteAs(peer.AsNumber()).
                            SetBandwidth(10000.0)
        ```
    - To fetch:
        ```go
            req := gosnappi.NewStatesRequest()
            req.BgpPrefixes().SetBgpPeerNames(peerNames)
            res, err := client.GetStates(req)
            if err != nil {
                return nil, err
            }
            
            learnedRoutes := res.BgpPrefixes()
            liFirstPeer := actualBGPv4Prefix.Items()[0]
            route := liFirstPeer.Ipv4UnicastPrefixes().Items()[0]
            extComm := route.ExtendedCommunities().Items()[0]
            if ( extComm.Structured().Transitive2OctetAsType().LinkBandwidthSubtype().Bandwidth()!= 1000.0 ||
                    extComm.Structured().Transitive2OctetAsType().LinkBandwidthSubtype().Global2ByteAs() != 65000){
                    t.Fatal("Bandwidth value / AS value not as expected.")
            }
        ```
    Note: gNMI support will be added in the subsequent sprint once `ondatra` incorporates latest [`models-yang`](https://github.com/open-traffic-generator/models-yang/pull/50).

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for auto detection of port left in dirty state by other user and automatic reboot during `set_config`.
 

### Bug Fix(s):
* <b><i>otg-gnmi-server</i></b>: Issue is fixed in `models-yang` due to which error `validation failed: /device/flows/flow/tagged-metrics/tagged-metric/state/tags/tag-value/value-as-hex: schema "value-as-hex": "0x02" does not match regular expression pattern "^([0-9a-fA-F]*)$"` would be seen during gNMI client validation for tagged metrics.

* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne) & UHD400</i></b>: Issue is fixed where incorrect packet template related to ICMPv6 over IPv4 and ICMPv4 over IPv6 was incorrectly accepted by the controller, resulting in incorrect behavior including `context deadline exceeded` error. Instead proper error will now be returned on `set_config` and only valid configurations of `icmp` over `ipv4` and `icmpv6` over `ipv6` will be accepted.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where in certain scenarios the time taken for `set_config` API was seen to be increasing for large number of iterations.

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
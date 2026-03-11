### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.48.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.48.0/artifacts/openapi.yaml)         |
| snappi                        | [1.48.0](https://pypi.org/project/snappi/1.48.0)        |
| gosnappi                      | [1.48.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.48.0)        |
| keng-controller               | [1.48.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.507](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.48.0-4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.48.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.48.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |


### Release Feature(s):
* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne) & UHD400</i></b>: Support added for retrieval of BGP MPLS IPv4/v6 labeled unicast prefixes. [details](https://github.com/open-traffic-generator/models/pull/447)
    - To enable storage of MPLS prefixes, 
        ```go
            bgpPeer.LearnedInformationFilter().SetIpv4MplsUnicastPrefix(true).SetIpv6MplsUnicastPrefix(true)
         ```
    - To fetch prefixes,
        ```go
            req := gosnappi.NewStatesRequest()
            req.BgpPrefixes().SetBgpPeerNames(peerNames)
            req.BgpPrefixes().SetPrefixFilters([]gosnappi.BgpPrefixStateRequestPrefixFiltersEnum{
                gosnappi.BgpPrefixStateRequestPrefixFilters.IPV4_MPLS_UNICAST,
                gosnappi.BgpPrefixStateRequestPrefixFilters.IPV6_MPLS_UNICAST,
            })
            res, _ := client.GetStates(req)
            // MPLS Prefix information can be accessed within the following objects.
            res.BgpPrefixes().Ipv4MplsUnicastPrefixes()
            res.BgpPrefixes().Ipv6MplsUnicastPrefixes()
        ```
    Note: `gNMI` support will be added in subsequent sprints.

* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne) & UHD400</i></b>: Support added for sending and withdrawing IPv4 routes from BGPv4 peers using `MP_REACH/UNREACH` NLRIs. [details](https://github.com/open-traffic-generator/models/pull/439)
    ```go
        bgpPeer := bgpIntf.
                Peers().
                Add().
                ...
                .SetTraditionalNlriForIpv4Routes(false) 
    ```
    Note: Default behavior is to send/withdraw IPv4 routes from BGPv4 peers using `Traditional REACH/UNREACH` NLRI.

### Bug Fix(s):
<b><i>Ixia-C & UHD400</i></b> Issue is fixed in DHCPv4 client where the client was unable to use the offered address provided by pre-configured DHCPv4 server.

<b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b> Issue is fixed for RSVP-TE where assigned ERO was not being published for `get_states` for `rsvp_lsps[i].ipv4_lsps[j].eros` on the ingress test port.

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
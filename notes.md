### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.65.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.65.0/artifacts/openapi.yaml)         |
| snappi                        | [1.65.0](https://pypi.org/project/snappi/1.65.0)        |
| gosnappi                      | [1.65.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.65.0)        |
| keng-controller               | [1.65.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.921](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.545](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.65.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.4.4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.65.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.65.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |
| <b>ARM64</b>                                  |
| keng-controller-arm64         | [1.65.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller-arm64)    |
| ixia-c-traffic-engine-arm64   | [1.8.0.563](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine-arm64)       |


### Release Feature(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for L3VPN including v4 & v6 routes over BGP/BGP+ peers. This includes support of `get_states` for inspecting received L3VPN v4/v6 routes. [details](https://github.com/open-traffic-generator/models/pull/494)
    ```go
        bgpPeer := bgpIpv4Interface.Peers().Add().SetAsNumber(1111).
                        SetAsType(gosnappi.BgpV4PeerAsType.IBGP).
                        SetPeerAddress("20.20.20.2").
                        SetName("bgpPeer")
        bgpPeer.Capability().SetIpv4MplsVpn(true)
        bgpPeer.LearnedInformationFilter().​SetIpv4VpnUnicastPrefix(true) // similar for ipv6 prefixes

        // BGP/MPLS L3VPN VRF
        bgpVrf := bgpPeer.L3VpnVrfs().Add().SetName("VPN_A")
        bgpVrf.RouteTargetExport().Add().SetRtType(gosnappi.BgpRouteTargetRtType.AS_2OCTET).
            SetRtValue("65000:999")
        bgpVrf.RouteTargetImport().Add().SetRtType(gosnappi.BgpRouteTargetRtType.AS_2OCTET).
            SetRtValue("65000:999")

        bgpVrfRoute := bgpVrf.V4Routes().Add().SetName("bgpvpnv4route")
        bgpVrfRoute.RouteDistinguisher().SetRdType(gosnappi.BgpRouteDistinguisherRdType.AS_2OCTET).
            SetRdValue("65000:100")
        bgpVrfRRAddr := bgpVrfRoute.Addresses().Add().SetAddress("40.40.40.0").SetPrefix(24)
        bgpVrfRoute.MplsLabels().SetStart(1000).SetMax(1000).SetStep(1)

    ```
        Note: gNMI support for L3VPN prefixes in `get_states` will be available in a subsequent release.
    - Traffic for creating flows from VPN endpoints `append_config.flows` should be used to dynamically configure the flow after the VPN prefixes have been negotiated and have been retrieved via `get_states`.
    ```go
        ca := gosnappi.NewConfigAppend()
        f1 := ca.ConfigAppendList().Add().Flows().Add()
        ...
        f1.SetName("p2 -> p3").
            TxRx().Device().
            SetTxNames([]string{"bgpVrfRoute"}).
            SetRxNames([]string{"bgpVrfRouteDst"})
        f1Eth := f1.Packet().Add().Ethernet()
        ...
        f1Transport := f1.Packet().Add().Mpls()
        f1Transport.Label().SetValue(transportLabel) // the transport label, e.g. statically configured for SR 
                                                     // or retreived using get_states for RSVP-TE
        f1Transport.BottomOfStack().SetValue(0)
        f1Vpn := f1.Packet().Add().Mpls()
        f1Vpn.Label().SetValue(peLabel) // PE's advertised VPN label, retrieved using get_states
        f1Ip := f1.Packet().Add().Ipv4()
        f1Ip.Src().SetValue("40.40.40.0")
        f1Ip.Dst().SetValue("50.50.50.0")
    ```
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support for `flows[i].​packet[j].​icmpv6.​neighbor_solicitation` is added. [details](https://github.com/open-traffic-generator/models/pull/502)
    ```go
        eth := f.Packet().Add().Ethernet()
        eth.Src().SetValue("00:01:01:00:01:02")
        eth.Dst().SetValue("33:33:ff:00:00:05")  // Multicast MAC matching ipv6.dst

        ip := f.Packet().Add().Ipv6()
        ip.Src().SetValue("2001:db8::1")
        ip.Dst().SetValue("ff02::1:ff00:5")     
        ip.HopLimit().SetValue(255)

        ns := f.Packet().Add().Icmpv6().
            NeighborSolicitation()
        ns.TargetAddress().SetValue("2001:db8::5")
        ns.Options().Add().SourceLinkLayerAddress().
            LinkLayerAddress().
            SetValue("00:01:01:00:01:02")
    ```
* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `flows[i].​packet[j].​ipv6_extension_header.​routing.​segment_routing.​segment_list` now allows specification of an empty array.
* <b><i>Ixia-C</i></b>: `flows[i].metrics.latency.mode=store_forward` is now accepted.
* <b><i>Ixia-C</i></b>: Support added for `layer1[i].speed=speed_800_gbps`.

### Bug Fix(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where `set_control_state.protocol.all.state=start` was failing with error `"Error occurred while starting protocol on protocol ports: DOD failed ..."`.
* <b><i>Ixia-C</i></b>: Issue is fixed where `ixia-c-traffic-engine` container when started with `OPT_NO_PINNING` enabled crashes on startup (CrashLoopBackOff) when the host has more than 128 vCPUs with error in logs `"EAL: invalid parameter for --lcores"`.
    Note: This is verified upto 224 vCPUs enabled setup.
* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne) & UHD400</i></b>: Issue is fixed where `flows[i].packet[j].ipv4.fragment_offset` was not accepting values greater than 31. It now supports maximum value of 8191.

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.53.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.53.0/artifacts/openapi.yaml)         |
| snappi                        | [1.53.0](https://pypi.org/project/snappi/1.53.0)        |
| gosnappi                      | [1.53.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.53.0)        |
| keng-controller               | [1.53.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.522](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.53.0-3](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.53.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.53.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |


### Release Feature(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for disabling/enabling ISIS Simulated Links on the fly. [details](https://github.com/open-traffic-generator/models/pull/465)
    ```go
        cs := gosnappi.NewControlState()
        cs.Protocol().Isis().SimulatedLinks().
            SetNames([]string{"isisSimLink1", "isisSimLink2"}).
            SetState(gosnappi.StateProtocolIsisSimLinksState.DOWN/UP)
    ```
    Note: Links will be disconnected from both directions for supplied simulated links.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added port speed in port metrics. [details](https://github.com/open-traffic-generator/models/pull/472)
    - New attribute named `speed` is now available in port metrics response. This will contain the negotiated HW port speed in `KBps`. 
    - Examples are given below.
        - 100 Gbps is 100 * 1000 * 1000 / 8 = 12500000 KBps,
        - 1.6 Tbps (high performance devices) is 1.6 * 1000 * 1000 * 1000 / 8 = 200000000 KBps,
        - 10 Mbps (legacy devices) is 10 * 1000 / 8 = 1250 KBps

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for GTPv1 & GTPv2 packet headers in flows.
    - To configure GTPv2 packet:
        ```go
            flow := config.Flows().Add()
            ...
            eth := flow.Packet().Add().Ethernet()
            ...
            ip := flow.Packet().Add().Ipv4()
            ...

            udp := flow.Packet().Add().Udp()
            udp.SrcPort().SetValue(uint32(5000))
            udp.DstPort().SetValue(uint32(2123)) // 2123 is GTPv2

            gtp := flow.Packet().Add().Gtpv2()
            gtp.PiggybackingFlag().SetValue(1)
            gtp.TeidFlag().SetValue(1)
            gtp.MessageType().SetValue(32)
            gtp.Teid().SetValue(1)
            gtp.SequenceNumber().SetValue(10)
            gtp.Spare1().SetValue(1)
            gtp.Spare2().SetValue(1)
        ```
    - To configure GTPv1 flow:
        ```go
            flow := config.Flows().Add()
            ...
            eth := flow.Packet().Add().Ethernet()
            ...
            ip := flow.Packet().Add().Ipv4()
            ...

            udp := flow.Packet().Add().Udp()
            udp.SrcPort().SetValue(uint32(4000))
            udp.DstPort().SetValue(uint32(2152)) // 2152 is GTPv1

            gtp := flow.Packet().Add().Gtpv1()
            gtp.MessageType().SetValue(255)
            gtp.Teid().SetValue(10)

            inner := flow.Packet().Add().Ipv4()
            inner.Src().SetValue("11.0.0.1")
            inner.Dst().SetValue("12.0.0.1")
        ```
    Note: GTPv1 & GTPv2 flows are already supported in `Ixia-C`.

* <b><i>Keng-Operator</i></b>: Deprecated `gcr.io/kubebuilder/kube-rbac-proxy` is now removed.
    Note: Users of the `keng-operator` should now use the `yaml` published corresponding to the release at [ixiatg-operator.yaml(v0.4.0)](https://github.com/open-traffic-generator/keng-operator/releases/download/v0.4.0/ixiatg-operator.yaml)

    Example: The `yaml` at [openconfig/kne/manifests/keysight/ixiatg-operator.yaml](https://github.com/openconfig/kne/blob/main/manifests/keysight/ixiatg-operator.yaml) for usage in KNE environment.
    
### Bug Fix(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Attempted fix is included for intermittent issue where a test initially fails with `"context deadline exceeded"` for `set_config` and subsequent API calls, returned the error `"Processing of previous API in keng-layer23-hw-server still in progress. Cannot execute current API"`. 
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where incorrect information was being returned for contents of `is_reachability_tlvs` and `extended_is_reachability_tlvs`.
    - In `get_states` response for `isis_lsps.lsps[i].tlvs[j].is_reachability_tlvs[k]/extended_is_reachability_tlvs[k]`.
    - In gNMI response for `isis-routers/isis-router[name=*]/state/link-state-database/lsp-states/lsps[lsp-id=*][pdu-type=*]/tlvs/is-reachability|extended-is-reachability`.
* <b><i>Ixia-C & UHD400</i></b>: Issue is fixed where intermittent crash was seen for long duration rus with multiple tests when starting `BGP/BGP+` with back trace containing `"ix_set_ifindex, nsm_util_interface_address_add, bgp_nsm_recv_address"` keywords.

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
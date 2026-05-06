### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.53.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.53.0/artifacts/openapi.yaml)         |
| snappi                        | [1.53.0](https://pypi.org/project/snappi/1.53.0)        |
| gosnappi                      | [1.53.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.53.0)        |
| keng-controller               | [1.53.0-13](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.523](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.53.0-10](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.4.0](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.53.2](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.53.0-13](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |

### Notes:
* <b><i>featureprofiles</b></i>: Users needs to sync to latest `featureprofiles` when upgrading to `Release v1.53.0-13`, otherwise retrieval of OTG Port counters/state and BGP/BGP+ Peer state using gNMI might give incorrect results.
* <b><i>Deprecated IxOS Versions</b></i>: For Ixia Chassis & Appliances(Novus, AresOne) users,
    - IxOS versions earlier than `10.80.EA` are considered deprecated and will trigger a warning.
    - Upgrade to `10.80.EA` or later is strongly recommended.
    - Support for versions below `10.80.EA` will be discontinued in a future release (not before June 30, 2026)."


### Release Feature(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: gNMI support added for port `speed` in port metrics. This will contain the negotiated HW port speed in `KBps`.
    ```gNMI
        ports/port[name=*]/state/speed
    ```
    - Examples are given below.
        - 100 Gbps is 100 * 1000 * 1000 / 8 = 12500000 KBps,
        - 1.6 Tbps (high performance devices) is 1.6 * 1000 * 1000 * 1000 / 8 = 200000000 KBps,
        - 10 Mbps (legacy devices) is 10 * 1000 / 8 = 1250 KBps

* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne) & UHD400</i></b>: gNMI supported added for BGP/BGP+ MPLS unicast learned information.
    ```gNMI
        bgp-peers/bgp-peer[name=*]/ipv4-mpls-unicast-prefixes/ipv4-mpls-unicast-prefix[address=*][prefix-length=*][origin=*][path-id=*]/state/labels

        bgp-peers/bgp-peer[name=*]/ipv6-mpls-unicast-prefixes/ipv6-mpls-unicast-prefix[address=*][prefix-length=*][origin=*][path-id=*]/state/labels
    ```
    Note: Other attributes are exposed in the similar manner as for `unicast-ipv4/v6-prefixes`.
        

    
### Bug Fix(s):
* <b><i>Ixia-C</i></b>: Issue is fixed where increment/decrement was not working for the field `flows[i].packet[j].ipv4.time_to_live`.
* <b><i>Ixia-C</i></b>: Issue is fixed where increment/decrement was not working for the field `flows[i].packet[j].ipv4.priority.raw`.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where enabling OSPFv2 Traffic Engineering was resulting in `SetConfig` failure with `"Object reference not set to an instance of an object."` error.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where `GetStates` for `ipv4/v6_neighbors` was failing with `"Object reference not set to an instance of an object"` error if simulated interfaces were included in the configuration.

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
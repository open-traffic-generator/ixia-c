#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.17.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.17.0/artifacts/openapi.yaml)         |
| snappi                        | [1.17.0](https://pypi.org/project/snappi/1.17.0)        |
| gosnappi                      | [1.17.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.17.0)        |
| keng-controller               | [1.17.0-9](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.193](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.419](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.17.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.14.18](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.17.0-9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.1](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.1/artifacts.tar)         |


# Release Features(s)

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for BGP/BGP+ over ISIS Simulated Topology. [More Details](https://github.com/open-traffic-generator/models/pull/327)
  ```go
    loopback = simRtr.Ipv4Loopbacks().
                Add().
                SetName("IPv4Loopback").
                SetAddress(dutIPv4).
                SetEthName(simRtr.Ethernets().Items()[0].Name())
    simRtrBgp= simRtr.Bgp().
            SetRouterId(loopback.Address())
    simRtrBgpIntf = simRtrBgp.Ipv4Interfaces().Add().
            SetIpv4Name(loopback.Name())
    simRtrBgpIntf.Peers().Add().
            SetAsNumber(1111).
            SetAsType(gosnappi.BgpV4PeerAsType.EBGP).
            SetPeerAddress(fromPeerIp).
            SetName("BgpPeer1")
  ```
  Note: For configuration of simulated topology please refer [here](https://github.com/open-traffic-generator/ixia-c/releases/tag/v1.16.0-2).

* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for GRE header in traffic flows.
  ```go
    flow1 := config.Flows().Add()
    ...
    gre := flow1.Packet().Add().Gre()
    ...
  ```
  Note: By default the correct GRE Protocol value will be set automatically depending on next header eg. IPv4/v6.

	
### Bug Fix(s)
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where fetching ISIS learned information using `get_states` would sometimes fail with a error <i>Cannot clear data while transfer is in progress - data would be inconsistent</i>.

* <b><i>Ixia-C</i></b>: Issue is fixed where ARP/ND resolution was failing for LAG configurations with a mix of Loopback and connected interfaces.

* <b><i>Ixia-C</i></b>: Issue is fixed where on fetching BGP/BGP+ learned prefix information using `get_states` would return an incorrect prefix in certain scenarios. This was more likely to happen for IPv6 prefixes.

* <b><i>Ixia-C, UHD400</i></b>: Issue is fixed where if the DHCPv6 client type is configured as IANAPD, DHCPv6 Server `get_states` doesn't show IAPD addresses.

* <b><i>UHD400</i></b>: Issue is fixed where Auto MAC resolution was not working properly for multinic scenarios such as LAG, resulting in flows being transmitted with dest MAC as 00:00:00:00:00:00 and DUT not forwarding these packets.


#### Known Issues
* <b><i>Ixia-C, UHD400</i></b>: When DHCPv6 Server is configured with multiple pools, The DHCPv6 clients are not accepting addresses from different pools.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
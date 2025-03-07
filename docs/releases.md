# Ixia-c Release Notes and Version Compatibility

## Release  v1.24.0-4 (Latest)

> 7th March, 2025

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [1.24.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.24.0/artifacts/openapi.yaml) |
| snappi                     | [1.24.0](https://pypi.org/project/snappi/1.24.0)                                                                                              |
| gosnappi                   | [1.24.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.24.0)                                                        |
| keng-controller            | [1.24.0-4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                         |
| ixia-c-traffic-engine      | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                  |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.438](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [1.24.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.24.2](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                           |
| ixia-c-one                 | [1.24.0-4](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |
| UHD400                     | [1.5.3](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.3/artifacts.tar)                                    |

# Release Features(s):

* `<b><i>`Ixia-C & UHD400`</i></b>`: Support added for ISIS Simulated Topology. [More Details](https://github.com/open-traffic-generator/models/pull/327)

  - Configuration for ISIS attributes for newly introduced simulated routers are identical to configuration for currently supported directly connected emulated routers.
  - `devices[i].ethernets[j].connection.simulated_link` is introduced to create a simulated ethernet connection to build a Simulated Topology.

  ```go
    simulatedRouterEthernet := simulatedRouter.Ethernets().Add().
                SetName("simRtrEth").
                SetMac("00:00:11:02:02:02")
    simulatedRouterEthernet.Connection().SimulatedLink().SetRemoteSimulatedLink("connRtrSimEth")

    connectedRouterSimulatedEthernet := connectedRouter.Ethernets().Add().
                SetName("connRtrSimEth").
                SetMac("00:00:01:01:01:01")
    connectedRouterSimulatedEthernet.Connection().SimulatedLink().SetRemoteSimulatedLink("simRtrEth")
  ```

  - BGP/BGP+/RSVP-TE can also be configured on loopback interfaces on the simulated devices.
    Note: `get_metrics/states` APIs are only applicable for the connected emulated routers and not for the simulated routers.
* `<b><i>`Ixia-C & UHD400`</i></b>`: Support added for ISIS Segment Routing for emulated ISIS routers.

  - To configure Router Capability with Segment Routing in `devices[i].isis.segment_routing.router_capability` use the following snippet.

  ```go
      srCap := rtrCap.SrCapability()
      srCap.Flags().SetIpv4Mpls(true).SetIpv6Mpls(true)
      srCap.SrgbRanges().Add().SetStartingSid(uint32(srStartingSid)).SetRange(uint32(srRange))
  ```

  - To configure routes with Node-SID or Prefix-SID under `devices[i].isis.v4/6_routes[j].prefix_sids[0]` use the following snippet.

  ```go
      isisV4Route.PrefixSids().Add().
          SetSidIndex(sidOffset).
          SetRFlag(true).
          SetNFlag(true).
          SetPFlag(true).
          SetAlgorithm(1)
  ```

  - To configure Adjacency-SID under `devices[i].isis.interfaces[0].adjacency_sids[j]` use the following snippet.

  ```go
      isisInterface.AdjacencySids().Add().
          SetSidIndex(sidOffset).
          SetPFlag(true).
          SetWeight(10)
  ```

  - To configure traffic using Segment Routing MPLS Labels use the following snippet.

  ```go
      eth := flow.Packet().Add().Ethernet()
      eth.Src().SetValue(ethIntf.Mac())
      eth.Dst().Auto()
      mpls := flow.Packet().Add().Mpls()
      mpls.Label().SetValue(uint32(900010)) // Use the Segment Routing MPLS Label to which traffic has to be steered.
  ```

  Note: MPLS headers in flows is not yet supported for UHD400.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne), UHD400`</i></b>`: gNMI support added to retrieve timestamp of the last link state change event of the test port. [More Details](https://github.com/open-traffic-generator/models-yang/pull/40)

  ```gNMI
      ports/port[name=*]/state/last-change
  ```

### Bug Fix(s)

* `<b><i>`Ixia-C & UHD400`</i></b>`:  Issue is fixed where DHCPv6 was intermittently crashing on stop.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`UHD400`</i></b>`: Non default virtual wiring configuration can result in ARP failures and traffic loss due to dropped packets on the rx path.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.20.0-8

> 26th February, 2025

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [1.20.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.20.0/artifacts/openapi.yaml) |
| snappi                     | [1.20.0](https://pypi.org/project/snappi/1.20.0)                                                                                              |
| gosnappi                   | [1.20.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.20.0)                                                        |
| keng-controller            | [1.20.0-8](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                         |
| ixia-c-traffic-engine      | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                  |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.431](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [1.20.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.20.2](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                           |
| ixia-c-one                 | [1.20.0-8](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |
| UHD400                     | [1.5.3](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.3/artifacts.tar)                                    |

### Bug Fix(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue is fixed where on running a test with a large number of `replay_updates` multiple times would cause a PCPU out of memory crash, resulting in `<i>`"context deadline"`</i>` error on `set_config` or `set_control_state.protocol.start`.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`UHD400`</i></b>`: Non default virtual wiring configuration can result in ARP failures and traffic loss due to dropped packets on the rx path.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.20.0-6

> 11th February, 2025

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [1.20.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.20.0/artifacts/openapi.yaml) |
| snappi                     | [1.20.0](https://pypi.org/project/snappi/1.20.0)                                                                                              |
| gosnappi                   | [1.20.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.20.0)                                                        |
| keng-controller            | [1.20.0-6](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                         |
| ixia-c-traffic-engine      | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                  |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.431](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [1.20.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.20.2](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                           |
| ixia-c-one                 | [1.20.0-6](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |
| UHD400                     | [1.5.3](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.3/artifacts.tar)                                    |

# Release Features(s)

* `<b><i>`UHD400`</i></b>`: Support added to retrieve timestamp of the last link state change event of the test port. [More Details](https://github.com/open-traffic-generator/models/pull/398)
  - This can be retrieved by accessing `port_metrics[i].last_change`.

    Note:

    - Test ports and DUT must be time synced to the same time source if link state change timestamps need to be co-related.

### Bug Fix(s)

* `<b><i>`Ixia-C & UHD400`</i></b>`: For certain asymmetric configurations of BGPv4/v6 `replay_updates` with a large number of updates, `set_config` or `set_control_state.protocol.start` would result in the protocol-engine container to get stuck and ultimately result in `context_deadline_exceeded` error and subsequent actions to not return a response. This issue is fixed.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.19.0-18

> 24th January, 2025

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [1.19.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.19.0/artifacts/openapi.yaml) |
| snappi                     | [1.19.0](https://pypi.org/project/snappi/1.19.0)                                                                                              |
| gosnappi                   | [1.19.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.19.0)                                                        |
| keng-controller            | [1.19.0-18](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                        |
| ixia-c-traffic-engine      | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                  |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.426](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [1.19.0-9](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.19.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                           |
| ixia-c-one                 | [1.19.0-18](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                            |
| UHD400                     | [1.5.1](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.1/artifacts.tar)                                    |

# Release Features(s)

* `<b><i>`Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for GUEv1 IPv4/v6 over UDP traffic.

  ```go
      f1Ip1 := f1.Packet().Add().Ipv4()
      f1Ip1.Src().SetValue("1.1.1.1")
      f1Ip1.Dst().SetValue("1.1.1.2")
    
      f1Udp := f1.Packet().Add().Udp()
      f1Udp.SrcPort().SetValue(30000)
      f1Udp.DstPort().SetValue(6080)
      // IPv4 Over UDP
      f1Ip2 := f1.Packet().Add().Ipv4()
      f1Ip2.Src().SetValues([]string{
          "2.2.2.1",
          "2.2.2.2",
          "2.2.2.3",
          "2.2.2.4",
      })
      f1Ip2.Dst().SetValue("3.3.3.1")
  ```
* `<b><i>`Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for MPLS Over UDP traffic.

  ```go
      //udp Dst port as 6635
      f1Udp := f1.Packet().Add().Udp()
      f1Udp.DstPort().SetValue(6635)
      f1Udp.SrcPort().SetValue(65530)
      //mpls over udp
      f1Mpls1 := f1.Packet().Add().Mpls()
      f1Mpls1.Label().SetValue(10001)
      f1Mpls1.BottomOfStack().SetValue(0)
      f1Mpls2 := f1.Packet().Add().Mpls()
      f1Mpls2.Label().SetValue(10011)
      //ipv4 over mpls over udp
      f1MplsIp := f1.Packet().Add().Ipv4()
      f1MplsIp.Dst().SetValues([]string{
          "20.20.20.1",
          "20.20.20.2",
          "20.20.20.3",
          "20.20.20.4",
      })
      f1MplsIp.Src().SetValue("10.10.10.1")
  ```

  Note: MPLS Over UDP with DTLS is not supported.
* `<b><i>`Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Egress tracking is now supported for UDP, TCP(src/dst port fields), MPLS and IPv4/v6 inner header fields when encapsulated inside UDP/TCP.

  ```go
      //egress tracking
      f1.EgressPacket().Add().Ethernet()
      f1.EgressPacket().Add().Ipv4()
      f1.EgressPacket().Add().Udp()
      f1.EgressPacket().Add().Mpls()
      mplsLabelTracking := f1.EgressPacket().Add().Mpls()
      tr1 := mplsLabelTracking.Label().MetricTags().Add()
      tr1.SetName("MplsLabelEgressTracking")
      tr1.SetOffset(17)
      tr1.SetLength(3)
  ```

### Bug Fix(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue is fixed where configs with RSVP and multiple Loopback interfaces was throwing error similar to `"loopback p2.d2.lo and lo.d not compatible"` on `set_config`.
* `<b><i>`Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue where config with large number of route ranges was causing error similar to `"grpc: received message larger than max (114278270 vs. 104857600)"` on `set_config` is fixed by increasing the default gRPC receive buffer size to 1GB.
  - Note that for Ixia Chassis & Appliances(Novus, AresOne) the buffer can now be controlled by setting the environment variable of `keng-controller` as given below.
    ```sh
        command:
            ...
            - "--grpc-max-msg-size"
            - "500"
    ```
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue is fixed where `set_config` was throwing error if Traffic Engineering was enabled for ISIS interface, but Priority BandWidths were not explicitly specified.
* `<b><i>`Ixia-C, UHD400`</i></b>`: Issue is fixed where DHCPv4 was intermittently crashing on stop.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue is fixed where OSPFv2 Router Ids were not getting set properly when multiple OSPFv2 Routers were configured on a port.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.19.0-5

> 23rd December, 2024

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [1.19.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.19.0/artifacts/openapi.yaml) |
| snappi                     | [1.19.0](https://pypi.org/project/snappi/1.19.0)                                                                                              |
| gosnappi                   | [1.19.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.19.0)                                                        |
| keng-controller            | [1.19.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                         |
| ixia-c-traffic-engine      | [1.8.0.241](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                  |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.424](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [1.19.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.19.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                           |
| ixia-c-one                 | [1.19.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |
| UHD400                     | [1.5.1](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.1/artifacts.tar)                                    |

# Release Features(s)

* `<b><i>`Ixia-C`</i></b>`: Support added to send flows over DHCPv6 endpoints.

  ```go
    f1 := config.Flows().Add()
    f1.SetName(flowName).
      TxRx().Device().
      SetTxNames([]string{"p1d1dhcpv6_1"}).
      SetRxNames([]string{"p2d1ipv6"})
    f1Ip := f1.Packet().Add().Ipv6()
    // will be populated automatically with the the dynamically allocated Ip to DHCP client
    f1Ip.Src().Auto().Dhcp()
    …
    f2Ip.Dst().Auto().Dhcp()
  ```
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added to retrieve timestamp of the last link state change event of the test port. [More Details](https://github.com/open-traffic-generator/models/pull/398)

  - This can be retrieved by accessing `port_metrics[i].last_change`.

    Note:

    - As mentioned in the `Known Issues`, ports being used in the tests must be rebooted once after upgrading to the latest version of `keng-layer23-hw-server`.
    - Test ports and DUT must be time synced to the same time source if link state change timestamps need to be co-related.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for RSVP over ISIS Simulated Topology.

  ```go
    // Create RSVP neighbor on interface connected to DUT.
    // Note that get_states and get_metrics are supported only for the connected RSVP neighbors.
    p2RsvpNeighbor := p2d1.Rsvp().SetName("p2RsvpNbr")
    p2RsvpNeighbor.Ipv4Interfaces().
            Add().SetIpv4Name(p2d1Ipv4.Name()).
            SetNeighborIp(p2d1Ipv4.Gateway())

    // Create RSVP ingress LSPs on the loopback behind the simulated topology.
    fromLoRsvpIngress := fromLoRsvpLsp.P2PIngressIpv4Lsps().Add().SetName("ingressLsp")
    fromLoRsvpIngress.SetRemoteAddress("1.1.1.1").SetTunnelId(100)

    // Create RSVP egress endpoint on the loopback behind the simulated topology.
    toLoRsvpLsp := toLoRsvpPeer.LspIpv4Interfaces().Add().SetIpv4Name("loopback")
    toLoRsvpLspEgress := toLoRsvpLsp.P2PEgressIpv4Lsps().SetName("egressLsp")

    // Note: for TE SPF to work properly on DUT, ensure you have added TrafficEngineering to all ISIS interfaces.
    te = p2d1IsisIntf.TrafficEngineering().Add().SetMetricLevel(10)
    te.PriorityBandwidths().
            SetPb0(125000000).
            ...
            SetPb7(125000000)
  ```

### Bug Fix(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue is fixed where `set_config` was failing with the error `"BgpIPRouteRange is missing"` when IPv4 routes with IPv6 next-hops (RFC5549) was configured.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue is fixed where `get_states` on `bgpv4/6_prefixes` was returning error `"Error occurred while fetching bgp_prefix states:Length cannot be less than zero. (Parameter 'length')"` if the prefix contained `as_path` with multiple segments.
* `<b><i>`Ixia-C, UHD400`</i></b>`: Issue is fixed where `get_states` for `isis` was returning IPv6 prefixes in upper case causing prefix match for IPv6 prefixes to fail in tests.
* `<b><i>`Ixia-C`</i></b>`: Issue is fixed where `set_config` was failing with error `"Error occurred while setting Traffic config (Layer1 only) for user common:Error fetching stats for port port9: unsuccessful Response: Port 7 is not added"` when the traffic engine was deployed in multi nic mode (e.g. for lag setups with 8 ports).
* `<b><i>`Ixia-C`</i></b>`: Issue is fixed where the traffic engine was crashing on deployment using a single cpu core (`--cpuset-cpus="0-1"`).
* `<b><i>`VM Licensing`</i></b>`: Issue is fixed for users using the VM License Server where,  after a reboot, license-server VM serving multiple keng-controller(s) did not come up and tests running with those controller(s) started failing.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.17.0-9

> 29th November, 2024

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [1.17.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.17.0/artifacts/openapi.yaml) |
| snappi                     | [1.17.0](https://pypi.org/project/snappi/1.17.0)                                                                                              |
| gosnappi                   | [1.17.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.17.0)                                                        |
| keng-controller            | [1.17.0-9](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                         |
| ixia-c-traffic-engine      | [1.8.0.193](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                  |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.419](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [1.17.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.14.18](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                          |
| ixia-c-one                 | [1.17.0-9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |
| UHD400                     | [1.5.1](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.1/artifacts.tar)                                    |

# Release Features(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for BGP/BGP+ over ISIS Simulated Topology. [More Details](https://github.com/open-traffic-generator/models/pull/327)

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
* `<b><i>`Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for GRE header in traffic flows.

  ```go
    flow1 := config.Flows().Add()
    ...
    gre := flow1.Packet().Add().Gre()
    ...
  ```

  Note: By default the correct GRE Protocol value will be set automatically depending on next header eg. IPv4/v6.

### Bug Fix(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue is fixed where fetching ISIS learned information using `get_states` would sometimes fail with a error `<i>`Cannot clear data while transfer is in progress - data would be inconsistent`</i>`.
* `<b><i>`Ixia-C`</i></b>`: Issue is fixed where ARP/ND resolution was failing for LAG configurations with a mix of Loopback and connected interfaces.
* `<b><i>`Ixia-C`</i></b>`: Issue is fixed where on fetching BGP/BGP+ learned prefix information using `get_states` would return an incorrect prefix in certain scenarios. This was more likely to happen for IPv6 prefixes.
* `<b><i>`Ixia-C, UHD400`</i></b>`: Issue is fixed where if the DHCPv6 client type is configured as IANAPD, DHCPv6 Server `get_states` doesn't show IAPD addresses.
* `<b><i>`UHD400`</i></b>`: Issue is fixed where Auto MAC resolution was not working properly for multinic scenarios such as LAG, resulting in flows being transmitted with dest MAC as 00:00:00:00:00:00 and DUT not forwarding these packets.

#### Known Issues

* `<b><i>`Ixia-C, UHD400`</i></b>`: When DHCPv6 Server is configured with multiple pools, The DHCPv6 clients are not accepting addresses from different pools.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.16.0-2

> 18th November, 2024

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [1.16.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.16.0/artifacts/openapi.yaml) |
| snappi                     | [1.16.0](https://pypi.org/project/snappi/1.16.0)                                                                                              |
| gosnappi                   | [1.16.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.16.0)                                                        |
| keng-controller            | [1.16.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                         |
| ixia-c-traffic-engine      | [1.8.0.193](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                  |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.415](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [1.16.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.14.16](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                          |
| ixia-c-one                 | [1.16.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |
| UHD400                     | [1.5.1](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.1/artifacts.tar)                                    |

# Release Features(s)

* `<b><i>`Ixia-C, UHD400`</i></b>`: Support added for DHCPv6 Client and Server in control plane.

  - User will be the able to configure DHCPv6 Client and Server by the following code snippet.

  ```go
    // Configure a DHCP Client
      dhcpv6client := d1Eth1.Dhcpv6Interfaces().Add().
        SetName("p1d1dhcpv61")

      dhcpv6client.IaType().Iata()
      dhcpv6client.DuidType().Llt()

      // Configure a DHCPv6 Server
      d1Dhcpv6Server := d2.DhcpServer().Ipv6Interfaces().Add().
        SetName("p2d1Dhcpv6Server1").

      d1Dhcpv6ServerPool := d1Dhcpv6Server.SetIpv6Name("p2d1ipv6").
        Leases().Add().
        SetLeaseTime(3600)
      IaType := d1Dhcpv6ServerPool.IaType().Iata()
      IaType.
        SetStartAddress("2000:0:0:1::100").
        SetStep(1).
        SetSize(10).
        SetPrefixLen(64) 
  ```
* `<b><i>`UHD400`</i></b>`: Support of Egress Flow tracking for multiple flows is added any location of supported fields upto 10 bits.

  - Supported fields are `ethernet.src/dst`, `vlan.id`, `vlan.priority`, `ipv4.src/dst`, `ipv4.precedence`, `ipv6.src/dst`, `ipv6.traffic_class`.

  ```go
    eth := flow.EgressPacket().Add().Ethernet()
    ipv4 := flow.EgressPacket().Add().Ipv4()
    ipv4Tag := ipv4.Dst().MetricTags().Add()
    ipv4Tag.SetName("flow_ipv4_dst")
    ipv4Tag.SetOffset(22)
    ipv4Tag.SetLength(10)
  ```
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for ISIS Simulated Topology. [More Details](https://github.com/open-traffic-generator/models/pull/327)

  - Configuration for ISIS attributes for newly introduced simulated routers are identical to configuration for currently supported directly connected emulated routers.
  - `devices[i].ethernets[j].connection.simulated_link` is introduced to create a simulated ethernet connection to build a Simulated Topology.

  ```go
    simulatedRouterEthernet := simulatedRouter.Ethernets().Add().
                SetName("simRtrEth").
                SetMac("00:00:11:02:02:02")
    simulatedRouterEthernet.Connection().SimulatedLink().SetRemoteSimulatedLink("connRtrSimEth")

    connectedRouterSimulatedEthernet := connectedRouter.Ethernets().Add().
                SetName("connRtrSimEth").
                SetMac("00:00:01:01:01:01")
    connectedRouterSimulatedEthernet.Connection().SimulatedLink().SetRemoteSimulatedLink("simRtrEth")
  ```

  Note: `get_metrics/states` APIs are only applicable for the connected emulated routers and not for the simulated routers.
* `<b><i>`Ixia-C, UHD400, Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for fetching `lldp_neighbors[i].custom_tlvs[j].information` as hex bytes using `get_states` API. [More details](https://github.com/open-traffic-generator/models/pull/392)

### Bug Fix(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue is fixed where for certain scenarios such as retrieving large control capture buffer or fetching `get_metrics/states` for large amount of data results in errors similar to `<i>`"grpc: received message larger than max (7934807 vs. 4194304)"`</i>`.

  - For such scenarios note that the grpc receive buffer on the client should also be locally increased if necessary from default value of 4 MB.
* `<b><i>`Ixia-C`</i></b>`: Issue is fixed for LLDP where, when multiple custom tlvs are configured to be sent, sometimes the bytes in the `information` field in the outgoing LLDP PDUs were corrupted.

#### Known Issues

* `<b><i>`Ixia-C, UHD400`</i></b>`: When the DHCPv6 client type is configured as IANAPD, DHCPv6 Server `get_states` doesn't show IAPD addresses
* `<b><i>`Ixia-C, UHD400`</i></b>`: When DHCPv6 Server is configured with multiple pools, The DHCPv6 clients are not accepting addresses from different pools.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.14.0-1

> 25th October, 2024

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [1.14.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.14.0/artifacts/openapi.yaml) |
| snappi                     | [1.14.0](https://pypi.org/project/snappi/1.14.0)                                                                                              |
| gosnappi                   | [1.14.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.14.0)                                                        |
| keng-controller            | [1.14.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                         |
| ixia-c-traffic-engine      | [1.8.0.99](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.405](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [1.14.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.14.15](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                          |
| ixia-c-one                 | [1.14.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |
| UHD400                     | [1.4.0](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.4/1.4.0/artifacts.tar)                                    |

# Release Features(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for OSPFv2. [details](https://github.com/open-traffic-generator/models/pull/384)

  ```go
    ospfRouter := device1.Ospfv2().
            SetName("OspfRtr").
            SetStoreLsa(true)

    intf := ospfRouter.Interfaces().Add().
                    SetName("OspfIntf").
                    SetIpv4Name("Ipv4Intf1")

    intf.Area().SetId(0)
    intf.NetworkType().PointToPoint()
    ospfRoutes := ospfRouter.V4Routes().
                            Add().
                            SetName("OspfRoutes")
    ospfRoutes.
            Addresses().
            Add().
            SetAddress("10.10.10.0").
            SetPrefix(24).
            SetCount(100).
            SetStep(2)
  ```

  - Learned LSAs can be fetched by the following

  ```go
    req := gosnappi.NewStatesRequest()
    req.Ospfv2Lsas().SetRouterNames(routerNames)
    res, err := client.GetStates(req)
  ```

  - OSPFv2 metrics can be fetched by the following

  ```go
    req := gosnappi.NewMetricsRequest()
    reqOspf := req.Ospfv2()
    reqOspf.SetRouterNames(routerNames)
  ```
* `<b><i>`Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added to update `flows[i].size` and `flows[i].rate` on the fly.

  ```go
    
    flow = get_config.Flows().Items()[0]
    flow.Rate().SetPps(120)
    flow.Size().SetFixed(512)

    flowUpdateCfg: = gosnappi.NewConfigUpdate().Flows()
    flowUpdateCfg.Flows().Append(flow)
    flowUpdateCfg.SetPropertyNames ([]gosnappi.FlowsUpdatePropertyNamesEnum{
      gosnappi.FlowsUpdatePropertyNames.SIZE, gosnappi.FlowsUpdatePropertyNames.RATE
    })

    configUpdate = gosnappi.NewConfigUpdate()
    configUpdate.SetFlows(flowUpdateCfg)
    res, err := client.Api().UpdateConfig(configUpdate)
  ```

### Bug Fix(s)

* `<b><i>`Ixia-C`</i></b>`: Issue where flows containing `ipv4/v6` header without `src/dst` specified was returning error on `set_config` `<i>`"Error flow [ flow-name ] has AUTO IPv4 src address and Tx device [ flow-end-point ] with no dhcpv4 interface"`</i>` is fixed.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.13.0-9

> 4th October, 2024

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [1.13.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.13.0/artifacts/openapi.yaml) |
| snappi                     | [1.13.0](https://pypi.org/project/snappi/1.13.0)                                                                                              |
| gosnappi                   | [1.13.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.13.0)                                                        |
| keng-controller            | [1.13.0-9](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                         |
| ixia-c-traffic-engine      | [1.8.0.90](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.404](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [1.13.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.14.14](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                          |
| ixia-c-one                 | [1.13.0-9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |
| UHD400                     | [1.4.0](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.4/1.4.0/artifacts.tar)                                    |

# Release Features(s)

* `<b><i>`Keng-Operator`</i></b>`: go version is upgraded to use `v1.23` along with security updates.
* `<b><i>`Ixia-C`</i></b>`: Support added to send flows over DHCPv4 endpoints.

  ```go
    f1 := config.Flows().Add()
    f1.SetName(flowName).
      TxRx().Device().
      SetTxNames([]string{"p1d1dhcpv4_1"}).
      SetRxNames([]string{"p2d1ipv4"})
    f1Ip := f1.Packet().Add().Ipv4()
    // will be populated automatically with the the dynamically allocated Ip to DHCP client
    f1Ip.Src().Auto().Dhcp()
    …
    f2Ip.Dst().Auto().Dhcp()
  ```
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for LLDP.

  ```go
    // LLDP configuration.
    lldp := config.Lldp().Add()
    lldp.SystemName().SetValue(lldpSrc.systemName)
    lldp.SetName(lldpSrc.otgName)
    lldp.Connection().SetPortName(portName)
    lldp.ChassisId().MacAddressSubtype().
      SetValue(lldpSrc.macAddress)
  ```

### Bug Fix(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: There was degradation in time taken for starting large number of  BGP/BGP+ peers on one port. This issue is fixed.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: There was an exception being returned from `set_config` on creating multiple loopbacks in a device and configuring protocols on top of that. This issue is fixed.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If multiple routes are received by a BGP/BGP+ peer with some having MED/Local Preference and some not having MED/Local Preference, in `get_states` MED/Local Preference were not being correctly returned. This issue is fixed.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.13.0-1

> 17th September, 2024

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [1.13.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.13.0/artifacts/openapi.yaml) |
| snappi                     | [1.13.0](https://pypi.org/project/snappi/1.13.0)                                                                                              |
| gosnappi                   | [1.13.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.13.0)                                                        |
| keng-controller            | [1.13.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                         |
| ixia-c-traffic-engine      | [1.8.0.25](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.399](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [1.13.0-3](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.30](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.14.14](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                          |
| ixia-c-one                 | [1.13.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |
| UHD400                     | [1.4.0](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.4/1.4.0/artifacts.tar)                                    |

# Release Features(s)

* `<b><i>`gosnappi`</i></b>`: `gosnappi` is updated to work with `go` >= `v1.21`.

  - Older versions of `go` are no longer supported.
    - When older version of `go` is installed on the server, User will be liable to get errors like `"slices: package slices is not in GOROOT (/root/.local/go/src/slices)"`.

  Note: `keng-controller` and `otg-gnmi-server` are upgraded to use `go` `v1.23`.
* `<b><i>`Ixia-C, Ixia Chassis & Appliances(Novus, AresOne), UHD400`</i></b>`: Support added for BGP GracefulRestart Notification Enhancement based on [RFC8538](https://datatracker.ietf.org/doc/html/rfc8538).

  - To enable advertisement of Notification support in GracefulRestart capability:

  ```go
      peer.GracefulRestart().SetEnableNotification(true)
  ```

  - To optionally send Notification when peer is going down during `InitiateGracefulRestart` trigger:

  ```go
      grAction := gosnappi.NewControlAction()
      bgpPeersRestart := grAction.Protocol().Bgp().InitiateGracefulRestart()
      bgpPeersRestart.
          SetPeerNames([]string{"peer1"}).
          SetRestartDelay(20)
      notification:= bgpPeersRestart.Notification()
      if sendHardReset == true {            
        notification.Cease().SetSubcode(
          gosnappi.DeviceBgpCeaseErrorSubcode.HARD_RESET_CODE6_SUBCODE9)
      } 
      else {
        /* Send anything else except hard reset */ 
        notification.Cease().SetSubcode(
            gosnappi.DeviceBgpCeaseErrorSubcode.OUT_OF_RESOURCES_CODE6_SUBCODE8)
      }
  ```
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added to update traffic rate on the fly.

  ```go
    req := gosnappi.NewConfigUpdate()
    reqFlow := req.Flows().SetPropertyNames([]gosnappi.FlowsUpdatePropertyNamesEnum{
      gosnappi.FlowsUpdatePropertyNames.RATE,
    })
    f1.Rate().SetPps(100) // f1 is an existing flow in the config
    reqFlow.Flows().Append(f1)
      gosnappi.NewApi().UpdateConfig(req)
  ```

### Bug Fix(s)

* `<b><i>`UHD400`</i></b>`: Issue where `flows[i].packet.ipv6.dst.increment` was not being reflected in transmitted packets when two or more flows were configured, is now fixed.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.12.0-1

> 2nd September, 2024

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [1.12.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.12.0/artifacts/openapi.yaml) |
| snappi                     | [1.12.0](https://pypi.org/project/snappi/1.12.0)                                                                                              |
| gosnappi                   | [1.12.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.12.0)                                                        |
| keng-controller            | [1.12.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                         |
| ixia-c-traffic-engine      | [1.8.0.25](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.398](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [1.12.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.30](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.14.12](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                          |
| ixia-c-one                 | [1.12.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |
| UHD400                     | [1.3.5](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.3/1.3.5/artifacts.tar)                                    |

# Release Features(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for DHCPv6 client interfaces to be used as source/destination for device traffic.

  - In this the learned IPv6 address from the DHCPv6 server is automatically populated in `ipv6.src/dst` if the choice is set to auto.dhcp.

  ```go
    clientToServerFlow.SetName("ClientToServer").TxRx().Device().
    SetTxNames([]string{"DHCPv6ClientName"}).
    SetRxNames([]string{"DHCPv6ServerInterfaceName"})
    clientToServerFlow.Packet().Add().Ethernet()
    clientToServerFlowIp := clientToServerFlow.Packet().Add().Ipv6()
    clientToServerFlowIp.Src().Auto().Dhcp()

    serverToClientFlow.SetName("ServerToClient").TxRx().Device().
        SetTxNames([]string{"DHCPv6ServerInterfaceName"}).
        SetRxNames([]string{"DHCPv6ClientName"})
    serverToClientFlow.Packet().Add().Ethernet()
    serverToClientFlowIp := serverToClientFlow.Packet().Add().Ipv6()
    serverToClientFlowIp.Dst().Auto().Dhcp()
  ```

  Note: For DHCPv6 client to DHCPv6 server each flow supports only one source endpoint in tx_rx.device.tx_names, hence a separate flow has to be configured for each DHCPv6 client if packet[i].ipv6.src.auto.dhcp is set.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for `devices[i].ethernets[j].dhcpv6_interfaces[k].options/options_request` and `devices[i].dhcp_server.ipv6_interfaces[j].options`.

  ```go
        // Configure a DHCPv6 Client
        dhcpv6Client := d1Eth1.Dhcpv6Interfaces().Add().
          SetName("DHCPv6-Client")

        .........

        //options
        dhcpv6Client.Options().VendorInfo().
          SetEnterpriseNumber(1000).
          OptionData().
          Add().
          SetCode(88).
          SetData("enterprise")
        dhcpv6Client.Options().VendorInfo().AssociatedDhcpMessages().All()

        //option request
        dhcpv6Client.OptionsRequest().Request().Add().BootfileUrl()
        dhcpv6Client.OptionsRequest().Request().Add().Custom().SetType(3)
        dhcpv6Client.OptionsRequest().AssociatedDhcpMessages().All()

        // Configure a DHCPv6 Server
        dhcpv6Server := d2.DhcpServer().Ipv6Interfaces().Add().
          SetName("DHCPv6-Server")

        ............
        dhcpv6Server.Options().BootfileUrl().SetUrl("URL").AssociatedDhcpMessages().All()
          dhcpv6Server.Options().Dns().SetPrimary("8::8").SecondaryDns().Add().SetIp("9::9")
  ```
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for `devices[i].dhcp_server.ipv6_interfaces[j].leases[k].ia_type.choice.iapd/ianapd`.

  ```go
        // Configure a DHCPv6 Server
        dhcpv6Server := d2.DhcpServer().Ipv6Interfaces().Add().
          SetName("DHCPv6-Server")

        dhcpv6ServerPool := dhcpv6Server.SetIpv6Name("p2d1ipv6").
          Leases().Add().
          SetLeaseTime(3600)
        IaType := dhcpv6ServerPool.IaType().Iapd()
        IaType.
          SetAdvertisedPrefixLen(64).
          SetStartPrefixAddress("2000:0:0:100::0").
          SetPrefixStep(1).
          SetPrefixSize(10)
  ```
* `<b><i>`Ixia-c`</i></b>`: Support added for sending Organizational tlvs in LLDP PDUs.

  ```go
    lldp := config.Lldp().Items()[0]

    orgInfos1 := lldp.OrgInfos().Add()
    orgInfos1.Information().SetInfo("AABB11")
    orgInfos1.SetOui("1abcdf").SetSubtype(1)
  ```

  Note: Received Organizational tlvs can be seen in the `get_states` response of `lldp_neighbors`.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.8.0-1

> 20th August, 2024

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [1.8.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.8.0/artifacts/openapi.yaml) |
| snappi                     | [1.8.0](https://pypi.org/project/snappi/1.8.0)                                                                                              |
| gosnappi                   | [1.8.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.8.0)                                                        |
| keng-controller            | [1.8.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                        |
| ixia-c-traffic-engine      | [1.8.0.25](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                 |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.393](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                              |
| keng-layer23-hw-server     | [1.8.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                 |
| keng-operator              | [0.3.30](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                           |
| otg-gnmi-server            | [1.14.8](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                         |
| ixia-c-one                 | [1.8.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                            |
| UHD400                     | [1.3.5](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.3/1.3.5/artifacts.tar)                                  |

# Release Features(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for DHCPv6 Client and Server in control plane. [details](https://github.com/open-traffic-generator/models/pull/369)

  - User will be the able to configure DHCPv6 Client and Server by the following code snippet.

  ```go
        // Configure a DHCP Client
        dhcpv6client := d1Eth1.Dhcpv6Interfaces().Add().
          SetName("p1d1dhcpv61")

        dhcpv6client.IaType().Iata()
        dhcpv6client.DuidType().Llt()

        // Configure a DHCPv6 Server
        d1Dhcpv6Server := d2.DhcpServer().Ipv6Interfaces().Add().
          SetName("p2d1Dhcpv6Server1").

        d1Dhcpv6ServerPool := d1Dhcpv6Server.SetIpv6Name("p2d1ipv6").
          Leases().Add().
          SetLeaseTime(3600)
        IaType := d1Dhcpv6ServerPool.IaType().Iata()
        IaType.
          SetStartAddress("2000:0:0:1::100").
          SetStep(1).
          SetSize(10).
          SetPrefixLen(64) 
  ```

  Note: Support for `devices[i].dhcp_server.ipv6_interfaces[j].options` and `devices[i].dhcp_server.ipv6_interfaces[j].leases[k].ia_type.choice.iapd/ianapd` will be available in the subsequent sprints.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: gNMI support added to fetch control plane metics and states of DHCPv6 [Client](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-dhcpv6client.txt) and [Server](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-dhcpv6server.txt).

  - Support added for DHCPv6 Client/Server metrics using following gNMI paths.

  ```gNMI
   // dhcpv6 client
   dhcpv6-clients/dhcpv6-client[name=*]/state/counters

   // dhcpv6 server
   dhcpv6-servers/dhcpv6-server[name=*]/state/counters
  ```

  - Support added for DHCPv6 Client/Server states using following gNMI paths.

  ```gNMI
   // dhcpv6 client
   dhcpv6-clients/dhcpv6-client[name=*]/state/interface

   // dhcpv6 server
   dhcpv6-servers/dhcpv6-server[name=*]/state/interface
  ```

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.7.2-1

> 7th August, 2024

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [1.7.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.7.1/artifacts/openapi.yaml) |
| snappi                     | [1.7.2](https://pypi.org/project/snappi/1.7.2)                                                                                              |
| gosnappi                   | [1.7.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.7.2)                                                        |
| keng-controller            | [1.7.2-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                        |
| ixia-c-traffic-engine      | [1.8.0.25](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                 |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.392](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                              |
| keng-layer23-hw-server     | [1.7.1-4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                 |
| keng-operator              | [0.3.30](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                           |
| otg-gnmi-server            | [1.14.7](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                         |
| ixia-c-one                 | [1.7.2-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                            |
| UHD400                     | [1.3.5](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.3/1.3.5/artifacts.tar)                                  |

# Release Features(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for new traffic applying infrastructure.

  - Instead of `<b><i>`"Failed to apply flow configurations due to: Please contact Ixia Support."`</i></b>` ,
    - In scenarios where underlying hardware module doesn't have the resources to apply the flow a proper error message such as `<b><i>`"Failed to apply flow configurations due to: Error  occurred for flow 'ipv6flowlabel': The Tx Ports of the flow do not support the combinations of fields and size of value lists configured. Please reduce the size of the value lists or/and fields with value lists configured or use a load module ( or variant) with more resources."`</i></b>` Based on this either test can be modified or appropriate load modules can be used for the test.
    - There were certain scenarios with large `values` in packet fields in the flows which were failing with above error inspite of being within the modules capabilities and can now be applied without any error.
  - Earlier configuration with multiples flows with large `values` in packet fields would fail with error as `<b><i>`"Failed to apply flow configurations due to: Traffic configuration exceeds port background memory size."`</i></b>`. This issue is also fixed with the upgrade to new traffic applying infrastructure.
  - Issue where  correct `values`/`increment`/`decrement` for `ethernet.src/dst` was not being transmitted on the wire is fixed.
  - In this new infrastructure, traffic will be directly applied to the hardware ports resulting in better performance on `set_transmit_state`.
* `<b><i>`gosnappi`</i></b>`: Client side file organization of the `gosnappi` sdk is modified to allow for better auto-completion support when writing test programs.
  Note: Client must be upgraded to gosnappi [v1.7.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.7.2).
* `<b><i>`Ixia-C, UHD400`</i></b>`: Support added for DHCPv4 Client and Server in control plane. [details](https://github.com/open-traffic-generator/models/pull/371)

  - User will be the able to configure DHCPv4 Client and Server by the following code snippet. More comprehensive [B2B example](https://github.com/open-traffic-generator/featureprofiles/blob/dev-dhcp/feature/dhcp/dhcpv4_client_server_b2b_test.go)

  ```go
    // Configure a DHCP Client
    dhcpclient := d1Eth1.Dhcpv4Interfaces().Add().
        SetName("p1d1dhcpv41")

    dhcpclient.FirstServer()
    dhcpclient.ParametersRequestList().
        SetSubnetMask(true).
        SetRouter(true).
        SetRenewalTimer(true)

  // Configure a DHCP Server
    d2Dhcpv4Server := d2.DhcpServer().Ipv4Interfaces().Add().
        SetName("p2d1dhcpv4server")

    d2Dhcpv4Server.SetIpv4Name("p2d1ipv4").AddressPools().
        Add().SetName("pool1").
        SetLeaseTime(3600).
        SetStartAddress("100.1.100.1").
        SetStep(1).
        SetCount(1).
        SetPrefixLength(16).Options().SetRouterAddress("100.1.0.1").SetEchoRelayWithTlv82(true)
  ```
* `<b><i>`Ixia-C, Ixia Chassis & Appliances(Novus, AresOne), UHD400`</i></b>`: Support added for `random` in following flow fields. [details](https://github.com/open-traffic-generator/models/pull/380)

  - `ipv4.src/dst`
  - `ipv6.flow_label`
  - `tcp.src_port/dst_port`
  - `udp.src_port/dst_port`

    - User can configure by using following snippet.
      ```go
        ipv6 := flow1.Packet().Add().Ipv6()
        ipv6.FlowLabel().Random().SetMin(1).SetMax(1048574).SetCount(250000).SetSeed(1)
      ```

    Note: For `<b><i>`UHD400`</i></b>` an intermittent issue is present on using `random`, where `rx` fields of `flow_metrics` can return zero values.
* `<b><i>`Ixia-C`</i></b>`: New environment variable `OPT_ADAPTIVE_CPU_USAGE=""` is introduced for docker based ixia-c-traffic-engine setups which enables adaptive CPU usage on the `rx` port for a flow. By default a non adaptive receiver is used when the `rx` CPU core usage reaches up to 100%. The adaptive receiver reduces `rx` CPU core usage from 100% to less than 5% in idle mode. To disable the adaptive receiver please remove this environment variable from docker run command. It is recommended to also pin the `rx` to specific cpu cores using the `ARG_CORE_LIST` environment variable when enabling `OPT_ADAPTIVE_CPU_USAGE`.

  - Example docker usage:

  ```yml
    docker run --net=host --privileged --rm -d \
      -e OPT_LISTEN_PORT="5555" \
      -e ARG_CORE_LIST="1 2 3" \
      -e ARG_IFACE_LIST="virtual@af_packet,enp7s0" \
      -e OPT_NO_HUGEPAGES="Yes" \
      -e OPT_ADAPTIVE_CPU_USAGE="" \
      --name ixia-c-traffic-engine \
      ixia-c-traffic-engine:1.8.0.25
  ```

### Bug Fix(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue where `flow_metrics` were not being returned within timeout resulting in `<b><i>`"Could not send message, error: unexpected queue Get(1) error: queue: disposed" and "Stats may be inconsistent"`</i></b>` error is fixed.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue where BGP/BGP+ learned information containing `origin` of type `incomplete` was not being returned properly by `get_states` is fixed. This would result in deserialization error while accessing BGP/BGP+ learned information using `otg-gNMI-server`.
* `<b><i>`Ixia Chassis & Appliances(AresOne)`</i></b>`: Issue where `port_metrics` were not available when load module of type `1 x 400G AresOne-M` with transceiver of type `800GE LAN QSFP-DD` was being used, is fixed.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue where `set_control_state.protocol.route.state=withdraw/advertise` is triggered with an empty `names` field, all configured route ranges were being not withdrawn or advertised, is fixed.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue where on `set_control_state.protocol.all.state=start`, a `l1` `up/down` event was triggered even when `l1` state was already `up`, is now fixed.

  Note: If port is in `down` state, it has to be brought back to `up` state before starting a test.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4 clients receive the leased IPv4 addresses from the DHCPv4 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.6.2-13

> 19th July, 2024

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [1.6.2](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.6.2/artifacts/openapi.yaml) |
| snappi                     | [1.6.2](https://pypi.org/project/snappi/1.6.2)                                                                                              |
| gosnappi                   | [1.6.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.6.2)                                                        |
| keng-controller            | [1.6.2-13](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                       |
| ixia-c-traffic-engine      | [1.8.0.12](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                 |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.390](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                              |
| keng-layer23-hw-server     | [1.6.2-4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                 |
| keng-operator              | [0.3.30](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                           |
| otg-gnmi-server            | [1.14.6](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                         |
| ixia-c-one                 | [1.6.2-13](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |
| UHD400                     | [1.3.3](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.3/1.3.3/artifacts.tar)                                  |

# Release Features(s)

* `<b><i>`Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: gNMI support added for `first-timestamp` and `last-timestamp` in flow metrics. [details](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-flow.txt)

  - User needs to set `flows[i].metrics.timestamps=true` to fetch these new fields.

  ```gNMI
    module: open-traffic-generator-flow
    +--rw flows
      +--ro flow* [name]
        +--ro name              -> ../state/name
        +--ro state
          |  +--ro name?              string
          .........
          |  +--ro first-timestamp?   decimal64
          |  +--ro last-timestamp?    decimal64
  ```

### Bug Fix(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue where `devices[i].rsvp.ipv4_interfaces[j].summary_refresh_interval` was not setting correctly, is fixed.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue where destination mac address was not getting resolved properly for traffic over ISIS IPv6 routes, is fixed.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4 clients receive the leased IPv4 addresses from the DHCPv4 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.6.2-1

> 28th June, 2024

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [1.6.2](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.6.2/artifacts/openapi.yaml) |
| snappi                     | [1.6.2](https://pypi.org/project/snappi/1.6.2)                                                                                              |
| gosnappi                   | [1.6.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.6.2)                                                        |
| keng-controller            | [1.6.2-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                        |
| ixia-c-traffic-engine      | [1.8.0.12](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                 |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.390](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                              |
| keng-layer23-hw-server     | [1.6.2-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                 |
| keng-operator              | [0.3.30](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                           |
| otg-gnmi-server            | [1.14.4](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                         |
| ixia-c-one                 | [1.6.2-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                            |
| UHD400                     | [1.3.3](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.3/1.3.3/artifacts.tar)                                  |

# Release Features(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for DHCPv4 client interfaces to be used as source/destination for device traffic.

  - In this the learned IPv4 address from the DHCPv4 server is automatically populated in `ipv4.src/dst` if the choice is set to `auto.dhcp`.

  ```go
    clientToServerFlow.SetName("ClientToServer").TxRx().Device().
    SetTxNames([]string{"DHCPv4ClientName"}).
    SetRxNames([]string{"DHCPv4ServerInterfaceName"})
    clientToServerFlowIp := clientToServerFlow.Packet().Add().Ipv4()
    clientToServerFlowIp.Src().Auto().Dhcp()

    serverToClientFlow.SetName("ServerToClient").TxRx().Device().
        SetTxNames([]string{"DHCPv4ServerInterfaceName"}).
        SetRxNames([]string{"DHCPv4ClientName"})
    serverToClientFlowIp := serverToClientFlow.Packet().Add().Ipv4()
    serverToClientFlowIp.Dst().Auto().Dhcp()
  ```

  Note: For DHCPv4 client to DHCPv4 server each flow supports only one source endpoint in `tx_rx.device.tx_names`, hence a separate flow has to be configured for each DHCPv4 client if `packet[i].ipv4.src.auto.dhcp` is set.
* `<b><i>`Ixia-C`</i></b>`: Support added for multiple address groups in BGPv4/v6 routes.

  ```go
    route = peer.V4Routes().Add().
      SetNextHopIpv4Address("2.2.2.2").
      SetName("peer1.rr1")

    route.Addresses().Add().
      SetAddress("20.20.20.1").SetPrefix(32).SetCount(2).SetStep(2)

    route.Addresses().Add().
      SetAddress("20.20.21.1").SetPrefix(32).SetCount(2).SetStep(2)
  ```

### Bug Fix(s)

* `<b><i>`Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue where if a BGPv4/v6 prefix with extended-community or community attributes was updated via a BGP Update with the extended-community or community attribute deleted without a Route Withdraw in between , the subsequent get_states call on the bgp prefixes would incorrectly continue to show the extended-community or community attributes learned via the previous received Update is fixed.
* `<b><i>`Ixia-C`</i></b>`: Issue where If a test was setup such that only test port would initiate ARP/ND and time taken to configure the soft-DUT connected to the test port was taking extended time such that it would not respond to ARP/ND requests within 10s, ARP/ND procedures would fail resulting in test failures in ARP/ND verification step is fixed.
* `<b><i>`Ixia-C`</i></b>`: Issue where if a IPv6 address on the emulated interface was configured in non-shortest format e.g.  `2001:0db8::192:0:2:2` instead of `2001:db8::192:0:2:2` (notice the redundant leading 0 in :0db8), the test port would not initiate IPv6 Neighbor Discovery for corresponding IPv6 gateway result in Neighbor Discovery failure is fixed.
* `<b><i>`Keng-Operator`</i></b>`: Some fixes are provided to handle security warnings raised by k8s security scanning tool such as `<i>'container "manager" in Deployment "ixiatg-op-controller-manager" does not set readOnlyRootFilesystem: true in its securityContext. This setting is encouraged because it can prevent attackers from writing malicious binaries into runnable locations in the container filesystem.'``</i>`.
* `<b><i>`UHD400`</i></b>`: Issue is fixed where `frames_rx` is reported twice of `frames_tx` in `flow_metrics` is fixed.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4 clients receive the leased IPv4 addresses from the DHCPv4 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.5.1-12

> 14th June, 2024

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [1.5.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.5.1/artifacts/openapi.yaml) |
| snappi                     | [1.5.1](https://pypi.org/project/snappi/1.5.1)                                                                                              |
| gosnappi                   | [1.5.1](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.5.1)                                                        |
| keng-controller            | [1.5.1-12](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                       |
| ixia-c-traffic-engine      | [1.8.0.12](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                 |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.383](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                              |
| keng-layer23-hw-server     | [1.5.1-6](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                 |
| keng-operator              | [0.3.29](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                           |
| otg-gnmi-server            | [1.14.2](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                         |
| ixia-c-one                 | [1.5.1-12](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |
| UHD400                     | [1.2.9](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.2/1.2.9/artifacts.tar)                                  |

# Release Features(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: gNMI support for `GetStates` of DHCP Server added.

  - [DHCPv4 Server](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-dhcpv4server.txt)

  ```gNMI
    # States information
    dhcpv4-servers/dhcpv4-servers[name=serverName]/state/leases
  ```
* `<b><i>`UHD400`</i></b>`: Value-list support added for IPv4 `dscp` field.

  ```go
    flowEth := flow.Packet().Add().Ethernet()
    .... 
    ipv4 := flow.Packet().Add().ipv4()
      ipv4.Src().SetValue(srcAddr)
      ipv4.Dst().SetValue(dstAddr)
      ipv4.Priority().Dscp().Phb().SetValues([]uint32{10,12,14,18 ...})
  ```

### Bug Fix(s)

* `<b><i>`Ixia-C`</i></b>`: Issue where withdrawing BGP/BGP+ routes using `set_control_state.protocol.route.withdraw` was failing in multi-nic topology is fixed.
* `<b><i>`Ixia Chassis & Appliances(AresOne)`</i></b>`: Issue where after running BGP/BGP+ tests on multi-nic ports would result intermittently in `context deadline` errors for subsequent tests/sub tests is fixed.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue where after running tests involving continuous connect/reconnect of test ports for long duration (e.g. 2 - 3 hrs) would result in intermittent `context deadline` errors for a bunch of consecutive tests is fixed.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4 clients receive the leased IPv4 addresses from the DHCPv4 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.5.1-3

> 1st June, 2024

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [1.5.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.5.1/artifacts/openapi.yaml) |
| snappi                     | [1.5.1](https://pypi.org/project/snappi/1.5.1)                                                                                              |
| gosnappi                   | [1.5.1](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.5.1)                                                        |
| keng-controller            | [1.5.1-3](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                        |
| ixia-c-traffic-engine      | [1.8.0.12](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                 |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.383](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                              |
| keng-layer23-hw-server     | [1.5.1-4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                 |
| keng-operator              | [0.3.29](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                           |
| otg-gnmi-server            | [1.14.2](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                         |
| ixia-c-one                 | [1.5.1-3](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                            |
| UHD400                     | [1.2.8](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.2/1.2.8/artifacts.tar)                                  |

# Release Features(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for DHCPv4 Client and Server in control plane. [details](https://github.com/open-traffic-generator/models/pull/371)

  - User will be the able to configure DHCPv4 Client and Server by the following code snippet. More comprehensive [B2B example](https://github.com/open-traffic-generator/featureprofiles/blob/dev-dhcp/feature/dhcp/dhcpv4_client_server_b2b_test.go)

  ```go
    // Configure a DHCP Client
      dhcpclient := d1Eth1.Dhcpv4Interfaces().Add().
          SetName("p1d1dhcpv41")

      dhcpclient.FirstServer()
      dhcpclient.ParametersRequestList().
          SetSubnetMask(true).
          SetRouter(true).
          SetRenewalTimer(true)

    // Configure a DHCP Server
      d2Dhcpv4Server := d2.DhcpServer().Ipv4Interfaces().Add().
          SetName("p2d1dhcpv4server")

      d2Dhcpv4Server.SetIpv4Name("p2d1ipv4").AddressPools().
          Add().SetName("pool1").
          SetLeaseTime(3600).
          SetStartAddress("100.1.100.1").
          SetStep(1).
          SetCount(1).
          SetPrefixLength(16).Options().SetRouterAddress("100.1.0.1").SetEchoRelayWithTlv82(true)
  ```
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: gNMI support added to fetch DHCPv4 Client and Server statistics.

  - [DHCPv4 Client](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-dhcpv4client.txt)

  ```gNMI
    # Combined metrics and states information
    dhcpv4-clients/dhcpv4-client[name=clientName]/state

    # Metrics information 
    dhcpv4-clients/dhcpv4-client[name=clientName]/state/counters

    # States information
    dhcpv4-clients/dhcpv4-client[name=clientName]/state/interface
  ```

  - [DHCPv4 Server](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-dhcpv4server.txt)

  ```gNMI
    # Combined metrics and states information
    dhcpv4-servers/dhcpv4-servers[name=serverName]/state

    # Metrics information
    dhcpv4-servers/dhcpv4-servers[name=serverName]/state/counters

    # States information
    dhcpv4-servers/dhcpv4-servers[name=serverName]/state/leases (For now it will return empty responses.)
  ```

  Note: Support for `GetStates`/`dhcpv4-servers/dhcpv4-servers[name=serverName]/state/leases` of DHCP Server will be provided in subsequent release.

### Bug Fix(s)

* `<b><i>`UHD400`</i></b>`: An issue has been fixed where, Despite proper ARP resolution, packets of `flows` of type `device` might not get forwarded by the DUT, resulting in 0 `rx` statistics.
  This issue is visible for UHD400/ixia-c releases up to `v1.5.0-1`.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: `set_control_state.protocol.all.start` can get stuck till the time all DHPCv4 clients receive the leased IPv4 addresses from the DHCPv4 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.5.0-1

> 23rd May, 2024

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [1.5.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.5.0/artifacts/openapi.yaml) |
| snappi                     | [1.5.0](https://pypi.org/project/snappi/1.5.0)                                                                                              |
| gosnappi                   | [1.5.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.5.0)                                                        |
| keng-controller            | [1.5.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                        |
| ixia-c-traffic-engine      | [1.8.0.7](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                  |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.382](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                              |
| keng-layer23-hw-server     | [1.5.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                 |
| keng-operator              | [0.3.28](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                           |
| otg-gnmi-server            | [1.14.1](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                         |
| ixia-c-one                 | [1.5.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                            |
| UHD400                     | [1.2.7](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.2/1.2.7/artifacts.tar)                                  |

# Bug Fix(s)

* `<b><i>`Ixia-C`</i></b>`: An issue has been detected whereby some internal certificates used in the ixia-c containerized solution has expired. `<b><i>`This is fixed in this patch build.`</i></b>`

  The most common manifestation of this is that despite proper ARP resolution, Traffic Start in tests will fail in combined protocol-engine/traffic-engine setups with `Error occurred while starting flows: [error starting tx port <portname>: unsuccessful Response: MAC address resolution failed for IP: <ip address>  ]`.

  `<b><i>`This issue should not affect standalone traffic-engine setups using 'port' or raw traffic flows.`</i></b>`

  This issue is visible for ixia-c community releases starting from `v0.1.0-3` to `v1.4.0-15`.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.4.0-15

> 20th May, 2024

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [1.4.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.4.0/artifacts/openapi.yaml) |
| snappi                     | [1.4.0](https://pypi.org/project/snappi/1.4.0)                                                                                              |
| gosnappi                   | [1.4.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.4.0)                                                        |
| keng-controller            | [1.4.0-15](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                       |
| ixia-c-traffic-engine      | [1.8.0.3](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                  |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.379](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                              |
| keng-layer23-hw-server     | [1.4.0-3](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                 |
| keng-operator              | [0.3.28](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                           |
| otg-gnmi-server            | [1.13.18](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                        |
| ixia-c-one                 | [1.4.0-15](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |
| UHD400                     | [1.2.7](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.2/1.2.7/artifacts.tar)                                  |

# Bug Fix(s)

* `<b><i>`Ixia-C, Ixia Chassis & Appliances(Novus, AresOne), UHD400`</i></b>`: Issue is fixed where metric columns were being returned that were not part of the requested metric columns in the `get_metrics` request for `port`/`flow`.
* `<b><i>`Ixia-C, Ixia Chassis & Appliances(Novus, AresOne), UHD400`</i></b>` Issue where BGP learned information intermittently fails to correctly fetch information from peers across multiple test ports is fixed.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue where `flow_metrics[i].timestamps.first_timestamp_ns/last_timestamp_ns` is being returned with wrong values is fixed.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`UHD400`</i></b>`: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.4.0-1

> 7th May, 2024

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [1.4.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.4.0/artifacts/openapi.yaml) |
| snappi                     | [1.4.0](https://pypi.org/project/snappi/1.4.0)                                                                                              |
| gosnappi                   | [1.4.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.4.0)                                                        |
| keng-controller            | [1.4.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                        |
| ixia-c-traffic-engine      | [1.6.0.167](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.379](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                              |
| keng-layer23-hw-server     | [1.4.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                 |
| keng-operator              | [0.3.28](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                           |
| otg-gnmi-server            | [1.13.18](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                        |
| ixia-c-one                 | [1.4.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                            |
| UHD400                     | [1.2.7](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.2/1.2.7/artifacts.tar)                                  |

# Release Features(s)

* `<b><i>`Ixia-C, Ixia Chassis & Appliances(Novus, AresOne), UHD400`</i></b>`: Support added for fetching information about received extended community attributes in `get_states` for `bgp_prefixes`.

  - OTG support [details](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/master/artifacts/openapi.yaml&nocors#tag/Monitor/operation/get_states). For more details and example please refer [here](https://github.com/open-traffic-generator/models/pull/374).

    ```
    monitor/get_state/responses/200/bgp_prefixes/ipv[4|6]_unicast_prefixes/extended_communities
    ```
  - gNMI support [details](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-bgp.txt).

    ```
      bgp-peers/bgp-peer[name=*]/unicast-ipv4-prefixes/unicast-ipv4-prefix/state/extended-community

      bgp-peers/bgp-peer[name=*]/unicast-ipv6-prefixes/unicast-ipv6-prefix/state/extended-community
    ```

  Note: To store the received routes, please set `devices[i].bgp.ipv4/v6_interfaces[j].peers[k].learned_information_filter.unicast_ipv4/v6_prefix=true`.
* `<b><i>`OTG-gNMI-Server`</i></b>`: Support added for get software and sdk version of keng-controller. [details](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-platform.txt)

  * gNMI query path
    ```
    /components/component[name=keng-controller]/
    ```

# Bug Fix(s)

* `<b><i>`Ixia-C, Ixia Chassis & Appliances(Novus, AresOne), UHD400`</i></b>`: Issue is fixed where metric columns were being returned that were not part of the requested metric columns in the `get_metrics` request for `bgpv4`/`bgpv6`/`isis`/`rsvp`/`lag`/`lacp`.
* `<b><i>`Ixia-C`</i></b>`: Issue is fixed where extended communities of type Transitive IPv4 were being sent with reversed bytes on the wire is fixed.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue where storage of learned LSPs for ISIS was always enabled is now fixed. User can enable it by setting `devices[i].isis.basic.learned_lsp_filter=true`.
* `<b><i>`UHD400`</i></b>`: Issue where tx and rx statistics returned erroneously for multiple runs on same traffic config is now fixed.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.3.0-2

> 19th April, 2024

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [1.3.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.3.0/artifacts/openapi.yaml) |
| snappi                     | [1.3.0](https://pypi.org/project/snappi/1.3.0)                                                                                              |
| gosnappi                   | [1.3.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.3.0)                                                        |
| keng-controller            | [1.3.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                        |
| ixia-c-traffic-engine      | [1.6.0.167](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.378](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                              |
| keng-layer23-hw-server     | [1.3.0-4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                 |
| keng-operator              | [0.3.28](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                           |
| otg-gnmi-server            | [1.13.15](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                        |
| ixia-c-one                 | [1.3.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                            |
| UHD400                     | [1.2.4](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.2/1.2.4/artifacts.tar)                                  |

# Release Features(s)

* `<b><i>`Ixia-C, Ixia Chassis & Appliances(Novus, AresOne), UHD400`</i></b>`: Support added for advertising Segment Routing Traffic Engineering(SR-TE) policy using `replay_updates`.
  ```go
    peer.Capability().SetIpv4SrTePolicy(true) 
    updateReplayBlock := peer.ReplayUpdates().StructuredPdus()
    adv := updateReplayBlock.Updates().Add()
    ...
    adv.PathAttributes().
      Community().
      Add().
      NoAdvertised()
    ipv4_sr_routes_adv := adv.PathAttributes().
      MpReach().
      Ipv4Srpolicy()
    ipv4_sr_routes_adv.SetEndpoint("0.0.0.0").
      SetColor(100).
      SetDistinguisher(1)
    sr := adv.PathAttributes().
      TunnelEncapsulation().
      SrPolicy()
    sr.Preference().SetValue(3)
    sr.PolicyName().SetValue("TypeA Policy")
    ...
    sr.BindingSegmentIdentifier().Mpls().
      SetFlagSpecifiedBsidOnly(true).
      MplsSid().
      SetLabel(22222)
    segmentList := sr.SegmentList().Add()
    segmentList.Weight().
      SetValue(200)
    typeA := segmentList.Segments().Add().TypeA()
    typeA.Flags().
      SetSFlag(true)
    typeA.MplsSid().
      SetLabel(10000)
    //More segments and segments lists
  ```
* `<b><i>`Ixia-C `</i></b>`: Support added for zero and custom checksum in `TCP/UDP/ICMPv4/v6/IPv4/GRE` packet templates in flows.
  ```go
    udp := cfg.Flows().Add().Packet().Add().Udp()
    udp.Checksum().SetCustom(0)
  ```
* `<b><i>`Ixia-C `</i></b>`: DPDK version upgraded from v21.11 to v23.11 for standalone `ixia-c-traffic-engine` container based deployment in DPDK mode.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for IPv4/v6 route ranges with varying number of `communities`/`extended_communities` for BGP/BGP+ peers.
  ```go
    route.Communities().Add().
      SetAsNumber(65534).
      SetAsCustom(20410).
      SetType(gosnappi.BgpCommunityType.MANUAL_AS_NUMBER)
  ```

# Bug Fix(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue is fixed where sometimes fetching ISIS `get_states` would result in `Error occurred while fetching isis lsps states:Index was outside the bounds of the array` exception.
* `<b><i>`Ixia-C, Ixia Chassis & Appliances(Novus, AresOne), UHD400`</i></b>`: Issue is fixed where sometimes misleading warnings were being returned from `set_config` when running consecutive `replay_updates` tests with different types of BGP peers configured(iBGP/eBGP).
* `<b><i>`Ixia-C `</i></b>`: Memory leak fixed for BGPv4/v6 peers with large number of routes configured.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* `<b><i>`UHD400`</i></b>`: Port statistics are not getting cleared on `SetConfig`.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.1.0-21

> 29th March, 2024

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [1.1.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.1.0/artifacts/openapi.yaml) |
| snappi                     | [1.1.1](https://pypi.org/project/snappi/1.1.1)                                                                                              |
| gosnappi                   | [1.1.1](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.1.1)                                                        |
| keng-controller            | [1.1.0-21](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                       |
| ixia-c-traffic-engine      | [1.6.0.109](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.375](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                              |
| keng-layer23-hw-server     | [1.1.0-6](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                 |
| keng-operator              | [0.3.28](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                           |
| otg-gnmi-server            | [1.13.14](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                        |
| ixia-c-one                 | [1.1.0-21](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |
| UHD400                     | [1.2.4](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.2/1.2.4/artifacts.tar)                                  |

# Release Features(s)

* `<b><i>`Ixia Chassis & Appliances(Novus + AresOne)`</i></b>`: Support added for BGP/BGP+ update replay. This feature can be used to configure the BGP/BGP+ peer to send series of updates containing advertised or withdrawn IPv4/v6 unicast routes.

  ```go
    updateReplayBlock := bgpPeer.ReplayUpdates().StructuredPdus()
    adv := updateReplayBlock.Updates().Add()
    adv.PathAttributes().SetOrigin(gosnappi.BgpAttributesOrigin.IGP)
    adv.PathAttributes().AsPath().
          FourByteAsPath().
          Segments().
          Add().
          SetType(gosnappi.BgpAttributesFourByteAsPathSegmentType.AS_SEQ).
          SetAsNumbers([]uint32{2222, 1113, 7000, 80000})

    adv.PathAttributes().Community().Add().CustomCommunity().SetAsNumber(65534).SetCustom("4FBA")
    adv.PathAttributes().Community().Add().CustomCommunity().SetAsNumber(65534).SetCustom("AAAA")
    ....
    adv.PathAttributes().MpReach(). NextHop().SetIpv4("1.1.1.2")
    ipv4_unicast_routes_adv := adv.PathAttributes().MpReach().Ipv4Unicast() 
    ipv4_unicast_routes_adv.Add().SetAddress("10.10.10.10").SetPrefix(32)
    ...  
  ```
* `<b><i>`UHD400`</i></b>`: Support added for setting ports state using `set_control_state.port.link.state=up/down`.
* `<b><i>`snappi`</i></b>`: support added for python `v3.12`.

# Bug Fix(s)

* `<b><i>`Ixia-C`</i></b>`: Issue where BGP/BGP+ sessions were intermittently flapping for large number of routes such as 1 million is fixed.
* `<b><i>`Ixia-C`</i></b>`: Issue where if `priority` bits were set in VLAN header for incoming ISIS PDUs session was not coming up is fixed.
* `<b><i>`Ixia Chassis & Appliances(AresOne)`</i></b>`: Issue where port stats were not coming for port type `TA1-KD08D` of AresOne is fixed.
* `<b><i>`UHD400`</i></b>`: Intermittent issue where `rx` counters were not being incremented for flow stats is fixed.

#### Known Issues

* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* `<b><i>`UHD400`</i></b>`: Port statistics are not getting cleared on `SetConfig`.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.1.0-12

> 22nd March, 2024

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [1.1.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.1.0/artifacts/openapi.yaml) |
| snappi                     | [1.1.0](https://pypi.org/project/snappi/1.1.0)                                                                                              |
| gosnappi                   | [1.1.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.1.0)                                                        |
| keng-controller            | [1.1.0-12](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                       |
| ixia-c-traffic-engine      | [1.6.0.109](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                |
| keng-app-usage-reporter    | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.370](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                              |
| keng-layer23-hw-server     | [1.1.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                 |
| keng-operator              | [0.3.28](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                           |
| otg-gnmi-server            | [1.13.13](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                        |
| ixia-c-one                 | [1.1.0-12](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |
| UHD400                     | [1.2.3](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.2/1.2.3/artifacts.tar)                                  |

# Release Features(s)

* `<b><i>`UHD400`</i></b>`: Support for LAG and LACP protocol is added.

  - LACP parameters are supported as per LAG/LACP section in OTG model `<a href="https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v1.1.0/openapi.yaml"><img alt="Release v1.1.0" src="https://img.shields.io/badge/release-v1.1.0-brightgreen">``</a>`
  - Per Port LACP Metrics can be retrieved using GNMI as per otg-models-yang `<a href="https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-lacp.txt">`details`</a>`.
  - Per LAG Metrics can be retrieved using GNMI as per otg-models-yang `<a href="https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-lag.txt">`details`</a>`.
* `<b><i>`UHD400`</i></b>`: Support for data traffic over LAG is added for `rx` ports.

#### Known Issues

* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* `<b><i>`UHD400`</i></b>`: Port statistics are not getting cleared on `SetConfig`.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.1.0-10

> 20th March, 2024

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [1.1.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.1.0/artifacts/openapi.yaml) |
| snappi                     | [1.1.0](https://pypi.org/project/snappi/1.1.0)                                                                                              |
| gosnappi                   | [1.1.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.1.0)                                                        |
| keng-controller            | [1.1.0-10](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                       |
| ixia-c-traffic-engine      | [1.6.0.109](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                |
| keng-app-usage-reporter    | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.370](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                              |
| keng-layer23-hw-server     | [1.1.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                 |
| keng-operator              | [0.3.28](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                           |
| otg-gnmi-server            | [1.13.12](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                        |
| ixia-c-one                 | [1.1.0-10](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |
| UHD400                     | [1.1.1](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.1/1.1.1/artifacts.tar)                                  |

# Release Features(s)

* `<b><i>`Ixia-C & UHD400`</i></b>`: Support added for BGP/BGP+ update replay. This feature can be used to configure the BGP/BGP+ peer to send series of updates containing advertised or withdrawn IPv4/v6 unicast routes.

  ```go
    updateReplayBlock := bgpPeer.ReplayUpdates().StructuredPdus()
    adv := updateReplayBlock.Updates().Add()
    adv.PathAttributes().SetOrigin(gosnappi.BgpAttributesOrigin.IGP)
    adv.PathAttributes().AsPath().
          FourByteAsPath().
          Segments().
          Add().
          SetType(gosnappi.BgpAttributesFourByteAsPathSegmentType.AS_SEQ).
          SetAsNumbers([]uint32{2222, 1113, 7000, 80000})
    ....
    adv.PathAttributes().MpReach(). NextHop().SetIpv4("1.1.1.2")
    ipv4_unicast_routes_adv := adv.PathAttributes().MpReach().Ipv4Unicast() 
    ipv4_unicast_routes_adv.Add().SetAddress("10.10.10.10").SetPrefix(32)
    ...  
  ```

  - custom attributes can be added in following manner.

  ```go
    adv1.PathAttributes().
            OtherAttributes().Add().
            SetFlagOptional(true).
            SetFlagTransitive(true).
            SetType(8).
            SetRawValue("04ffff0007")
  ```

  - Complete custom update packet can be added by using `RawBytes` option as shown below.

  ```go
    updateReplayBlock := d1BgpIpv4Interface1Peer1.ReplayUpdates().RawBytes()
        adv1 := updateReplayBlock.Updates().Add()
        adv1.SetUpdateBytes("400101004002004005040")
  ```
* `<b><i>`Ixia-C`</i></b>`: Value-list support added for IPv4 `dscp` field.

  ```go
    flowEth := flow.Packet().Add().Ethernet()
    .... 
    ipv4 := flow.Packet().Add().ipv4()
      ipv4.Src().SetValue(srcAddr)
      ipv4.Dst().SetValue(dstAddr)
      ipv4.Priority().Dscp().Phb().SetValues([]uint32{10,12,14,18 ...})
  ```
* `<b><i>`OTG-gNMI-Server`</i></b>`: Support added for `InUpdates`, `OutUpdates`, `InOpens`, `OutOpens`, `InNotifications` and `OutNotifications` for gNMI path `/bgp-peers/bgp-peer/state/counters`.

# Bug Fix(s)

* `<b><i>`Ixia Chassis & Appliances(Novus + AresOne)`</i></b>`: Issue where for protocol over LAG scenarios (e.g. BGP over LAG) `get_metrics` was returning empty protocol metrics, is fixed.
* `<b><i>`Ixia-C`</i></b>`: Issue where `get_states.ipv4/v6_neighbors` for interfaces created over LAG was failing, is now fixed.
* `<b><i>`Ixia-C`</i></b>`: Issue where `peers[i].advanced.time_to_live` attribute was not working as expected for BGPv4 peers is fixed.

#### Known Issues

* `<b><i>`UHD400`</i></b>`: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* `<b><i>`UHD400`</i></b>`: Port statistics are not getting cleared on `SetConfig`.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.0.0-104

> 1st March, 2024

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [1.0.2](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.0.2/artifacts/openapi.yaml) |
| snappi                     | [1.0.2](https://pypi.org/project/snappi/1.0.2)                                                                                              |
| gosnappi                   | [1.0.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.0.2)                                                        |
| keng-controller            | [1.0.0-104](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                      |
| ixia-c-traffic-engine      | [1.6.0.109](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                |
| keng-app-usage-reporter    | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.367](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                              |
| keng-layer23-hw-server     | [1.0.2-4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                 |
| keng-operator              | [0.3.28](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                           |
| otg-gnmi-server            | [1.13.10](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                        |
| ixia-c-one                 | [1.0.1-104](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                          |
| UHD400                     | [1.1.1](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.1/1.1.1/artifacts.tar)                                  |

# Release Features(s)

* `<b><i>`UHD400`</i></b>`: Value-list support added for IPv6 flow label.

  ```go
    flowEth := flow.Packet().Add().Ethernet()
    .... 
    ipv6 := flow.Packet().Add().Ipv6()
      ipv6.Src().SetValue(srcAddr)
      ipv6.Dst().SetValue(dstAddr)
      ipv6.FlowLabel().SetValues([]uint32{1000,2000, ...})
  ```
* `<b><i>`UHD400`</i></b>`: Support added for egress tracking on DSCP field in IPv4 traffic header using Priority.Raw field with appropriate offsets.

  ```go
    eth := flow.EgressPacket().Add().Ethernet()
    ipv4 := flow.EgressPacket().Add().Ipv4()
    ipv4PhbTag := ipv4.Priority().Raw().MetricTags().Add()
    ipv4PhbTag.SetName("flow_ipv4_dscp_phb")
    ipv4PhbTag.SetOffset(0)
    ipv4PhbTag.SetLength(6)
      ipv4EcnTag := ipv4.Priority().Raw().MetricTags().Add()
    ipv4EcnTag.SetName("flow_ipv4_dscp_ecn")
    ipv4EcnTag.SetOffset(6)
    ipv4EcnTag.SetLength(2)
  ```
* `<b><i>`Ixia Chassis & Appliances(Novus + AresOne), Ixia-C and UHD400`</i></b>`: Support added for partial Start / Stop for ISIS .

  ```go
    s := gosnappi.NewControlState()
    isisRouters := s.Protocol().Isis().Routers()      
    isisRouters.SetRouterNames(routerNames).SetState("up/down")
    _ , err := client.Api().SetControlState(s)
  ```
* `<b><i>`Ixia Chassis & Appliances(Novus + AresOne)`</i></b>`: Support added for partial Start / Stop for BGP.

  ```go
    s := gosnappi.NewControlState()
    bgpPeers := s.Protocol().Bgp().Peers()      
    bgpPeers.SetPeerNames(peerNames).SetState("up/down")
    _ , err := client.Api().SetControlState(s)
  ```
* `<b><i>`Ixia Chassis & Appliances(Novus + AresOne) and Ixia-C`</i></b>`: Support for all objects including ERO and RRO are now available for RSVP packet header.

  - User can encode `rsvp` packet using `flows` and invoke `set_control_state.traffic.flow_transmit` to transmit the `rsvp` packets.

  ```go
    f1.Packet().Add().Ethernet()
    ip := f1.Packet().Add().Ipv4()
    ip.Options().Add().SetChoice("router_alert")
    rsvp := f1.Packet().Add().Rsvp()
    rsvpPathMsg := rsvp.MessageType().Path()
    session := rsvpPathMsg.Objects().Add().ClassNum().Session().CType().LspTunnelIpv4()
    session.Ipv4TunnelEndPointAddress().SetValue("2.2.2.2")
    session.TunnelId().SetValue(1)
    session.ExtendedTunnelId().AsIpv4().SetValue("1.1.1.1")
    rsvpHop := rsvpPathMsg.Objects().Add().ClassNum().RsvpHop().CType().Ipv4()
    rsvpHop.Ipv4Address().SetValue("1.1.2.1")
    rsvpPathMsg.Objects().Add().ClassNum().TimeValues()
    rsvpPathMsg.Objects().Add().ClassNum().LabelRequest()
    ero := rsvpPathMsg.Objects().Add().ClassNum().ExplicitRoute().CType().Type1()
    ero.Subobjects().Add().Type().Ipv4Prefix().Ipv4Address().SetValue("1.1.3.1")
    ero.Subobjects().Add().Type().Ipv4Prefix().Ipv4Address().SetValue("1.1.4.1")
    sessionAttribute := rsvpPathMsg.Objects().Add().ClassNum().SessionAttribute().CType().LspTunnel()
    sessionAttribute.SetSessionName("otg_test_port")
    senderTemplate := rsvpPathMsg.Objects().Add().ClassNum().SenderTemplate().CType().LspTunnelIpv4()
    senderTemplate.Ipv4TunnelSenderAddress().SetValue("1.1.1.1")
    senderTemplate.LspId().SetValue(1)
    senderTspec := rsvpPathMsg.Objects().Add().ClassNum().SenderTspec().CType().IntServ()
    senderTspec.MaximumPacketSize().SetValue(1500)
    senderTspec.SetPeakDataRate(1e+10)
    rro := rsvpPathMsg.Objects().Add().ClassNum().RecordRoute().CType().Type1()
    rro.Subobjects().Add().Type().Ipv4Address().Ipv4Address().SetValue("1.1.1.1")
    rro.Subobjects().Add().Type().Ipv4Address().Ipv4Address().SetValue("1.1.2.1")
  ```

  - Note:
    - Variable field values within the flow using `increment`, `decrement` and `values` are not supported for `rsvp` fields.
    - Tracking should not be enabled if intention is for device under test to consume the generated packets.

# Bug Fix(s)

* `<b><i>`Ixia-C and UHD400`</i></b>`: Intermittent issue is fixed where for certain ISIS L1+L2 test scenarios, ISIS Hello PDUs were not being transmitted from test ports.
* `<b><i>`Ixia-C and UHD400`</i></b>`: Potential deadlock during `SetConfig` related to creation of interfaces is fixed.
* `<b><i>`Ixia-C and UHD400`</i></b>`: Intermittent issue is fixed where ixia-c-protocol-engine container was restarting during BGP session establishment in certain scenarios.
* `<b><i>`Ixia Chassis & Appliances(AresOne)`</i></b>`: Issue where `SetConfig` returns error `Object reference not set to an instance of an object.` for AresOne ports (QSFP-DD-400GE+200G+100G+50G) is fixed.
* `<b><i>`Ixia Chassis & Appliances(Novus + AresOne)`</i></b>`: Issue where `SetConfig` returns error `Somehow <lag_name> not available within BGP portData` for BGP over LAG is fixed (Please refer to Known Issues section for issue related to BGP metrics returning empty values for BGP over LAG scenario).

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus + AresOne)`</i></b>`: For protocol over LAG scenarios (e.g. BGP over LAG) `get_metrics` is returning empty protocol metrics.
* `<b><i>`Ixia-C`</i></b>`: Get neighbor states for a LAG member port fails.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.0.0-92

> 22nd February, 2024

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [1.0.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.0.1/artifacts/openapi.yaml) |
| snappi                     | [1.0.1](https://pypi.org/project/snappi/1.0.1)                                                                                              |
| gosnappi                   | [1.0.1](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.0.1)                                                        |
| keng-controller            | [1.0.0-92](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                       |
| ixia-c-traffic-engine      | [1.6.0.109](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                |
| keng-app-usage-reporter    | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.360](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                              |
| keng-layer23-hw-server     | [1.0.1-4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                 |
| keng-operator              | [0.3.28](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                           |
| otg-gnmi-server            | [1.13.9](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                         |
| ixia-c-one                 | [1.0.1-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                            |
| UHD400                     | [1.1.1](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.1/1.1.1/artifacts.tar)                                  |

# Release Features(s)

* `<b><i>`UHD400`</i></b>`: Enabling metric_tags for egress tracking is now supported for ethernet.src/ dst, vlan.id, vlan.priority, ipv4.src/ dst, ipv4.precedence, ipv6.src/ dst, ipv6.traffic_class

  ```go
  eth := flow.EgressPacket().Add().Ethernet()
  ipv4 := flow.EgressPacket().Add().Ipv4()
  ipv4Tag := ipv4.Dst().MetricTags().Add()
  ipv4Tag.SetName("flow_ipv4_dst")
  ipv4Tag.SetOffset(22)
  ipv4Tag.SetLength(10)
  ```

  - Limitations:
    - Maximum of 10 tracking bits is supported.
    - Only a single flow is supported when egress tracking is enabled, except when the tracking header field is Vlan.priority, IPv4.precedence or IPv6.traffic_class. Multiple flows are supported when tracking is enabled on these fields.
    - Tracking is supported on the last 10 bits of header fields, except for IPv4 src/ dst where first 5 bit tracking is also supported.
* `<b><i>`UHD400`</i></b>`: Support is added for `values` on header fields ethernet.src /dst, ipv4.src /dst, ipv6.src /dst, vlan.id, tcp.src_port, tcp.dst_port, udp.src_port, udp.dst_port.
* `<b><i>`Ixia-C`</i></b>`: Support added for `rsvp` Path Message PDU in raw traffic.

  - User can encode `rsvp` packet using `flows` and invoke `set_control_state.traffic.flow_transmit` to transmit the `rsvp` packets.

  ```go
    f1.Packet().Add().Ethernet()
    ip := f1.Packet().Add().Ipv4()
    ip.Options().Add().SetChoice("router_alert")
    rsvp := f1.Packet().Add().Rsvp()
    rsvpPathMsg := rsvp.MessageType().Path()
    session := rsvpPathMsg.Objects().Add().ClassNum().Session().CType().LspTunnelIpv4()
    session.Ipv4TunnelEndPointAddress().SetValue("2.2.2.2")
    session.TunnelId().SetValue(1)
    session.ExtendedTunnelId().AsIpv4().SetValue("1.1.1.1")
    rsvpHop := rsvpPathMsg.Objects().Add().ClassNum().RsvpHop().CType().Ipv4()
    rsvpHop.Ipv4Address().SetValue("1.1.2.1")
    rsvpPathMsg.Objects().Add().ClassNum().TimeValues()
    rsvpPathMsg.Objects().Add().ClassNum().LabelRequest()
    sessionAttribute := rsvpPathMsg.Objects().Add().ClassNum().SessionAttribute().CType().LspTunnel()
    sessionAttribute.SetSessionName("otg_test_port")
    senderTemplate := rsvpPathMsg.Objects().Add().ClassNum().SenderTemplate().CType().LspTunnelIpv4()
    senderTemplate.Ipv4TunnelSenderAddress().SetValue("1.1.1.1")
    senderTemplate.LspId().SetValue(1)
    senderTspec := rsvpPathMsg.Objects().Add().ClassNum().SenderTspec().CType().IntServ()
    senderTspec.MaximumPacketSize().SetValue(1500)
    senderTspec.SetPeakDataRate(1e+10)
  ```

  - Note:
    - Variable field values within the flow using `increment`, `decrement` and `values` are not supported for `rsvp` fields.
    - Optional objects `ClassNum().ExplicitRoute()` and `ClassNum().RecordRoute()` are not yet supported.
    - Tracking should not be enabled if intention is for device under test to consume the generated packets.

# Bug Fix(s)

* `<b><i>`keng-operator`</i></b>`: Issue is fixed where `Ixia-C` containers would incorrectly signal readiness even when containers were not fully started in kne deployment, resulting in `SetConfig` and licensing errors.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue is fixed where `SetConfig` fails for a traffic flow where inner header (v4/v6) has DSCP value set.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v1.0.0-7

> 5th February, 2024

#### About

This release introduces `snappi v1.0` and `keng-controller v1.0`.
Backwards API compatibility will be maintained within  `1.x` versions of Open Traffic Generator, `go-snappi` and `snappi` APIs.

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [1.0.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.0.0/artifacts/openapi.yaml) |
| snappi                     | [1.0.0](https://pypi.org/project/snappi/1.0.0)                                                                                              |
| gosnappi                   | [1.0.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.13.7)                                                       |
| keng-controller            | [1.0.0-7](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                        |
| ixia-c-traffic-engine      | [1.6.0.109](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                |
| keng-app-usage-reporter    | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.358](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                              |
| keng-layer23-hw-server     | [1.0.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                 |
| keng-operator              | [0.3.22](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                           |
| otg-gnmi-server            | [1.13.8](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                         |
| ixia-c-one                 | [1.0.0-7](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                            |
| UHD400                     | [1.0.28](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.0/1.0.28/artifacts.tar)                                |

# Release Features(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for `snmpv2c` raw traffic.

  - User can encode `snmpv2c` packet using `flows` and invoke `set_control_state.traffic.flow_transmit` to transmit the `snmpv2c` packets.

  ```go
    flowEth := flow.Packet().Add().Ethernet()
    .... 
    flowIp := flow.Packet().Add().Ipv4()
    ....
    flowUdp := flow.Packet().Add().Udp()
    ....
    flowUdp.DstPort().SetValue(uint32(161)) // 161 = SNMP
    flowSnmpv2c := flow.Packet().Add().Snmpv2C()
    pdu := flowSnmpv2c.Data().GetRequest()
    pdu.RequestId().SetValue(77777)
    varBinds := pdu.VariableBindings().Add()
    varBinds.SetObjectIdentifier(
      "1.3.6....",
    )
  ```

  Note: Variable field values within the same flow using `increment`, `decrement` and `values` are not supported for `snmpv2c` fields.
* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for `AresOne-M 800G`` load modules. For using this, `IXOS 10.00 `must be installed on the chassis. For other load modules, it will continue to work with`IXOS 9.20 and 9.30` setups.

# Bug Fix(s)

* `<b><i>`Ixia-C`</i></b>`: Issue where `set_control_state.port.link.state` was not working when applied to member ports of a LAG is now fixed.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.1.0-222

> 19th January, 2024

#### About

This build includes new features and bug fixes.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.13.7](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.13.7/artifacts/openapi.yaml) |
| snappi                     | [0.13.7](https://pypi.org/project/snappi/0.13.7)                                                                                              |
| gosnappi                   | [0.13.7](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.13.7)                                                        |
| keng-controller            | [0.1.0-222](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                        |
| ixia-c-traffic-engine      | [1.6.0.109](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                  |
| keng-app-usage-reporter    | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.355](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [0.13.7-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.15](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.13.7](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                           |
| ixia-c-one                 | [0.1.0-222](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                            |
| UHD400                     | [1.0.28](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.0/1.0.28/artifacts.tar)                                  |

# Release Features(s)

* `<b><i>`Ixia-C`</i></b>`: Support added for `snmpv2c` raw traffic.

  - User can encode `snmpv2c` packet using `flows` and invoke `set_control_state.traffic.flow_transmit` to transmit the `snmpv2c` packets.

  ```go
    flowEth := flow.Packet().Add().Ethernet()
    .... 
    flowIp := flow.Packet().Add().Ipv4()
    ....
    flowUdp := flow.Packet().Add().Udp()
    ....
    flowUdp.DstPort().SetValue(uint32(161)) // 161 = SNMP
    flowSnmpv2c := flow.Packet().Add().Snmpv2C()
    pdu := flowSnmpv2c.Data().GetRequest()
    pdu.RequestId().SetValue(77777)
    varBinds := pdu.VariableBindings().Add()
    varBinds.SetObjectIdentifier(
      "1.3.6....",
    )
  ```

  Note: Variable field values within the same flow using `increment`, `decrement` and `values` are not supported for `snmpv2c` fields.
* `<b><i>`Ixia-C`</i></b>`: Support added for `ipv4.options` in `ipv4` header of raw traffic.

  - `router_alert` option allows devices to intercept packets not addressed to them directly as defined in RFC2113.
  - `custom` option is provided for to be able to configure user defined `ipv4.options` as needed.

  ```go
    // Sample of router_alert option:
    ip.Options().Add().SetChoice("router_alert")

    // Sample of user defined custom TLV options (Stream ID)
    ipOptionCustom := ip.Options().Add().SetChoice("custom")
    ipOptionCustom.Custom().Type().CopiedFlag().SetChoice("value").SetValue(0)
    ipOptionCustom.Custom().Type().OptionClass().SetChoice("value").SetValue(0)
    ipOptionCustom.Custom().Type().OptionNumber().SetChoice("value").SetValue(8)

    ipOptionCustom.Custom().Length().SetChoice("value").SetValue(4)
    ipOptionCustom.Custom().SetValue("0088")
  ```
* `<b><i>`Ixia-C`</i></b>`: Support added to enable/disable LACP sessions on the fly.

  ```go
    lagOnlyStart := port2.NewControlState().
        SetChoice(gosnappi.ControlStateChoice.PROTOCOL)
    lagMembers := lagOnlyStart.Protocol().
        Lacp().
        MemberPorts()
    lagMembers.
        SetState(gosnappi.StateProtocolLacpMemberPortsState.UP)
  ```

# Bug Fix(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Issue where egress tracking(`metric_tags`) was returning an error when trying to track on 'ipv4.priority.raw'(for DSCP) is fixed.
* `<b><i>`Ixia-C`</i></b>`: Issue where `BGP` AS4 number was being logged incorrectly in `ixia-c-protocol-engine` logs is fixed. [#217](https://github.com/open-traffic-generator/snappi/issues/217)
* `<b><i>`Ixia-C`</i></b>`: Couple of memory leak issues fixed in BGP seen for multiple start/stop of large number of BGP sessions on a port.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.1.0-158

> 21st December, 2023

#### About

This build includes new features and bug fixes.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.13.4](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.13.4/artifacts/openapi.yaml) |
| snappi                     | [0.13.4](https://pypi.org/project/snappi/0.13.4)                                                                                              |
| gosnappi                   | [0.13.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.13.4)                                                        |
| keng-controller            | [0.1.0-158](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                        |
| ixia-c-traffic-engine      | [1.6.0.109](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                  |
| keng-app-usage-reporter    | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.348](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [0.13.4-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.14](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.13.4](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                           |
| ixia-c-one                 | [0.1.0-158](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                            |
| UHD400                     | [1.0.28](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.0/1.0.28/artifacts.tar)                                  |

# Release Features(s)

* `<b><i>`Ixia-C, UHD400, Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: Support added for BGP/BGP+ peers to use `custom` ports instead of default `179` tcp port.
  - Listen Port - TCP port number on which to accept BGP/BGP+ connections from the remote peer.
  - Neighbor Port - Destination TCP port number to be used by the BGP/BGP+ peer when initiating a session to the remote peer.

  ```go
    bgpPeer.Advanced().SetListenPort(55555)
    bgpPeer.Advanced().SetNeighborPort(55555)
  ```
* `<b><i>`Ixia-C`</i></b>`: Support added to enable/disable BGP/BGP+ peers on the fly.
  ```go
    s := gosnappi.NewControlState().             
        SetChoice(gosnappi.ControlStateChoice.PROTOCOL)
    bgpPeers := s.Protocol().Bgp().Peers()      
    bgpPeers.SetPeerNames(peerNames).
    SetState(gosnappi.StateProtocolBgpPeersState.UP/DOWN)
    _ , err := client.Api().SetControlState(s)
  ```
* Public API in `gosnappi` SDK has been cleaned up and refactored. [PR with the details](https://github.com/open-traffic-generator/snappi/pull/214)
  - `GosnappiApi` interface is now renamed to `Api` interface.
  - All public methods for creation of structs are now removed from `GosnappiApi` interface.
  - There were helper methods defined on each struct which have been reorganized or hidden.
  - Choice setter `SetChoice()` has been made private and is now implicitly set based on the `choice` property set by the user.
  - Impact on backward compatibility:
    - Updating of gosnappi to `0.13.4` or higher will need change of test programs/implementations utilizing `gosnappi` SDK.
    - If gosnappi is not updated on the client current tests will continue to work with new `keng-controller:0.1.0-158`.

# Bug Fix(s)

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If a port was in link down state, the state was not being cleared on fresh `SetConfig` for `AresOne` ports and `Novus100G` mode, affecting future tests. This issue is fixed.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.1.0-84

> 7th December, 2023

#### About

This build includes new features.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.13.2](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.13.2/artifacts/openapi.yaml) |
| snappi                     | [0.13.2](https://pypi.org/project/snappi/0.13.2)                                                                                              |
| gosnappi                   | [0.13.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.13.2)                                                        |
| keng-controller            | [0.1.0-84](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                         |
| ixia-c-traffic-engine      | [1.6.0.100](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                  |
| keng-app-usage-reporter    | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.340](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [0.13.2-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.13](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.13.2](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                           |
| ixia-c-one                 | [0.1.0-84](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |
| UHD400                     | [1.0.27](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.0/1.0.27/artifacts.tar)                                  |

# Release Features(s)

* `<b><i>`Ixia-C`</i></b>`: Support added to trigger link `up/down` on test ports using the API `set_control_state.port.link`. This applicable only when the test port is directly connected to device under test via `veth` connection, e.g in KNE single node cluster, containerlab.
  ```go
    portStateAction := gosnappi.NewControlState()
    linkState := portStateAction.Port().Link().
                    SetPortNames([]string{port.Name()}).
                    SetState(gosnappi.StatePortLinkState.DOWN/UP)
    api.SetControlState(portStateAction)
  ```

  - It removes the deviation (`deviation_ate_port_link_state_operations_unsupported`) which was added in `featuresprofile` tests for no supporting the LinkState trigger in `<b><i>`Ixia-C`</i></b>`.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.1.0-81

> 24th November, 2023

#### About

This build includes new features and bug fixes.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.13.2](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.13.2/artifacts/openapi.yaml) |
| snappi                     | [0.13.2](https://pypi.org/project/snappi/0.13.2)                                                                                              |
| gosnappi                   | [0.13.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.13.2)                                                        |
| keng-controller            | [0.1.0-81](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                         |
| ixia-c-traffic-engine      | [1.6.0.100](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                  |
| keng-app-usage-reporter    | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.339](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [0.13.2-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.13](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.13.2](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                           |
| ixia-c-one                 | [0.1.0-81](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |
| UHD400                     | [1.0.27](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.0/1.0.27/artifacts.tar)                                  |

# Release Features(s)

* Support for BGP/BGP+ passive mode `<b><i>`Ixia-C, UHD400 and Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`. If `passive_mode` of a peer is set to true, it will wait for the remote peer to initiate the BGP session.

  - User needs to set `devices[i].bgp.ipv4/v6_interfaces[j].peers[k].advance.passive_mode` to `true` for enabling passive mode.
* When `layer1[i].speed` is not explicitly set, the current speed of underlying test interface shall be assumed.

  - This allows setting of `layer1` MTU in tests to run on  setups with different port speeds on `<b><i>`Ixia-C and Ixia Chassis & Appliances(Novus, AresOne)`</i></b>` without any modifications.
    ```go
      otgConfig.Layer1().Add().
          SetName("layerOne").
          SetPortNames(portNames).
          SetMtu(9000)
    ```
  - For traffic with `flow.rate.percentage` specified and `layer1[i].speed` not specified, the rate is now automatically calculated based on the port speed of the port from where traffic is being transmitted.

# Bug Fix(s)

* Issue where `devices[i].bgp.ipv4/v6_interfaces[j].peers[k].v4/v6_routes[m].communities` was not being sent properly for `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>` is now fixed.

#### Known Issues

* `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* `<b><i>`Ixia-C`</i></b>`: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* `<b><i>`Ixia-C`</i></b>`: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* `<b><i>`Ixia-C`</i></b>`: The metric `loss` in flow metrics is currently not supported.
* `<b><i>`Ixia-C`</i></b>`: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.1.0-53

> 10th November, 2023

#### About

This build includes new features and bug fixes.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.13.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.13.0/artifacts/openapi.yaml) |
| snappi                     | [0.13.0](https://pypi.org/project/snappi/0.13.0)                                                                                              |
| gosnappi                   | [0.13.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.13.0)                                                        |
| keng-controller            | [0.1.0-53](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                         |
| ixia-c-traffic-engine      | [1.6.0.85](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| keng-app-usage-reporter    | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.337](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [0.13.0-6](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.13](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.13.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                           |
| ixia-c-one                 | [0.1.0-53](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |
| UHD400                     | [1.0.27](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.0/1.0.27/artifacts.tar)                                  |

# Release Features(s)

* Support added for link `up/down` trigger for `<b><i>`UHD400`</i></b>`.
  ```go
    portStateAction := gosnappi.NewControlState().
                          Port().
                          Link().
                          SetPortNames([]string{"port1"}).
                          SetState(gosnappi.StatePortLinkState.DOWN)
    gosnappi.setControlState(portStateAction)
  ```
* Support added for 0x8100(Vlan) and 0x6007(Google Discovery Protocol) ether types in data plane traffic in `<b><i>`UHD400`</i></b>`.

# Bug Fix(s)

* Some tests were failing because packets were not sent on wire due to frame size of flows not being sufficient to include tracking information in `<b><i>`Ixia Chassis & Appliances(AresOne only)`</i></b>` is fixed.
* `egress` tracking on VLAN id or other fields for more than 3 bits was not working in `<b><i>`Ixia Chassis & Appliances(Novus, AresOne)`</i></b>`, is fixed.
  - `egress` tracking now supports upto 11 bits.
* Issue in ARP resolution in certain cases is now fixed in `<b><i>`UHD400`</i></b>`.

#### Known Issues

* If `keng-layer23-hw-server` version is upgraded/downgraded, the ports from Ixia Chassis & Appliances(Novus, AresOne) which will be used from this container must be rebooted once before running the tests.
* Adding more than 256 devices on a single ixia-c-port causing failure for Ixia Chassis & Appliances(Novus, AresOne).
* Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* With certain DUTs, ssh service hangs if ISIS L1 MD5 is enabled.
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.1.0-26

> 3rd November, 2023

#### About

This build includes stability fixes.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.13.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.13.0/artifacts/openapi.yaml) |
| snappi                     | [0.13.0](https://pypi.org/project/snappi/0.13.0)                                                                                              |
| gosnappi                   | [0.13.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.13.0)                                                        |
| keng-controller            | [0.1.0-26](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                         |
| ixia-c-traffic-engine      | [1.6.0.85](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| keng-app-usage-reporter    | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.337](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [0.13.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.13](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.13.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                           |
| ixia-c-one                 | [0.1.0-26](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |
| UHD400                     | [1.0.26](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.0/1.0.26/artifacts.tar)                                  |

#### Known Issues

* If `keng-layer23-hw-server` version is upgraded/downgraded, the ports from Ixia Chassis & Appliances(Novus, AresOne) which will be used from this container must be rebooted once before running the tests.
* Adding more than 256 devices on a single ixia-c-port causing failure for Ixia Chassis & Appliances(Novus, AresOne).
* Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* With certain DUTs, ssh service hangs if ISIS L1 MD5 is enabled.
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.1.0-3

> 20th October, 2023

#### About

This build includes new features, stability and bug fixes.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.13.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.13.0/artifacts/openapi.yaml) |
| snappi                     | [0.13.0](https://pypi.org/project/snappi/0.13.0)                                                                                              |
| gosnappi                   | [0.13.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.13.0)                                                        |
| keng-controller            | [0.1.0-3](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)                                          |
| ixia-c-traffic-engine      | [1.6.0.85](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| keng-app-usage-reporter    | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.337](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)                                |
| keng-layer23-hw-server     | [0.13.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)                                  |
| keng-operator              | [0.3.13](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)                                             |
| otg-gnmi-server            | [1.13.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)                                           |
| ixia-c-one                 | [0.1.0-3](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                              |

#### Release Feature(s)

* Ixia-C now offers following existing licensed features free for community use (without requiring Keysight Licensing Solution):
  1. `ixia-c-protocol-engine`, which enables control plane emulation in Ixia-C is now publicly downloadable.
  2. Emulation of one or more IPv4 and IPv6 interfaces with Address Resolution Protocol (ARP) and Neighbor Discovery (ND), respectively, is now supported.
  3. Automatic destination MAC address resolution for flows with IPv4 / IPv6 endpoints is now supported.
  4. Configuring one BGP session over IPv4 / IPv6, advertising V4 / V6 routes is now supported.
* Users exercising full feature set ([Keysight Elastic Network Generator aka KENG](https://www.keysight.com/us/en/products/network-test/protocol-load-test/keysight-elastic-network-generator.html)) will now have to subscribe to Keysight Licensing Solution. Please reach out to Keysight for more details.
* `keng-layer23-hw-server`, which facilitates control and data plane operations on **Ixia Chassis & Appliances(Novus, AresOne)** is now publicly downloadable (but can only be used with Keysight Licensing Solution)
* Support is added for overload bit and extended ipv4 reachability in `get_states` for isis_lsps in **Ixia Chassis & Appliances(Novus, AresOne)**; gNMI path for `isis_lsps`:
  ```
    +--rw isis-routers
      +--ro isis-router* [name]
          +--ro name     -> ../state/name
          +--ro state
            +--ro name?                  string
            .
            .
            +--ro link-state-database
                +--ro lsp-states
  ```

> The container image paths have changed for some Ixia-C artifacts. Please review **Build Details** for correct paths.

#### Bug Fix(s)

* Memory leak in **Ixia Chassis & Appliances(Novus, AresOne)** is fixed for long duration tests.
* `gosnappi` now correctly validates required primitive types when they're not explicitly set by users.
* IS-IS metric is no longer sent as 63 when configured as 200 (or more than 63) with wide metrics enabled on **Ixia Chassis & Appliances(Novus, AresOne)**.

#### Known Issues

* If `keng-layer23-hw-server` version is upgraded/downgraded, the ports from Ixia Chassis & Appliances(Novus, AresOne) which will be used from this container must be rebooted once before running the tests.
* Adding more than 256 devices on a single ixia-c-port causing failure for Ixia Chassis & Appliances(Novus, AresOne).
* Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* With certain DUTs, ssh service hangs if ISIS L1 MD5 is enabled.
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4554

> 29th September, 2023

#### About

This build includes bug fixes.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.12.5](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.12.5/artifacts/openapi.yaml) |
| snappi                     | [0.12.6](https://pypi.org/project/snappi/0.12.6)                                                                                              |
| gosnappi                   | [0.12.6](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.12.6)                                                        |
| ixia-c-controller          | [0.0.1-4554](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                     |
| ixia-c-traffic-engine      | [1.6.0.85](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.331](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                     |
| ixia-c-ixhw-server         | [0.12.5-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                      |
| ixia-c-operator            | [0.3.6](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                            |
| ixia-c-gnmi-server         | [1.12.7](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                        |
| ixia-c-one                 | [0.0.1-4554](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |

#### Bug Fix(s)

* `monitor.flow_metrics` will now correctly reports `bytes_tx`.
* The VLAN TPID field in flow packet header configuration is now set to correct default of 65535 when it’s not encapsulating known protocol header.

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4478

> 14th September, 2023

#### About

This build includes stability fixes.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.12.3](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.12.3/artifacts/openapi.yaml) |
| snappi                     | [0.12.3](https://pypi.org/project/snappi/0.12.3)                                                                                              |
| gosnappi                   | [0.12.3](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.12.3)                                                        |
| ixia-c-controller          | [0.0.1-4478](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                     |
| ixia-c-traffic-engine      | [1.6.0.45](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.326](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                     |
| ixia-c-ixhw-server         | [0.12.3-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                      |
| ixia-c-operator            | [0.3.6](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                            |
| ixia-c-gnmi-server         | [1.12.5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                        |
| ixia-c-one                 | [0.0.1-4478](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4435

> 1st September, 2023

#### About

This build includes bug fixes.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.12.2](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.12.2/artifacts/openapi.yaml) |
| snappi                     | [0.12.2](https://pypi.org/project/snappi/0.12.2)                                                                                              |
| gosnappi                   | [0.12.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.12.2)                                                        |
| ixia-c-controller          | [0.0.1-4435](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                     |
| ixia-c-traffic-engine      | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.325](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                     |
| ixia-c-ixhw-server         | [0.12.2-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                      |
| ixia-c-operator            | [0.3.4](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                            |
| ixia-c-gnmi-server         | [1.12.4](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                        |
| ixia-c-one                 | [0.0.1-4435](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |
| `                          |                                                                                                                                            |

#### Bug Fix(s)

* `set_config` fails with `unsuccessful Response: RX runtime not configured for port: ` if large port testbed is used on subsequent test runs is fixed.

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4399

> 21st August, 2023

#### About

This build includes new features.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.12.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.12.1/artifacts/openapi.yaml) |
| snappi                     | [0.12.1](https://pypi.org/project/snappi/0.12.1)                                                                                              |
| gosnappi                   | [0.12.1](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.12.1)                                                        |
| ixia-c-controller          | [0.0.1-4399](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                     |
| ixia-c-traffic-engine      | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.320](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                     |
| ixia-c-ixhw-server         | [0.12.1-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                      |
| ixia-c-operator            | [0.3.4](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                            |
| ixia-c-gnmi-server         | [1.12.2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                        |
| ixia-c-one                 | [0.0.1-4399](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |
| `                          |                                                                                                                                            |

# Release Feature(s)

* Support for deprecated control, action and update APIs (`set_transmit_state`, `set_link_state`, `set_capture_state`, `update_flows`, `set_route_state`, `send_ping`, `set_protocol_state`, `set_device_state`) have been removed. Please use following `set_control_state`, `set_control_action` and `update_config` APIs instead of the previous ones. Please refer to [go utils](https://github.com/open-traffic-generator/conformance/commit/ecffd7edf93a4e60105a263cc7a074e2abe26ae4#diff-2f28df5cf5ed455b[…]c48b9ac5ef7ac25e5a018a) and [python utils](https://github.com/open-traffic-generator/conformance/commit/ecffd7edf93a4e60105a263cc7a074e2abe26ae4#diff-205d55e3f01484e637c6b5b597a6dfb44e74638964605a23b20d5fa72e773a38) for further details usage.
* Most properties in OTG with integer data type have been assigned correct integer format (from `uint32`, `uint64`, `int32` and `int64`). Please [click here](https://github.com/open-traffic-generator/models/pull/301) to examine all changes.
* Once you upgrade the new ixia-c release, in addition to removing the deprecated APIs from the test programs, data types of some variables in the test programs might need to be changed to avoid compilation errors.

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4306

> 4th August, 2023

#### About

This build includes stability fixes.

#### Build Details

| Component                  | Version                                                                                                                                      |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.11.11](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.11/artifacts/openapi.yaml) |
| snappi                     | [0.11.17](https://pypi.org/project/snappi/0.11.17)                                                                                              |
| gosnappi                   | [0.11.17](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.17)                                                        |
| ixia-c-controller          | [0.0.1-4306](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                       |
| ixia-c-traffic-engine      | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                     |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.318](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                       |
| ixia-c-ixhw-server         | [0.11.11-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                       |
| ixia-c-operator            | [0.3.4](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                              |
| ixia-c-gnmi-server         | [1.11.16](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                         |
| ixia-c-one                 | [0.0.1-4306](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |
| `                          |                                                                                                                                              |

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4167

> 21st July, 2023

#### About

This build includes new features.

#### Build Details

| Component                  | Version                                                                                                                                      |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.11.10](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.10/artifacts/openapi.yaml) |
| snappi                     | [0.11.16](https://pypi.org/project/snappi/0.11.16)                                                                                              |
| gosnappi                   | [0.11.16](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.16)                                                        |
| ixia-c-controller          | [0.0.1-4167](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                       |
| ixia-c-traffic-engine      | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                     |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.316](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                       |
| ixia-c-ixhw-server         | [0.11.10-13](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                      |
| ixia-c-operator            | [0.3.4](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                              |
| ixia-c-gnmi-server         | [1.11.16](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                         |
| ixia-c-one                 | [0.0.1-4167](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |

# Release Feature(s)

* Enabling `metric_tags` for egress tracking is now also supported on ipv6.src/dst, ipv6.traffic_class, ipv6.flow_label and ipv6.payload_length. `<b><i>`[Ixia-C]`</i></b>`
  ```go
    eth := flow.EgressPacket().Add().Ethernet()
    ipv6 := flow.EgressPacket().Add().Ipv6()
    ipv6Tag := ipv6.Dst().MetricTags().Add()
    ipv6Tag.SetName("flow_ipv6_dst")
    ipv6Tag.SetOffset(120)
    ipv6Tag.SetLength(8)
  ```
* Support is available in gNMI to fetch the drill-down statistics for egress tracking as follows `<b><i>`[Ixia-C]`</i></b>` [details](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-flow.txt):
  ```
    1. Flow level metrics + Tagged Metrics:
        example path: "flows/flow[name=f1]“
    2. Only Flow level metrics:
        example path: "flows/flow[name=f1]/state“
    3. Only Tagged metrics 
        example path: "flows/flow[name=f1]/tagged-metrics“
    4. Filtered Tagged metrics: 
        example path: "flows/flow[name=f1]/tagged-metrics/tagged-metric[name-value-pairs=flow_ipv6_dst=0x2]”
  ```

# Bug Fix(s)

* For `flow.duration.continuous` type of traffic in Ixia-C, intermittent issue where last few packets in a traffic flow were not accounted for in `flow_metrics.frames_rx` statistics after stopping a flow is fixed.
* Proper error mesage is propagated to user if user has used community edition of Ixia-C (instead of licensed edition) and invoked any API/Configuration not supported by it.
  example: `Device configuration is not supported in free version of controller.`

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4139

> 29th June, 2023

#### About

This build includes new features.

#### Build Details

| Component                  | Version                                                                                                                                      |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.11.10](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.10/artifacts/openapi.yaml) |
| snappi                     | [0.11.16](https://pypi.org/project/snappi/0.11.16)                                                                                              |
| gosnappi                   | [0.11.16](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.16)                                                        |
| ixia-c-controller          | [0.0.1-4139](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                       |
| ixia-c-traffic-engine      | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                     |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.315](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                       |
| ixia-c-ixhw-server         | [0.11.10-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                       |
| ixia-c-operator            | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                              |
| ixia-c-gnmi-server         | [1.11.16](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                         |
| ixia-c-one                 | [0.0.1-4139](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |

# Release Features(s)

* Support added for multiple Rx endpoints both port traffic.

  ```go
  // Port Traffic
  flow.SetName("flow:p1->p2,p3").
    TxRx().Port().
    SetTxName("p1").
    SetRxNames([]string{"p2", "p3"})
  ```
* Support added for Rx port disaggregation of flow metrics.

  ```go
  flow := config.Flows().Add().SetName("flow")
  flow.Metrics(). PredefinedMetricTags().SetRxName(true)
  ```

  ```json
  // gNMI state fetch on flows will show the drilldown as given below
  "updates": [
    {
    "Path": "flows/flow[name=f1]",
    "values": {
      "flows/flow": {
      "open-traffic-generator-flow:name": "f1",
      "open-traffic-generator-flow:state": {                     // Contains the aggregated per-flow stats
        ....
      },
      "open-traffic-generator-flow:tag-metrics": {              // Contains the disaggregated per-flow stats
        "tag-metric": [
        {
          "name-value": "rx_name=p2",
          "state": {
            ....
            "name-value": "rx_name=p2",
            "tags": [
              {
              "tag-name": "rx_name",
              "tag-value": 
                {
                  "value-as-string": "p2",
                  "value-type": "STRING"
                }
          ....
        },
        {
          "name-value": "rx_name=p3",
          "state": {
            ....
          }
        }
      ....
    }
  ]
  ```

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4124

> 16th June, 2023

#### About

This build includes new features.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.11.9](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.9/artifacts/openapi.yaml) |
| snappi                     | [0.11.15](https://pypi.org/project/snappi/0.11.14)                                                                                            |
| gosnappi                   | [0.11.15](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.14)                                                      |
| ixia-c-controller          | [0.0.1-4124](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                     |
| ixia-c-traffic-engine      | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.310](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                     |
| ixia-c-ixhw-server         | [0.11.9-6](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                      |
| ixia-c-operator            | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                            |
| ixia-c-gnmi-server         | [1.11.14](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                       |
| ixia-c-one                 | [0.0.1-4124](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |

# Release Features(s)

* Support added for weighted pairs for packet size distribution in traffic flows.
  - `predefined` packet size distributions supported are `imix`, `ipsec_imix`, `ipv6_imix`, `standard_imix`, `tcp_imix`. It can be configured as follows:
    ```go
      myFlow.Size().WeightPairs().SetPredefined(gosnappi.FlowSizeWeightPairsPredefined.IMIX)
    ```
  - Custom packet size distribution is also supported. It can configured as follows,
    ```go
      customWeightPairs := myFlow.Size().WeightPairs().Custom()
      customWeightPairs.Add().SetSize(64).SetWeight(7)
      customWeightPairs.Add().SetSize(570).SetWeight(4)
      customWeightPairs.Add().SetSize(1518).SetWeight(1)
    ```
* Support is added for egress tracking based on IPv4 total length.

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4080

> 2nd June, 2023

#### About

This build includes bug fix.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.11.9](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.9/artifacts/openapi.yaml) |
| snappi                     | [0.11.15](https://pypi.org/project/snappi/0.11.14)                                                                                            |
| gosnappi                   | [0.11.15](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.14)                                                      |
| ixia-c-controller          | [0.0.1-4080](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                     |
| ixia-c-traffic-engine      | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.02.21.29](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                     |
| ixia-c-ixhw-server         | [0.11.9-3](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                      |
| ixia-c-operator            | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                            |
| ixia-c-gnmi-server         | [1.11.14](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                       |
| ixia-c-one                 | [0.0.1-4080](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4064

> 18th May, 2023

#### About

This build includes bug fix.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.11.8](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.8/artifacts/openapi.yaml) |
| snappi                     | [0.11.14](https://pypi.org/project/snappi/0.11.14)                                                                                            |
| gosnappi                   | [0.11.14](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.14)                                                      |
| ixia-c-controller          | [0.0.1-4064](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                     |
| ixia-c-traffic-engine      | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.02.21.17](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                     |
| ixia-c-ixhw-server         | [0.11.8-12](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                     |
| ixia-c-operator            | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                            |
| ixia-c-gnmi-server         | [1.11.13](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                       |
| ixia-c-one                 | [0.0.1-4064](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |

# Bug Fix(s)

* [Stop exposing TLS 1.0/1.1 ](https://github.com/open-traffic-generator/ixia-c/issues/125) in `ixia-c-controller`.

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4013

> 5th May, 2023

#### About

This build includes new features.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.11.8](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.8/artifacts/openapi.yaml) |
| snappi                     | [0.11.14](https://pypi.org/project/snappi/0.11.14)                                                                                            |
| gosnappi                   | [0.11.14](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.14)                                                      |
| ixia-c-controller          | [0.0.1-4013](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                     |
| ixia-c-traffic-engine      | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.299](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                     |
| ixia-c-ixhw-server         | [0.11.8-8](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                      |
| ixia-c-operator            | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                            |
| ixia-c-gnmi-server         | [1.11.13](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                       |
| ixia-c-one                 | [0.0.1-4013](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |

# Release Features(s)

* Egress tracking now also supports tracking for `vlan`, `mpls` packet headers.
* Support added in `ixia-c-gnmi-server` for fetching Latency measurements.
  - User can enable latency measurement by setting `f1.Metrics().SetEnable(true).Latency().SetEnable(true)`.
    - Only `cut_through` latency mode  is supported.
  - User can fetch latency measurements using given models-yang path.
    ```
      module: open-traffic-generator-flow
      +--rw flows
        +--ro flow* [name]
            +--ro name              -> ../state/name
            +--ro state
            |  ....
            |  ....
            |  +--ro minimum-latency?   otg-types:timeticks64
            |  +--ro maximum-latency?   otg-types:timeticks64
            |  +--ro average-latency?   otg-types:timeticks64
            |  ....
            |  ....

    ```

# Bug Fix(s)

* Intermittent crash in ixia-c-controller while fetching `flow_metrics` is fixed.

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-3927

> 24th April, 2023

#### About

This build includes new features.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.11.8](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.8/artifacts/openapi.yaml) |
| snappi                     | [0.11.14](https://pypi.org/project/snappi/0.11.14)                                                                                            |
| gosnappi                   | [0.11.14](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.14)                                                      |
| ixia-c-controller          | [0.0.1-3927](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                     |
| ixia-c-traffic-engine      | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.298](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                     |
| ixia-c-ixhw-server         | [0.11.8-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                      |
| ixia-c-operator            | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                            |
| ixia-c-gnmi-server         | [1.11.10](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                       |
| ixia-c-one                 | [0.0.1-3927](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |

# Release Features(s)

* A new property `egress_packet` inside flow has been introduced to configure expected packet shape as it is received on the test port.
  ``go eth := flow.EgressPacket().Add().Ethernet() ipv4 := flow.EgressPacket().Add().Ipv4() ``
* A new property `metric_tags` has been introduced for fields inside headers configured in `egress_packet` to enable tracking metrics for each applicable value corresponding to a portion of or all bits inside the field.

  ```go
    ipv4Tag := ipv4.Dst().MetricTags().Add()
    ipv4Tag.SetName("flow_ipv4_dst")
    ipv4Tag.SetOffset(24)
    ipv4Tag.SetLength(8)
  ```

  - As of this release, enabling metric_tags is only supported on ethernet.src/dst, ipv4.src/dst, ipv4.tos. Support for more fields shall be added in upcoming releases.
  - Limitations:

    - The total number of tracking bits available on an ixia-c Rx port is 12 bits. Out of these some of the bits are needed for tracking flows, example 2 flows need 1 bit, 4 flows need 2 bits, 8 flows need 3 bits etc. The sum of `metric_tag.length` for each field inside each header configured in `egress_packet` cannot exceed the remaining bits available on the Rx port.
    - The total number of tracking fields that can be configured across a set of flows which have the same Rx port, is two.
* A new property is introduced in `get_metrics.flow` to fetch tagged metrics.

- User can set `get_metrics.flow.tagged_metrics.include=false` not to include `tagged_metrics` in the `flow_metrics` response.
- Specific `tagged_metrics` can be fetched by setting `get_metrics.flow.tagged_metrics.filters[i].name`.

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-3889

> 31st March, 2023

#### About

This build includes new features.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.11.4](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.4/artifacts/openapi.yaml) |
| snappi                     | [0.11.6](https://pypi.org/project/snappi/0.11.6)                                                                                              |
| gosnappi                   | [0.11.6](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.6)                                                        |
| ixia-c-controller          | [0.0.1-3889](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                     |
| ixia-c-traffic-engine      | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.290](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                     |
| ixia-c-ixhw-server         | [0.11.4-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                      |
| ixia-c-operator            | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                            |
| ixia-c-gnmi-server         | [1.11.5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                        |
| ixia-c-one                 | [0.0.1-3889](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |

### Features(s)

* All API response errors over gRPC and HTTP transport can now be inspected like so:

  ```snappi
      # snippet of error handling in snappi
      try:
      # call set config
      api.set_config(payload)
      except Exception as e:
          err = api.from_exception(e)  # helper function to parse exception
          if err is not None: # exception was of otg error format
              print(err.code)
              print(err.errors)
          else: # some other exception
              print(e)
  ```

  ```gosnappi
      // gosnappi snippet for error handling
      resp, err := api.SetConfig(config)
      if err != nil {
          // helper function to parse error
          // retuns a bool with err, indicating wheather the error was of otg error format 
          errSt, ok := api.FromError(err)
          if ok {
              fmt.Println(errSt.Code())
              if errSt.errSt.HasKind() {
              fmt.Println(errSt.Kind())
              }
              fmt.Println(errSt.Errors())
          } else {
              fmt.Println(err.Error())
          }
      }
  ```

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-3865

> 16th March, 2023

#### About

This build includes new features.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.11.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.1/artifacts/openapi.yaml) |
| snappi                     | [0.11.1](https://pypi.org/project/snappi/0.11.1)                                                                                              |
| gosnappi                   | [0.11.1](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.1)                                                        |
| ixia-c-controller          | [0.0.1-3865](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                     |
| ixia-c-traffic-engine      | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.283](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                     |
| ixia-c-ixhw-server         | [0.11.1-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                      |
| ixia-c-operator            | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                            |
| ixia-c-gnmi-server         | [1.11.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                        |
| ixia-c-one                 | [0.0.1-3865](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |

### Features(s)

* Warning messages shall now be automatically printed on STDOUT if a property or an API with status deprecated or under-review is exercised in `snappi` / `gosnappi`. This may also lead to linters raising deprecation error.
* New API endpoints `/control/state` and `/control/action` have been exposed consolidating pre-existing API endpoints inside `/control/` (now deprecated) in order to reduce API surface and introducing clean organization. Please see [snappi-tests utils](https://github.com/open-traffic-generator/snappi-tests/blob/main/tests/utils/common.py) for usage.
* API endpoints `/results/*` have now been renamed to `/monitor/*` .

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-3841

> 3rd March, 2023

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages), We stopped publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom).

#### About

This build includes new features.

#### Build Details

| Component                  | Version                                                                                                                                      |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.10.12](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.10.12/artifacts/openapi.yaml) |
| snappi                     | [0.10.9](https://pypi.org/project/snappi/0.10.9)                                                                                                |
| gosnappi                   | [0.10.9](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.10.9)                                                          |
| ixia-c-controller          | [0.0.1-3841](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                       |
| ixia-c-traffic-engine      | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                     |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                                 |
| ixia-c-protocol-engine     | [1.00.0.279](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                       |
| ixia-c-ixhw-server         | [0.10.12-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                       |
| ixia-c-operator            | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                              |
| ixia-c-gnmi-server         | [1.10.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                         |
| ixia-c-one                 | [0.0.1-3841](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                             |

### Features(s)

* API version compatibility check is now automatically performed between ixia-c containers upon API calls to `ixia-c-controller` . It can be disabled by booting `ixia-c-controller` container with `--disable-version-check` flag.
* API version compatibility check can now be automatically performed between `snappi`/`gosnappi` and ixia-c-controller upon API calls by enabling version check flag in API handle like so:

  - gosnappi

  ```
      api := gosnappi.NewApi()
      api.SetVersionCompatibilityCheck(true)
  ```

  - snappi

  ```
      api = snappi.api(version_check=True)
  ```

  In upcoming releases, this will be enabled by default.

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-3807

> 17th February, 2023

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages), We stopped publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom).

#### About

This build contains bug fixes.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.10.9](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.10.9/artifacts/openapi.yaml) |
| snappi                     | [0.10.7](https://pypi.org/project/snappi/0.10.7)                                                                                              |
| gosnappi                   | [0.10.7](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.10.7)                                                        |
| ixia-c-controller          | [0.0.1-3807](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                     |
| ixia-c-traffic-engine      | [1.6.0.30](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.271](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                     |
| ixia-c-ixhw-server         | [0.10.7-8](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                      |
| ixia-c-operator            | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                            |
| ixia-c-gnmi-server         | [1.10.14](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                       |
| ixia-c-one                 | [0.0.1-3807](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |

### Bug Fix(s)

* Concurrent API calls (where at least one call was `set_config`) to `ixia-c-controller` was resulting in crash.

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-3767

> 2nd February, 2023

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages), We stopped publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom).

#### About

This build contains bug fixes.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.10.7](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.10.7/artifacts/openapi.yaml) |
| snappi                     | [0.10.5](https://pypi.org/project/snappi/0.10.5)                                                                                              |
| gosnappi                   | [0.10.5](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.10.5)                                                        |
| ixia-c-controller          | [0.0.1-3768](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                     |
| ixia-c-traffic-engine      | [1.6.0.29](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.271](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                     |
| ixia-c-ixhw-server         | [0.10.7-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                      |
| ixia-c-operator            | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                            |
| ixia-c-gnmi-server         | [1.10.8](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                        |
| ixia-c-one                 | [0.0.1-3768](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |

### Bug Fix(s)

* Issue where TCP header length was not set correctly is fixed. [#117](https://github.com/open-traffic-generator/ixia-c/issues/117)

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-3724

> 20th January, 2023

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages), We stopped publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom).

#### About

This build contains bug fixes.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.10.6](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.10.6/artifacts/openapi.yaml) |
| snappi                     | [0.10.4](https://pypi.org/project/snappi/0.10.4)                                                                                              |
| gosnappi                   | [0.10.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.10.4)                                                        |
| ixia-c-controller          | [0.0.1-3724](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                     |
| ixia-c-traffic-engine      | [1.6.0.24](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.256](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                     |
| ixia-c-ixhw-server         | [0.10.6-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)                                      |
| ixia-c-operator            | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                            |
| ixia-c-gnmi-server         | [1.10.6](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                        |
| ixia-c-one                 | [0.0.1-3722](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |

### Bug Fix(s)

* Payload size field in all inner headers for tunneling protocols do not take into account inner FCS is fixed. [#112](https://github.com/open-traffic-generator/ixia-c/issues/112)

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.0.1-3698

> 15th December, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages), We stopped publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom).

#### About

This build contains stability fixes.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.10.5](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.10.5/artifacts/openapi.yaml) |
| snappi                     | [0.10.3](https://pypi.org/project/snappi/0.10.3)                                                                                              |
| gosnappi                   | [0.10.3](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.10.3)                                                        |
| ixia-c-controller          | [0.0.1-3698](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                     |
| ixia-c-traffic-engine      | [1.6.0.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.252](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                     |
| ixia-c-operator            | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                            |
| ixia-c-gnmi-server         | [1.10.5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                        |
| ixia-c-one                 | [0.0.1-3698](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.0.1-3662

> 1st December, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### Build Details

| Component                  | Version                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Open Traffic Generator API | [0.9.10](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.10/artifacts/openapi.yaml) |
| snappi                     | [0.9.8](https://pypi.org/project/snappi/0.9.8)                                                                                                |
| gosnappi                   | [0.9.8](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.8)                                                          |
| ixia-c-controller          | [0.0.1-3662](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                     |
| ixia-c-traffic-engine      | [1.6.0.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                   |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                               |
| ixia-c-protocol-engine     | [1.00.0.243](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                     |
| ixia-c-operator            | [0.3.0](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                            |
| ixia-c-gnmi-server         | [1.9.9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                         |
| ixia-c-one                 | [0.0.1-3662](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                           |

### Features(s)

* `ixia-c-controller` now runs with a non-root user inside the container (instead of root user previously)
* `ixia-c-controller` now listens on non-privileged HTTPs port 8443 (instead of 443 previously)

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.0.1-3619

> 10th November, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.9.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.1/artifacts/openapi.yaml) |
| snappi                     | [0.9.4](https://pypi.org/project/snappi/0.9.4)                                                                                              |
| gosnappi                   | [0.9.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.4)                                                        |
| ixia-c-controller          | [0.0.1-3619](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                   |
| ixia-c-traffic-engine      | [1.6.0.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                 |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                             |
| ixia-c-protocol-engine     | [1.00.0.238](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                   |
| ixia-c-operator            | [0.2.6](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                          |
| ixia-c-gnmi-server         | [1.9.7](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                       |
| ixia-c-one                 | [0.0.1-3619](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                         |

### Features(s)

* `ixia-c-controller` and `ixia-c-gnmi-server` can now accept the environment variables `HTTP_PORT` and `HTTP_SERVER` respectively, overriding the values provided for corresponding arguments `--http-port` and `--http-server`.
* `ixia-c-controller` and `ixia-c-gnmi-server` can now be run using an arbitrary UID (user ID), to support deployment in OpenShift environment.

#### Bug Fix(s)

* Fixed [#15](https://github.com/open-traffic-generator/ixia-c-operator/issues/15).

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.0.1-3587

> 28th October, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### About

This build contains bug fixes.

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.9.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.1/artifacts/openapi.yaml) |
| snappi                     | [0.9.4](https://pypi.org/project/snappi/0.9.4)                                                                                              |
| gosnappi                   | [0.9.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.4)                                                        |
| ixia-c-controller          | [0.0.1-3587](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                   |
| ixia-c-traffic-engine      | [1.6.0.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                 |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                             |
| ixia-c-protocol-engine     | [1.00.0.236](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                   |
| ixia-c-operator            | [0.2.5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                          |
| ixia-c-gnmi-server         | [1.9.5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                       |
| ixia-c-one                 | [0.0.1-3587](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                         |

#### Bug Fix(s)

* [#101](https://github.com/open-traffic-generator/ixia-c/issues/101) fixed.

#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.0.1-3423

> 29th September, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### About

This build contains stability fixes.

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.9.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.1/artifacts/openapi.yaml) |
| snappi                     | [0.9.4](https://pypi.org/project/snappi/0.9.4)                                                                                              |
| gosnappi                   | [0.9.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.4)                                                        |
| ixia-c-controller          | [0.0.1-3423](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                   |
| ixia-c-traffic-engine      | [1.6.0.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                 |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                             |
| ixia-c-protocol-engine     | [1.00.0.232](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                   |
| ixia-c-operator            | [0.2.2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                          |
| ixia-c-gnmi-server         | [1.9.5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                       |
| ixia-c-one                 | [0.0.1-3423](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                         |

#### Known Limitations

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.0.1-3383

> 16th September, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.9.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.1/artifacts/openapi.yaml) |
| snappi                     | [0.9.4](https://pypi.org/project/snappi/0.9.4)                                                                                              |
| gosnappi                   | [0.9.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.4)                                                        |
| ixia-c-controller          | [0.0.1-3383](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                   |
| ixia-c-traffic-engine      | [1.6.0.17](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                 |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                             |
| ixia-c-protocol-engine     | [1.00.0.225](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                   |
| ixia-c-operator            | [0.2.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                          |
| ixia-c-gnmi-server         | [1.9.3](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                       |
| ixia-c-one                 | [0.0.1-3380](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                         |

#### Release Features(s)

* Support added for `increment` and `decrement` `values` in all `MPLS` packet header fields.
* Support added for raw traffic where `tx` and `rx` endpoints could be same.
* Support added in `traffic-engine-service` deployment to disable IPv6 networking.
  - `OPT_ENABLE_IPv6` environment flag is introduced. If it is `Yes` ipv6 networking will be enabled and if it is `No` ipv6 networking status will be unchanged.

#### Bug Fix(s)

* `get_config` is failing, if config contains TCP header. it is fixed now. [#184](https://github.com/open-traffic-generator/snappi/issues/184)

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets

## Release  v0.0.1-3182 (Latest)

> 1st September, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.9.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.1/artifacts/openapi.yaml) |
| snappi                     | [0.9.3](https://pypi.org/project/snappi/0.9.3)                                                                                              |
| gosnappi                   | [0.9.3](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.3)                                                        |
| ixia-c-controller          | [0.0.1-3182](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                   |
| ixia-c-traffic-engine      | [1.6.0.9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                  |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                             |
| ixia-c-protocol-engine     | [1.00.0.217](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                   |
| ixia-c-operator            | [0.2.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                          |
| ixia-c-gnmi-server         | [1.9.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                       |
| ixia-c-one                 | [0.0.1-3182](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                         |

#### Release Features(s)

* `ixia-c-controller` container now supports gRPC requests on default TCP port 40051 (alongside TCP port 8443 for HTTP) and hence `ixia-c-grpc-server` container is no longer needed.
* There has been a breaking change in OTG API to provide stronger compatibility guarantees across different `semver patch versions` of snappi and ixia-c-controller.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets

## Release  v0.0.1-3113

> 18th August, 2022

#### Announcement

From now onwards `ixia-c` container images will be hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) as well for the next 3 months. (until 18th November, 2022)

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.8.6](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.6/artifacts/openapi.yaml) |
| snappi                     | [0.8.8](https://pypi.org/project/snappi/0.8.8)                                                                                              |
| gosnappi                   | [0.8.8](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.8)                                                        |
| ixia-c-controller          | [0.0.1-3113](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)                                   |
| ixia-c-traffic-engine      | [1.6.0.9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)                                  |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)                             |
| ixia-c-protocol-engine     | [1.00.0.214](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)                   |
| ixia-c-operator            | [0.1.95](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)                                         |
| ixia-c-gnmi-server         | [1.8.13](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)                                      |
| ixia-c-grpc-server         | [0.8.9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-grpc-server)                                       |
| ixia-c-one                 | [0.0.1-3113](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                         |

#### Release Features(s)

* Support added for setting transmit state on subset of configured flows.
  https://github.com/open-traffic-generator/ixia-c/issues/56

#### Bug Fix(s)

* When flow duration is configured using `fixed_seconds`, then in some cases packet transmission does not stop after specified duration has elapsed.
  https://github.com/open-traffic-generator/ixia-c/issues/95

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets

## Release  v0.0.1-3027

> 4th August, 2022

#### About

Support added for static `MPLS` packet header in flows.

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.8.6](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.6/artifacts/openapi.yaml) |
| snappi                     | [0.8.8](https://pypi.org/project/snappi/0.8.8)                                                                                              |
| gosnappi                   | [0.8.8](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.8)                                                        |
| ixia-c-controller          | [0.0.1-3027](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                       |
| ixia-c-traffic-engine      | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                                     |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                                 |
| ixia-c-protocol-engine     | 1.00.0.209                                                                                                                               |
| ixia-c-operator            | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                             |
| ixia-c-gnmi-server         | [1.8.10](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                          |
| ixia-c-grpc-server         | [0.8.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                           |
| ixia-c-one                 | [0.0.1-3027](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                         |

#### Release Features(s)

* Support added for static `MPLS` packet header in flows.
  - Fixed value is supported for all fields.
  - Dynamic `MPLS` is not supported yet.
    - `label` field's  default choice is `value` if it is selected as `auto`.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-3002

> 27th July, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.8.5](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.5/artifacts/openapi.yaml) |
| snappi                     | [0.8.5](https://pypi.org/project/snappi/0.8.5)                                                                                              |
| gosnappi                   | [0.8.5](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.5)                                                        |
| ixia-c-controller          | [0.0.1-3002](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                       |
| ixia-c-traffic-engine      | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                                     |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                                 |
| ixia-c-protocol-engine     | 1.00.0.205                                                                                                                               |
| ixia-c-operator            | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                             |
| ixia-c-gnmi-server         | [1.8.8](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                           |
| ixia-c-grpc-server         | [0.8.7](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                           |
| ixia-c-one                 | [0.0.1-3002](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-3000

> 21st July, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.8.5](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.5/artifacts/openapi.yaml) |
| snappi                     | [0.8.5](https://pypi.org/project/snappi/0.8.5)                                                                                              |
| gosnappi                   | [0.8.5](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.5)                                                        |
| ixia-c-controller          | [0.0.1-3000](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                       |
| ixia-c-traffic-engine      | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                                     |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                                 |
| ixia-c-protocol-engine     | 1.00.0.203                                                                                                                               |
| ixia-c-operator            | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                             |
| ixia-c-gnmi-server         | [1.8.8](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                           |
| ixia-c-grpc-server         | [0.8.7](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                           |
| ixia-c-one                 | [0.0.1-3000](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2994

> 1st July, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.8.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.1/artifacts/openapi.yaml) |
| snappi                     | [0.8.2](https://pypi.org/project/snappi/0.8.2)                                                                                              |
| gosnappi                   | [0.8.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.2)                                                        |
| ixia-c-controller          | [0.0.1-2994](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                       |
| ixia-c-traffic-engine      | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                                     |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                                 |
| ixia-c-protocol-engine     | 1.00.0.192                                                                                                                               |
| ixia-c-operator            | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                             |
| ixia-c-gnmi-server         | [1.8.3](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                           |
| ixia-c-grpc-server         | [0.8.2](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                           |
| ixia-c-one                 | [0.0.1-2994](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2992

> 30th June, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                  | Version                                                                                                                                  |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.8.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.1/artifacts/openapi.yaml) |
| snappi                     | [0.8.2](https://pypi.org/project/snappi/0.8.2)                                                                                              |
| gosnappi                   | [0.8.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.2)                                                        |
| ixia-c-controller          | [0.0.1-2992](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                       |
| ixia-c-traffic-engine      | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                                     |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                                 |
| ixia-c-protocol-engine     | 1.00.0.191                                                                                                                               |
| ixia-c-operator            | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                             |
| ixia-c-gnmi-server         | [1.8.3](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                           |
| ixia-c-grpc-server         | [0.8.2](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                           |
| ixia-c-one                 | [0.0.1-2992](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2969

> 16th June, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                  | Version                                                                                                                             |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.7.15](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.15/openapi.yaml) |
| snappi                     | [0.7.41](https://pypi.org/project/snappi/0.7.41)                                                                                       |
| gosnappi                   | [0.7.41](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.41)                                                 |
| ixia-c-controller          | [0.0.1-2969](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                  |
| ixia-c-traffic-engine      | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                                |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                            |
| ixia-c-protocol-engine     | 1.00.0.181                                                                                                                          |
| ixia-c-operator            | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                        |
| ixia-c-gnmi-server         | [1.7.31](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                     |
| ixia-c-grpc-server         | [0.7.17](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                     |
| ixia-c-one                 | [0.0.1-2969](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                    |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2934

> 2nd June, 2022

#### About

This build contains bug fixes.

#### Build Details

| Component                  | Version                                                                                                                             |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.7.13](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.13/openapi.yaml) |
| snappi                     | [0.7.37](https://pypi.org/project/snappi/0.7.37)                                                                                       |
| gosnappi                   | [0.7.37](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.37)                                                 |
| ixia-c-controller          | [0.0.1-2934](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                  |
| ixia-c-traffic-engine      | [1.4.1.26](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                                |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                            |
| ixia-c-protocol-engine     | 1.00.0.174                                                                                                                          |
| ixia-c-operator            | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                        |
| ixia-c-gnmi-server         | [1.7.27](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                     |
| ixia-c-grpc-server         | [0.7.15](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                     |
| ixia-c-one                 | [0.0.1-2934](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                    |

#### Bug Fix(s)

* `ixia-c-controller` will return an empty response instead of error when `metrics` / `states` are queried right after boot-up.
* `ixia-c-gnmi-server` will return an empty response instead of error when `metrics` / `states` are queried without ever setting config

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2897

> 19th May, 2022

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml) |
| snappi                     | [0.7.18](https://pypi.org/project/snappi/0.7.18)                                                                                     |
| gosnappi                   | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)                                               |
| ixia-c-controller          | [0.0.1-2897](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.4.1.26](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                              |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.165                                                                                                                        |
| ixia-c-operator            | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                      |
| ixia-c-gnmi-server         | [1.7.23](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                   |
| ixia-c-grpc-server         | [0.7.12](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                   |
| ixia-c-one                 | [0.0.1-2897](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)                                  |

#### New Feature(s)

* `ixia-c-one` is now supported on platforms with `cgroupv2` enabled. https://github.com/open-traffic-generator/ixia-c/issues/77

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2801

> 9th May, 2022

#### About

This build includes stability fixes.

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml) |
| snappi                     | [0.7.18](https://pypi.org/project/snappi/0.7.18)                                                                                     |
| gosnappi                   | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)                                               |
| ixia-c-controller          | [0.0.1-2801](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.4.1.26](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                              |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.158                                                                                                                        |
| ixia-c-operator            | [0.1.89](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                      |
| ixia-c-gnmi-server         | [1.7.15](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                   |
| ixia-c-grpc-server         | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                    |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2790

> 5th May, 2022

#### About

This build includes stability fixes.

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml) |
| snappi                     | [0.7.18](https://pypi.org/project/snappi/0.7.18)                                                                                     |
| gosnappi                   | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)                                               |
| ixia-c-controller          | [0.0.1-2790](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.4.1.26](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                              |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.158                                                                                                                        |
| ixia-c-operator            | [0.0.80](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                      |
| ixia-c-gnmi-server         | [1.7.15](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                   |
| ixia-c-grpc-server         | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                    |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2770

> 21st April, 2022

#### About

This build includes stability fixes.

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml) |
| snappi                     | [0.7.18](https://pypi.org/project/snappi/0.7.18)                                                                                     |
| gosnappi                   | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)                                               |
| ixia-c-controller          | [0.0.1-2770](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.0.0.275](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                             |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.154                                                                                                                        |
| ixia-c-operator            | [0.0.80](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                      |
| ixia-c-gnmi-server         | [1.7.13](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                   |
| ixia-c-grpc-server         | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                    |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2755

> 7th April, 2022

#### About

This build includes following bug fix

- Clearing of `port` and `flow` statistics as part of `set_config`.

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml) |
| snappi                     | [0.7.18](https://pypi.org/project/snappi/0.7.18)                                                                                     |
| gosnappi                   | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)                                               |
| ixia-c-controller          | [0.0.1-2755](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.4.1.23](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                              |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.152                                                                                                                        |
| ixia-c-operator            | [0.0.75](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                      |
| ixia-c-gnmi-server         | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                    |
| ixia-c-grpc-server         | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                    |

#### Bug Fix(s)

* Clearing of `port` and `flow` statistics is now part of `set_config`.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2738

> 25th March, 2022

#### About

This build includes following new functionalities

- fix in handling of `ether_type` field of ethernet packet

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml) |
| snappi                     | [0.7.18](https://pypi.org/project/snappi/0.7.18)                                                                                     |
| gosnappi                   | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)                                               |
| ixia-c-controller          | [0.0.1-2738](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.4.1.23](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                              |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.151                                                                                                                        |
| ixia-c-operator            | [0.0.75](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                      |
| ixia-c-gnmi-server         | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                    |
| ixia-c-grpc-server         | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                    |

#### New Feature(s)

* Users would be able to set `ether_type` in ethernet header which may not be based on the next header type.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2727

> 24th March, 2022

#### About

This build includes following new functionalities

- correct received(rx) rate statistics in port metrics
- auto destination mac learning support in destination mac field of ethernet packet

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml) |
| snappi                     | [0.7.18](https://pypi.org/project/snappi/0.7.18)                                                                                     |
| gosnappi                   | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)                                               |
| ixia-c-controller          | [0.0.1-2727](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.4.1.23](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                              |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.151                                                                                                                        |
| ixia-c-operator            | [0.0.75](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                      |
| ixia-c-gnmi-server         | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                    |
| ixia-c-grpc-server         | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                    |

#### New Feature(s)

* Correct received(rx) rate statistics support is incorporated as part of port metrics.

  * `frames_rx_rate`
  * `bytes_rx_rate`
* [Breaking Change] Auto learning of destination MAC is currently supported for both IPv4 and IPv6 Flows without any VLAN(originated from device endpoints) by setting ethernet destination with `choice` as `auto` in the packet. Earlier this was working by setting ethernet destination mac with "00:00:00:00:00:00" in the packet header.

  ```
      {
          "choice": "ethernet",
          "ethernet": {
              "dst": {
                  "choice": "auto"
              },
              "src": {
                  "choice": "value",
                  "value": "00:00:01:01:01:01"
              }
          }
      },
  ```

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2678

> 11th March, 2022

#### About

This build contains stability and debuggability enhancements.

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.7.3](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.3/openapi.yaml) |
| snappi                     | [0.7.13](https://pypi.org/project/snappi/0.7.13)                                                                                     |
| gosnappi                   | [0.7.13](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.13)                                               |
| ixia-c-controller          | [0.0.1-2678](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.4.1.23](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                              |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.146                                                                                                                        |
| ixia-c-operator            | [0.0.75](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                      |
| ixia-c-gnmi-server         | [0.7.5](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                    |
| ixia-c-grpc-server         | [0.7.7](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                    |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2662

> 24th February, 2022

#### About

This build implements transmit(tx) statistics & transmit state of flow metrics.

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.7.3](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.3/openapi.yaml) |
| snappi                     | [0.7.13](https://pypi.org/project/snappi/0.7.13)                                                                                     |
| gosnappi                   | [0.7.13](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.13)                                               |
| ixia-c-controller          | [0.0.1-2662](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.4.1.23](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                              |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.144                                                                                                                        |
| ixia-c-operator            | [0.0.75](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                      |
| ixia-c-gnmi-server         | [0.7.5](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                    |
| ixia-c-grpc-server         | [0.7.6](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                    |

#### New Feature(s)

* Transmit(tx) statistics & Transmit state support is incorporated as part of flow metrics.
  * `transmit`
  * `frames_tx`
  * `frames_tx_rate`

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2610

> 10th February, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.7.3](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.3/openapi.yaml) |
| snappi                     | [0.7.13](https://pypi.org/project/snappi/0.7.13)                                                                                     |
| gosnappi                   | [0.7.13](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.13)                                               |
| ixia-c-controller          | [0.0.1-2610](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.4.1.5](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                               |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.133                                                                                                                        |
| ixia-c-operator            | [0.0.72](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                      |
| ixia-c-gnmi-server         | [0.7.5](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                    |
| ixia-c-grpc-server         | [0.7.5](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                    |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2597

> 27th January, 2022

#### About

This build contains debuggability enhancements.

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.7.2](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.2/openapi.yaml) |
| snappi                     | [0.7.6](https://pypi.org/project/snappi/0.7.6)                                                                                       |
| gosnappi                   | [0.7.6](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.6)                                                 |
| ixia-c-controller          | [0.0.1-2597](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.4.1.2](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                               |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.133                                                                                                                        |
| ixia-c-operator            | [0.0.70](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                      |
| ixia-c-gnmi-server         | [0.7.4](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                    |
| ixia-c-grpc-server         | [0.7.4](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                    |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2543

> 16th December, 2021

#### About

This build contains stability fixes.

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.7.2](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.2/openapi.yaml) |
| snappi                     | [0.7.3](https://pypi.org/project/snappi/0.7.3)                                                                                       |
| gosnappi                   | [0.7.3](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.3)                                                 |
| ixia-c-controller          | [0.0.1-2543](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.4.1.2](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                               |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.127                                                                                                                        |
| ixia-c-operator            | [0.0.70](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                      |
| ixia-c-gnmi-server         | [0.7.2](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                    |
| ixia-c-grpc-server         | [0.7.2](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                    |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2446

> 2nd December, 2021

#### About

This build introduces ability to return large `FramesTx/RX` values by `metric` APIs.

#### Build Details

| Component                  | Version                                                                                                                             |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.6.13](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.13/openapi.yaml) |
| snappi                     | [0.6.21](https://pypi.org/project/snappi/0.6.21)                                                                                       |
| gosnappi                   | [0.6.21](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.6.21)                                                 |
| ixia-c-controller          | [0.0.1-2446](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                  |
| ixia-c-traffic-engine      | [1.4.0.15](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                                |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                            |
| ixia-c-protocol-engine     | 1.00.0.115                                                                                                                          |
| ixia-c-operator            | [0.0.70](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                        |
| ixia-c-gnmi-server         | [0.6.18](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                     |
| ixia-c-grpc-server         | [0.6.17](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                     |

#### New Feature(s)

* Maximum `FramesTx` and `FramesRx` value that can be correctly returned by `flow_metrics` and `port_metrics` has been increased from 2147483648 to 9.223372e+18

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2399

> 18th November, 2021

#### About

This build introduces ability to auto plug in default values for missing fields with primitive types upon receiving JSON payload.

#### Build Details

| Component                  | Version                                                                                                                             |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.6.10](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.10/openapi.yaml) |
| snappi                     | [0.6.16](https://pypi.org/project/snappi/0.6.16)                                                                                       |
| gosnappi                   | [0.6.16](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.6.16)                                                 |
| ixia-c-controller          | [0.0.1-2399](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                  |
| ixia-c-traffic-engine      | [1.4.0.15](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                                |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                            |
| ixia-c-protocol-engine     | 1.00.0.111                                                                                                                          |
| ixia-c-operator            | [0.0.70](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)                                                                        |
| ixia-c-gnmi-server         | [0.6.14](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)                                                                     |
| ixia-c-grpc-server         | [0.6.15](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)                                                                     |

#### New Feature(s)

* Upon receiving JSON payload, ixia-c-controller will now automatically plug in default values for missing fields with primitive types.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2367

> 5th November, 2021

#### About

This build introduces uniform logging across some Ixia-c components.

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.6.7](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.7/openapi.yaml) |
| snappi                     | [0.6.12](https://pypi.org/project/snappi/0.6.12)                                                                                     |
| gosnappi                   | [0.6.12](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.6.12)                                               |
| ixia-c-controller          | [0.0.1-2367](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.4.0.15](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                              |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.96                                                                                                                         |
| ixia-c-operator            | 0.0.1-65                                                                                                                          |
| ixia-c-gnmi-server         | [0.6.11](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)                                                                  |
| ixia-c-grpc-server         | [0.6.11](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)                                                                  |

#### Bug Fix(s)

* Introduced structured logging for `ixia-c-gnmi-server` and `ixia-c-grpc-server` to aid uniform logging across Ixia-c components.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2342

> 27th October, 2021

#### About

This build contains validation bug fixes.

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.6.5](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.5/openapi.yaml) |
| snappi                     | [0.6.5](https://pypi.org/project/snappi/0.6.5)                                                                                       |
| gosnappi                   | [0.6.5](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.6.5)                                                 |
| ixia-c-controller          | [0.0.1-2342](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.4.0.15](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                              |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.83                                                                                                                         |
| ixia-c-operator            | 0.0.1-65                                                                                                                          |
| ixia-c-gnmi-server         | [0.6.6](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)                                                                   |
| ixia-c-grpc-server         | [0.6.6](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)                                                                   |

#### Bug Fix(s)

* Validation has been fixed for traffic configuration consisting of IPv4 and IPv6 interface names

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2337

> 21st October, 2021

#### About

This build contains bugfixes for SetConfig and FPS values in GetMetrics.

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.6.5](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.5/openapi.yaml) |
| snappi                     | [0.6.5](https://pypi.org/project/snappi/0.6.5)                                                                                       |
| gosnappi                   | [0.6.5](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.6.5)                                                 |
| ixia-c-controller          | [0.0.1-2337](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.4.0.14](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                              |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.83                                                                                                                         |
| ixia-c-operator            | 0.0.1-65                                                                                                                          |
| ixia-c-gnmi-server         | [0.6.6](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)                                                                   |
| ixia-c-grpc-server         | [0.6.6](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)                                                                   |

#### New Feature(s)

* The race condition during connection initialization in `SetConfig` is fixed for scenarios involving large port count.
* FPS value in `GetMetrics` for ports and flows is fixed for scenarios involving multiple consecutive SetTransmitState calls.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2289

> 29th September, 2021

#### About

This build contains support for performance optimisation through concurrent port operations.

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.6.1](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.1/openapi.yaml) |
| snappi                     | [0.6.1](https://pypi.org/project/snappi/0.6.1)                                                                                       |
| ixia-c-controller          | [0.0.1-2289](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.4.0.13](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                              |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.70                                                                                                                         |
| otg-gnmi-server            | [0.6.1](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)                                                                   |
| otg-grpc-server            | [0.6.1](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)                                                                   |

#### New Feature(s)

* Performance is optimised through concurrent port operations.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2185

> 8th September, 2021

#### About

This build contains support for updating flow rate without disrupting transmit state.

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.5.4](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.5.4/openapi.yaml) |
| snappi                     | [0.5.3](https://pypi.org/project/snappi/0.5.3)                                                                                       |
| ixia-c-controller          | [0.0.1-2185](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                |
| ixia-c-traffic-engine      | [1.4.0.11](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                              |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                          |
| ixia-c-protocol-engine     | 1.00.0.56                                                                                                                         |
| otg-gnmi-server            | [0.5.2](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)                                                                   |
| otg-grpc-server            | [0.5.3](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)                                                                   |

#### New Feature(s)

* Updating flow rate without disrupting transmit state is now supported. Rate of multiple flows can be updated simultaneously through `update_flows` api without stopping the traffic.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2120

> 27th August, 2021

#### About

This build contains support for capture filter, setting GRE checksum flag, redirecting Ixia-c controller log to stdout and some bug fixes.

#### Build Details

| Component                  | Version                                                                                                                             |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.4.12](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.4.12/openapi.yaml) |
| snappi                     | [0.4.25](https://pypi.org/project/snappi/0.4.25)                                                                                       |
| ixia-c-controller          | [0.0.1-2120](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)                                                                  |
| ixia-c-traffic-engine      | [1.4.0.9](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)                                                                 |
| ixia-c-app-usage-reporter  | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)                                                            |
| ixia-c-protocol-engine     | 1.00.0.50                                                                                                                           |
| otg-gnmi-server            | [0.4.4](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)                                                                     |
| otg-grpc-server            | [0.0.9](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)                                                                     |

#### New Feature(s)

* Capture filters are now supported. Multiple patterns can be specified in the configuration.
* Controller log is now redirected to stdout. `docker logs` can now be used to access Ixia-c controller logs.
* Checksum field in `GRE` header now can be set.

#### Bug Fixes

* All patterns of IPv6 value now can be set for `increment` and `decrement` properties in flow header fields.
* Default value of step for `decrement` properties in flow header fields is now set correctly.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-1622

> 25th June, 2021

#### About

This build contains support for protocols GRE and VXLAN (RFC 2784), enabling/disabling flow metrics and some bug fixes.

#### Build Details

| Component                  | Version                                                                                                                           |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.4.0](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.4.0/openapi.yaml) |
| snappi                     | 0.4.0                                                                                                                             |
| ixia-c-controller          | 0.0.1-1622                                                                                                                        |
| ixia-c-traffic-engine      | 1.4.0.1                                                                                                                           |
| ixia-c-app-usage-reporter  | 0.0.1-36                                                                                                                          |

#### New Feature(s)

* Flow header configuration for protocols `GRE` and `VXLAN (RFC 2784)` are now supported.
* Flow metrics is now disabled by default to allow transmitting packets with `unaltered payload `(i.e. without any timestamps and instrumentation bytes embedded in it).
* Flow metrics (including metrics that are its sub-properties, e.g. `latency` and `timestamp`) can now be explicitly enabled on per-flow basis.

#### Bug Fixes

* `ixia-c-controller` can now safely serve multiple parallel requests from different clients preventing any undefined behavior.
* Port metrics can now be fetched for ports which are not part of flow configuration.
* Providing port locations for `ixia-c-traffic-engine` running in unsupported mode will now throw a user-friendly error.
* Default values for `increment` and `decrement` properties in flow header fields are now aligned per Open Traffic Generator API.

#### Known Issues

* Checksum field in `GRE` header currently cannot be set.
* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-1388

> 31st May, 2021

#### About

This build contains support for flow delay and some bug fixes.

#### Build Details

| Component                  | Version                                                                                                                             |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Open Traffic Generator API | [0.3.10](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.3.10/openapi.yaml) |
| snappi                     | 0.3.20                                                                                                                              |
| ixia-c-controller          | 0.0.1-1388                                                                                                                          |
| ixia-c-traffic-engine      | 1.2.0.12                                                                                                                            |
| ixia-c-app-usage-reporter  | 0.0.1-36                                                                                                                            |

#### New Feature(s)

* Ixia-c now supports `delay` parameter in flow configuration.  Refer to [v0.3.10](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.3.10/openapi.yaml) of the Open Traffic Generator API specification for more details.

#### Bug Fixes

* The flow configuration parameter `inter_burst_gap` when specified in nanoseconds can now be set to a value larger than 4.2 seconds.
* Invalid values can now be set for the `phb` (per hob behavior) field in the DSCP bits in the IPv4 header.
* The `set_config` method will return an error when flows are over subscribed.
* Fixed an error in calculation for packet counts when `duration` is set in terms of fixed_seconds.

#### Known Issues

* The metrics `frames_rx_rate` and `bytes_rx_rate` in port statistics are not calculated correctly and are always zero.
* The metric `min_latency_ns` in flow statistics is not calculated correctly and is always zero.

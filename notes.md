#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.7.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.7.1/artifacts/openapi.yaml)         |
| snappi                        | [1.7.2](https://pypi.org/project/snappi/1.7.2)        |
| gosnappi                      | [1.7.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.7.2)        |
| keng-controller               | [1.7.2-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.25](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.392](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.7.1-4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.30](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.14.7](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.7.2-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.3.5](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.3/1.3.5/artifacts.tar)         |


# Release Features(s)

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for new traffic applying infrastructure.
  - Instead of <b><i>"Failed to apply flow configurations due to: Please contact Ixia Support."</i></b> , 
    - In scenarios where underlying hardware module doesn't have the resources to apply the flow a proper error message such as <b><i>"Failed to apply flow configurations due to: Error  occurred for flow 'ipv6flowlabel': The Tx Ports of the flow do not support the combinations of fields and size of value lists configured. Please reduce the size of the value lists or/and fields with value lists configured or use a load module ( or variant) with more resources.​"</i></b> Based on this either test can be modified or appropriate load modules can be used for the test.
    - There were certain scenarios with large `values` in packet fields in the flows which were failing with above error inspite of being within the modules capabilities and can now be applied without any error.
  - Earlier configuration with multiples flows with large `values` in packet fields would fail with error as <b><i>"Failed to apply flow configurations due to: Traffic configuration exceeds port background memory size."</i></b>. This issue is also fixed with the upgrade to new traffic applying infrastructure.
  - Issue where  correct `values`/`increment`/`decrement` for `ethernet.src/dst` was not being transmitted on the wire is fixed.
  - In this new infrastructure, traffic will be directly applied to the hardware ports resulting in better performance on `set_transmit_state`.

* <b><i>gosnappi</i></b>: Client side file organization of the `gosnappi` sdk is modified to allow for better auto-completion support when writing test programs.
  Note: Client must be upgraded to gosnappi [v1.7.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.7.2).

* <b><i>Ixia-C, UHD400</i></b>: Support added for DHCPv4 Client and Server in control plane. [details](https://github.com/open-traffic-generator/models/pull/371)
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
* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne), UHD400</i></b>: Support added for `random` in following flow fields. [details](https://github.com/open-traffic-generator/models/pull/380)
  - `ipv4.src​/dst`
  - `ipv6.flow_label​`
  - `tcp.src_port/dst_port`
  - `udp.src_port/dst_port`

    - User can configure by using following snippet.
      ```go
        ipv6 := flow1.Packet().Add().Ipv6()
        ipv6.FlowLabel().Random()​.SetMin(1).SetMax(1048574).SetCount(250000).SetSeed(1)
      ```
    Note: For <b><i>UHD400</i></b> an intermittent issue is present on using `random`, where `rx` fields of `flow_metrics` can return zero values.


* <b><i>Ixia-C</i></b>: New environment variable `OPT_ADAPTIVE_CPU_USAGE=""` is introduced for docker based ixia-c-traffic-engine setups which enables adaptive CPU usage on the `rx` port for a flow. By default a non adaptive receiver is used when the `rx` CPU core usage reaches up to 100%. The adaptive receiver reduces `rx` CPU core usage from 100% to less than 5% in idle mode. To disable the adaptive receiver please remove this environment variable from docker run command. It is recommended to also pin the `rx` to specific cpu cores using the `ARG_CORE_LIST` environment variable when enabling `OPT_ADAPTIVE_CPU_USAGE`.

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
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue where `flow_metrics` were not being returned within timeout resulting in <b><i>"Could not send message, error: unexpected queue Get(1) error: queue: disposed" and "Stats may be inconsistent"</i></b> error is fixed.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue where BGP/BGP+ learned information containing `origin` of type `incomplete` was not being returned properly by `get_states` is fixed. This would result in deserialization error while accessing BGP/BGP+ learned information using `otg-gNMI-server`.

* <b><i>Ixia Chassis & Appliances(AresOne)</i></b>: Issue where `port_metrics` were not available when load module of type `1 x 400G AresOne-M` with transceiver of type `800GE LAN QSFP-DD` was being used, is fixed.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue where `set_control_state.protocol.route.state=withdraw/advertise` is triggered with an empty `names` field, all configured route ranges were being not withdrawn or advertised, is fixed.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue where on `set_control_state.protocol.all.state=start`, a `l1` `up/down` event was triggered even when `l1` state was already `up`, is now fixed. 

  Note: If port is in `down` state, it has to be brought back to `up` state before starting a test.


#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4 clients receive the leased IPv4 addresses from the DHCPv4 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
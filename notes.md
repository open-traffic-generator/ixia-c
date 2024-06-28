#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.6.2](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.6.2/artifacts/openapi.yaml)         |
| snappi                        | [1.6.2](https://pypi.org/project/snappi/1.6.2)        |
| gosnappi                      | [1.6.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.6.2)        |
| keng-controller               | [1.6.2-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.12](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.390](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.6.2-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.30](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.14.4](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.6.2-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.3.3](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.3/1.3.3/artifacts.tar)         |


# Release Features(s)
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for DHCPv4 client interfaces to be used as source/destination for device traffic.
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

* <b><i>Ixia-C</i></b>: Support added for multiple address groups in BGPv4/v6 routes.
  ```go
    route = peer.V4Routes().Add().​
      SetNextHopIpv4Address("2.2.2.2").​
      SetName("peer1.rr1")​

    route.Addresses().Add().​
      SetAddress("20.20.20.1").SetPrefix(32).SetCount(2).SetStep(2)​

    route.Addresses().Add().​
      SetAddress("20.20.21.1").SetPrefix(32).SetCount(2).SetStep(2)​
  ```

### Bug Fix(s)
* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue where if a BGPv4/v6 prefix with extended-community or community attributes was updated via a BGP Update with the extended-community or community attribute deleted without a Route Withdraw in between , the subsequent get_states call on the bgp prefixes would incorrectly continue to show the extended-community or community attributes learned via the previous received Update is fixed.

* <b><i>Ixia-C</i></b>: Issue where If a test was setup such that only test port would initiate ARP/ND and time taken to configure the soft-DUT connected to the test port was taking extended time such that it would not respond to ARP/ND requests within 10s, ARP/ND procedures would fail resulting in test failures in ARP/ND verification step is fixed.

* <b><i>Ixia-C</i></b>: Issue where if a IPv6 address on the emulated interface was configured in non-shortest format e.g.  `2001:0db8::192:0:2:2` instead of `2001:db8::192:0:2:2` (notice the redundant leading 0 in :0db8), the test port would not initiate IPv6 Neighbor Discovery for corresponding IPv6 gateway result in Neighbor Discovery failure is fixed.

* <b><i>Keng-Operator</i></b>: Some fixes are provided to handle security warnings raised by k8s security scanning tool such as <i>`'container "manager" in Deployment "ixiatg-op-controller-manager" does not set readOnlyRootFilesystem: true in its securityContext. This setting is encouraged because it can prevent attackers from writing malicious binaries into runnable locations in the container filesystem.'`</i>.

* <b><i>UHD400</i></b>: Issue is fixed where `frames_rx` is reported twice of `frames_tx` in `flow_metrics` is fixed.


#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4 clients receive the leased IPv4 addresses from the DHCPv4 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
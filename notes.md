### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.28.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.28.0/artifacts/openapi.yaml)         |
| snappi                        | [1.28.2](https://pypi.org/project/snappi/1.28.2)        |
| gosnappi                      | [1.28.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.28.2)        |
| keng-controller               | [1.28.0-6](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.448](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.28.0-6](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.28.2](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.28.0-6](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.5](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.5/artifacts.tar)         |


### Release Features(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for OSPFv3. [details](https://github.com/open-traffic-generator/models/pull/401)

    ```go
        ospfv3Router := device1.Ospfv3()
        ospfv3Router.RouterId().SetCustom("1.1.1.1")

        ospfv3RouterInstance := ospfv3Router.Instances().Add().
                SetName("Ospfv3RtrInstance").
                SetStoreLsa(true)

        intf := ospfv3RouterInstance.Interfaces().Add().
                        SetName("Ospfv3Intf").
                        SetIpv6Name("Ipv6Intf1")
        intf.Area().SetId(0)
        intf.NetworkType().PointToPoint()

        ospfv3Route := ospfv3RouterInstance.V6Routes().
                                Add().
                                SetName("Ospfv3Route1")
        ospfv3Route.
                Addresses().
                Add().
                SetAddress("11::1").
                SetPrefix(64).
                SetCount(100).
                SetStep(2)
    ```
    - OSPFv3 Learned LSAs can be fetched by the following.
    ```go
        req := gosnappi.NewStatesRequest()
        req.Ospfv3Lsas().SetRouterNames(routerNames)
        res, err := client.GetStates(req)
    ```
    - OSPFv3 metrics can be fetched by the following.
    ```go
        req := gosnappi.NewMetricsRequest()
        reqOspf := req.Ospfv3()
        reqOspf.SetRouterNames(routerNames)
    ```
* <b><i>UHD400, Ixia Chassis & Appliances(Novus, AresOne)</i></b>:Support added for start/stop on specific flows.
    ```go
        cs := gosnappi.NewControlState()​
        cs.Traffic().FlowTransmit().
            SetState(gosnappi.StateTrafficFlowTransmitState.START/STOP).
            SetFlowNames([]string{flow1, flow2 .. flowN})​
    ```
* <b><i>Ixia-C, UHD400, Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for configuring flows to be transmitted for a fixed duration.
    ```go
        flow := config.Flows().Add()
		flow.Duration().FixedSeconds().SetSeconds(5)
    ```
* <b><i>Ixia Chassis & Appliances(Novus, AresOne), UHD400</i></b>: gNMI support added to retrieve some new ISIS TLVs related to ISIS segment routing. [More Details](https://github.com/open-traffic-generator/models-yang/pull/41)
  - router-capabilities TLV
  - adjacency-sid sub TLVs in extended-is-reachability
  - prefix-sid sub TLVs in extended-ipv4-reachability
  - prefix-sid sub TLVs in ipv6-reachability

  ```gNMI
      isis-routers/isis-router[name=*]/state/link-state-database
  ```
  Note: Please update featureprofiles/ondatra to latest if the setup is upgraded to this build , otherwise gnmi failures might be seen while fetching isis link-state-database.
* <b><i>snappi</i></b>: Support is added for `grpcio` <= 1.59.5 [earlier supported till <=1.59.0].
        
    Note: As of now, we are unable to upgrade to higher version of `grpcio` to continue providing support for python versions 3.6 and 3.7.
### Bug Fix(s)
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where ISIS `get_states` was returning only one set of learned LSPs for L1+L2 LSP advertisements.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where for certain scenarios `flow_metrics.bytes_tx` was returning incorrect values[same as `bytes_rx`].
* <b><i>Ixia-C</i></b>: Issue is fixed where the protocol-engine container would restart in certain scenarios, especially when run in bare metal setups with a large number of cores in multi-nic mode, and the test would be run immediately or within a short interval after the container/topology had come up.

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
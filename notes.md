#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.14.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.14.0/artifacts/openapi.yaml)         |
| snappi                        | [1.14.0](https://pypi.org/project/snappi/1.14.0)        |
| gosnappi                      | [1.14.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.14.0)        |
| keng-controller               | [1.14.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.99](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.405](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.14.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.14.15](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.14.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.4.0](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.4/1.4.0/artifacts.tar)         |


# Release Features(s)

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for OSPFv2. [details](https://github.com/open-traffic-generator/models/pull/384)
  ```go
    ospfRouter := device1.Ospfv2().​
            SetName("OspfRtr").​
            SetStoreLsa(true)​

    intf := ospfRouter.Interfaces().Add().​
                    SetName("OspfIntf").​
                    SetIpv4Name("Ipv4Intf1")​

    intf.Area().SetId(0)​
    intf.NetworkType().PointToPoint()​
    ospfRoutes := ospfRouter.V4Routes().​
                            Add().​
                            SetName("OspfRoutes")​
    ospfRoutes.​
            Addresses().​
            Add().​
            SetAddress("10.10.10.0").​
            SetPrefix(24).​
            SetCount(100).​
            SetStep(2)​​
  ```

  - Learned LSAs can be fetched by the following
  ```go
    req := gosnappi.NewStatesRequest()​
    req.Ospfv2Lsas().SetRouterNames(routerNames)​
    res, err := client.GetStates(req)
  ```

  - OSPFv2 metrics can be fetched by the following 
  ```go
    req := gosnappi.NewMetricsRequest()
    reqOspf := req.Ospfv2()
    reqOspf.SetRouterNames(routerNames)
  ```


* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added to update `flows[i].size` and `flows[i].rate` on the fly.
  ```go
    ​
    flow = get_config.Flows().Items()[0]​
    flow.Rate().SetPps(120)​
    flow.Size().SetFixed(512)​

    flowUpdateCfg: = gosnappi.NewConfigUpdate().Flows()
    flowUpdateCfg.Flows().Append(flow)​
    flowUpdateCfg.SetPropertyNames ([]gosnappi.FlowsUpdatePropertyNamesEnum{​
      gosnappi.FlowsUpdatePropertyNames.SIZE, gosnappi.FlowsUpdatePropertyNames.RATE
    })​

    configUpdate = gosnappi.NewConfigUpdate()​
    configUpdate.SetFlows(flowUpdateCfg)
    res, err := client.Api().UpdateConfig(configUpdate)​​
  ```
	
### Bug Fix(s)
* <b><i>Ixia-C</i></b>: Issue where flows containing `ipv4/v6` header without `src/dst` specified was returning error on `set_config` <i>"Error flow [ flow-name ] has AUTO IPv4 src address and Tx device [ flow-end-point ] with no dhcpv4 interface"</i> is fixed.


#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
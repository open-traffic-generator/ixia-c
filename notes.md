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
| keng-layer23-hw-server        | [1.13.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.14.15](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.14.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.4.0](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.4/1.4.0/artifacts.tar)         |


# Release Features(s)

* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Scaling support in BGP configuration.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for OSPFv2 routers in control plane. [details](https://github.com/open-traffic-generator/models/pull/384)
  ```go
    ospfName := "OSPFv2RR1"

    p1d1ospfv2rtr1 := p1d1.Ospfv2().​
            SetName("OSPFv2RR1").​
            SetStoreLsa(true)​

    intf := p1d1ospfv2rtr1.Interfaces().Add().​
                    SetName(interfaceName).​
                    SetIpv4Name(ipName)​

    intf.Area().SetId(intAreaId)​
    intf.NetworkType().PointToPoint()​
    p1d1ospfv2rtr1rr1 := p1d1ospfv2rtr1.V4Routes().​
                            Add().​
                            SetName(ospfRrname)​
      p1d1ospfv2rtr1rr1.​
              Addresses().​
              Add().​
              SetAddress(startRr).​
              SetPrefix(prefixRr).​
              SetCount(countRr).​
              SetStep(stepRr)​​
    ```

* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added to update `flows[i].size` and `flows[i].rate` of traffic on the fly.
  ```go
    fu1: = gosnappi.NewConfigUpdate().Flows()​
    flow1 = get_config.Flows().Items()[0]​
    flow1.Rate().SetPps(120)​
    flow1.Size().SetFixed(512)​
    fu1.Flows().Append(flow1)​

    fu1.SetPropertyNames ([]gosnappi.FlowsUpdatePropertyNamesEnum{​
    gosnappi.FlowsUpdatePropertyNames.SIZE, gosnappi.FlowsUpdatePropertyNames.RATE})​

    cu = gosnappi.NewConfigUpdate()​
    cu.SetFlows(fu1)​​
  ```
	
### Bug Fix(s)
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: TBD


#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
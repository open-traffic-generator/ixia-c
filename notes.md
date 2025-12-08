### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.42.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.42.0/artifacts/openapi.yaml)         |
| snappi                        | [1.42.0](https://pypi.org/project/snappi/1.42.0)        |
| gosnappi                      | [1.42.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.42.0)        |
| keng-controller               | [1.42.0-4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.488](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.42.0-4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.42.4](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.42.0-4](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |


### Release Feature(s):
* <b><i>Ixia-C, UHD400 & Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for BGP Monitoring Protocol (BMP). [details](https://github.com/open-traffic-generator/models/pull/427)
    ```go
        p1 := config.Ports().Add().SetName("p1").SetLocation("...")
        device := config.Devices().Add().SetName("p1.dev1")
        ...
        bmpIntf := device.Bmp().Ipv4Interfaces().Add()
        bmpIntf.SetIpv4Name("p1.dev1.eth1.ipv4")

        bmpServer := bmpIntf.Servers().Add()
        bmpServer.SetName(device.Name()+".bmp")
        bmpServer.SetClientIp("1.1.1.1")
        // To control which TCP port on which to accept requests from DUT BMP Client.
        bmpServer.Connection().Passive().SetListenPort(10123)

        //To store all routes
        //bmpServer.PrefixStorage().Ipv4Unicast().Store()

        //Store specifically needed routes
        discard := bmpServer.PrefixStorage().Ipv4Unicast().Discard()
        discard.Exceptions().Add().
                SetIpv4Prefix("172.16.0.0").
                SetPrefixLength(16)

        //Store all IPv6 prefixes
        // bmpServer.PrefixStorage().Ipv6Unicast().Store()

        //Store subset of IPv6 prefixes
        v6discard := bmpServer.PrefixStorage().Ipv6Unicast().Discard()
        v6discard.Exceptions().Add().
                SetIpv6Prefix("172:16:0:1::").
                SetPrefixLength(64)
            
        //To get BMP Metrics: 
        reqMetrics := gosnappi.NewMetricsRequest()
        reqMetrics.BmpServer()
        bmpMetrics, err := client.Api().GetMetrics(reqMetrics)
        ...

        // To get BMP State info ( the per peer stats/prefixes information sent by BMP Client) 
        reqStates := gosnappi.NewStatesRequest()
        reqStates.BmpServers()
        bmpState, err := client.Api().GetStates(reqStates)
    ```
    -  gNMI support added to fetch metics and states of BGP Monitoring Protocol (BMP) [models-yang](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-bmp-server.txt).

        ```gNMI
            // metrics
            bmp-servers/bmp-server[name=*]/state/counters
            
            // states
            bmp-servers/bmp-server[name=*]/state/peer-state-database/peers
        ```

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.42.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.42.1/artifacts/openapi.yaml)         |
| snappi                        | [1.42.1](https://pypi.org/project/snappi/1.42.1)        |
| gosnappi                      | [1.42.1](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.42.1)        |
| keng-controller               | [1.42.1-4](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.491](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.42.1-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.42.5](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.42.1-4](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |


### Release Feature(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `ping` support is added for IPv4/v6 protocol in `set_control_action`.
    ```go
        // IPv4 Ping
        ca := gosnappi.NewControlAction()
        pa := ca.Protocol().Ipv4().Ping()
        // If the requests list is not provided, by default ping will be invoked for all IPv4 and IPv4 Loopback interfaces in the current configuration.
        // requests is list of local IPv4 interface name + Destination IPv4 tuple
        for _, req := range requests {
            pingReq := gosnappi.NewActionProtocolIpv4PingRequest().SetSrcName(req.SrcName).SetDstIp(req.DstIp)
            pa.Requests().Append(pingReq)
        }

        result, err := client.Api().SetControlAction(ca)

        // process responses
        pingResponseItems := result.Response().Protocol().Ipv4().​Ping().Responses().Items()
        for _, actM := range pingResponseItems {
            t.Logf("%v  %v : %v", actM.SrcName(), actM.DstIp(), actM.Result()) // Where Result is success or failure.
        }

        // IPv6 Ping
        ca := gosnappi.NewControlAction()
        pa := ca.Protocol().Ipv6().Ping()
        // If the requests list is not provided, by default ping will be invoked for all IPv6 and IPv6 Loopback interfaces in the current configuration.
        // requests is list of local IPv6 interface name + Destination IPv6 tuple
        for _, req := range requests {
            pingReq := gosnappi.NewActionProtocolIpv6PingRequest().SetSrcName(req.SrcName).SetDstIp(req.DstIp)
            pa.Requests().Append(pingReq)
        }

        // Result processing is similar to IPv4 above.
    ```
    - using `curl`/`Rest Api`,
        ```bash
            curl -k -X POST -H "Content-Type: application/json" --data-binary "@ping.json" https://<controller-ip>:8443/control/action

            cat ping.json
            {
                "choice": "protocol",
                    "protocol": {
                        "choice": "ipv4",
                        "ipv4": {
                            "choice": "ping"
                    }
                }
            }
        ```
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support of Ingress Flow tracking is added for any combination of supported fields with `metric_tags` up to a maximum combined tracking bits of 12, which includes flow tracking as well.

    ```go
        flow := cfg.Flow().Add()​
        flow.Packet().Add().Ethernet()​
        ipv4 := flow.Packet().Add().Ipv4()​
        ipv4.Src().MetricTags().Add().SetName("src").SetLength(32)​ // Currently the maximum length of the field being tracked must be provided.
        ipv4.Dst().MetricTags().Add().SetName("dst").SetLength(32) // Ingress tracking for partial bits in a field is not supported.
    ```
    - User can set `get_metrics.flow.tagged_metrics.include=false` not to include `tagged_metrics` in the `flow_metrics` response.
    - Specific `tagged_metrics` can be fetched by setting `get_metrics.flow.tagged_metrics.filters[i].name`.
    - Support is available in gNMI to fetch the drill-down statistics for ingress tracking as follows. [details](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-flow.txt):
        ```
            1. Flow level metrics + Tagged Metrics:
                example path: "flows/flow[name=f1]“
            2. Only Tagged metrics 
                example path: "flows/flow[name=f1]/tagged-metrics“
            3. Filtered Tagged metrics: 
                example path: "flows/flow[name=f1]/tagged-metrics/tagged-metric[name-value-pairs=flow_ipv6_dst=0x2]”
        ```

    Note: Ingress and Egress tracking together, is currently not supported.

### Bug Fix(s):
* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne) & UHD400</i></b>: Issue is fixed where context deadline was being seen intermittently for large ISIS configurations especially with Simulated Topology for repeated `set_config`, `set_control_state.protocol.start/stop` actions, due to port crashes while processing ISIS Hellos.


### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
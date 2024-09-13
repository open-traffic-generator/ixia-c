#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.13.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.13.0/artifacts/openapi.yaml)         |
| snappi                        | [1.13.0](https://pypi.org/project/snappi/1.13.0)        |
| gosnappi                      | [1.13.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.13.0)        |
| keng-controller               | [1.13.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.25](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.399](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.13.0-3](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.30](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.14.14](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.13.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.4.0](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.3/1.4.0/artifacts.tar)         |


# Release Features(s)

* <b><i>gosnappi</i></b>: `gosnappi` is updated to work with `go` >= `v1.21`.
  - Older versions of `go` are no longer supported.
    - When older version of `go` is installed on the server, User will be liable to get errors like `"slices: package slices is not in GOROOT (/root/.local/go/src/slices)"`.

  Note: `keng-controller` and `otg-gnmi-server` are upgraded to use `go` `v1.23`. 

* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne), UHD400</i></b>: Support added for BGP GracefulRestart Notification Enhancement based on [RFC8538](https://datatracker.ietf.org/doc/html/rfc8538)​.
  - To enable advertisement of Notification support in GracefulRestart capability:

  ```go
      peer.GracefulRestart().SetEnableNotification(true)​
  ```
  
  - To optionally send Notification when peer is going down during `InitiateGracefulRestart` trigger:​

  ```go
      grAction := gosnappi.NewControlAction()​
      bgpPeersRestart := grAction.Protocol().Bgp().InitiateGracefulRestart()​
      bgpPeersRestart.​
          SetPeerNames([]string{"peer1"}).​
          SetRestartDelay(20)​
      notification:= bgpPeersRestart.Notification()​
      if sendHardReset == true {              	​
        notification.Cease().SetSubcode(​
          gosnappi.DeviceBgpCeaseErrorSubcode.HARD_RESET_CODE6_SUBCODE9)​
      } 
      else {​
        /* Send anything else except hard reset */ ​
        notification.Cease().SetSubcode(​
            gosnappi.DeviceBgpCeaseErrorSubcode.OUT_OF_RESOURCES_CODE6_SUBCODE8)​
      }​
    ```

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added to update traffic rate on the fly.
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
* <b><i>UHD400</i></b>: Issue where `flows[i].packet.ipv6.dst.increment` was not being reflected in transmitted packets when two or more flows were configured, is now fixed.


#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
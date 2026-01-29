### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.43.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.43.0/artifacts/openapi.yaml)         |
| snappi                        | [1.43.0](https://pypi.org/project/snappi/1.43.0)        |
| gosnappi                      | [1.43.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.43.0)        |
| keng-controller               | [1.43.0-7](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.494](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.43.0-3](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.43.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.43.0-7](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |


### Release Feature(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `reboot` support is added for port in `set_control_action`.
    ```go
        // port reboot action with empty port-names - to reboot all ports in the otg configuration
        ca1 := gosnappi.NewControlAction()
        ca1.Port().Reboot()
        result, err := client.Api().SetControlAction(ca1)

        // port reboot action with specific port-names - to reboot specific ports in the otg configuration
        ca2 := gosnappi.NewControlAction()
        ca2.Port().Reboot().SetPortNames([]string{"port1", "port2"})
        result, err := client.Api().SetControlAction(ca2)
    ```
    - same could be achieved using `curl`/`Rest Api` after a successful `set_config` operation,
        ```bash
            curl -k -X POST -H "Content-Type: application/json" --data-binary "@rebootports.json" https://<controller-ip>:8443/control/action

            // port reboot action with empty port-names - to reboot all ports in the otg configuration
            rebootports.json:
            {
                "choice": "port",
                "port": {
                    "choice": "reboot"
                }
            }

            // port reboot action with specific port-names - to reboot specific ports in the otg configuration
            rebootports.json:
            {
                "choice": "port",
                "port": {
                    "choice": "reboot",
                    "reboot":{
                        "port_names": ["port1", "port2"]
                    }
                }
            }
        ```

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
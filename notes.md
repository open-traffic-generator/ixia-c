### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.35.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.35.0/artifacts/openapi.yaml)         |
| snappi                        | [1.35.0](https://pypi.org/project/snappi/1.35.0)        |
| gosnappi                      | [1.35.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.35.0)        |
| keng-controller               | [1.35.0-14](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.466](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.35.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.35.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.35.0-14](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.8](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.8/artifacts.tar)         |


### Release Features(s):
* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne) & UHD400</i></b>: Support added to set `flows[i].packet.payload` as `fixed`, `increment_byte`, `decrement_byte`, `increment_word` & `decrement_word`. [details](https://github.com/open-traffic-generator/models/pull/432)

    ```go
        flow := config.Flows().Add()
        f1Payload := flow.Payload()
        f1Payload.SetFixed(gosnappi.NewFlowPayloadFixed().SetPattern("aabbccdd").SetRepeat(false))
        //increment Payload
        f1Payload.IncrementByte()
        f1Payload.IncrementWord()
        //Decrement Payload
        f1Payload.DecrementByte()
        f1Payload.DecrementWord() 
    ```

    Note: If `flows[i].metrics.enable` is set to `true`, some part of the payload will be overwritten with instrumentation data used for tracking the flow.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Changes in version compatibility check for IxOS installed on chassis.
    - `set_config` will now return a deprecation warning, if ports are present in the configuration connected to chassis with IxOS version `< 10.00EA`. Support for `9.xx` IxOS versions is planned to be removed in near future.
    - Support is now added for `11.00EA` and no warnings will be returned any longer when connected to chassis with up-to IxOS version `11.00EA`.


* <b><i>Ixia-C, Ixia Chassis & Appliances(Novus, AresOne) & UHD400</i></b>: Support added in `keng-controller` to store last 10 configurations in compressed format(*.tar.gz) at location `~/logs/configs` within the container.
    - Extracted configs will be in `*.pb` or `*pbtxt` (if streaming mode is enabled) format.
    - Number of last `n` configs can be controlled by a commandline option `-archive-configs=<count>` if default value of 10 configs needs to be overridden.
    - To extract  `gosnappi`/`json` config from the extracted config please use the following snippet.
        ```go
            data, _ := os.ReadFile("Set_Config_11_4th_JAN_02_15_27PM_UTC.08265.pb")
            pb := otg.Config{}
            proto.Unmarshal(data, &pb)
            otgCfg := gosnappi.NewConfig()
            otgCfg, _ = otgCfg.Unmarshal().FromProto(&pb)
            jsonCfg, _ := otgCfg.Marshal().ToJson()
            os.WriteFile("config.json", []byte(jsonCfg), 0644)
        ```

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
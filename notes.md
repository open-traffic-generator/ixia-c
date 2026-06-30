### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.58.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.58.0/artifacts/openapi.yaml)         |
| snappi                        | [1.58.0](https://pypi.org/project/snappi/1.58.0)        |
| gosnappi                      | [1.58.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.58.0)        |
| keng-controller               | [1.58.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.544](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.532](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.58.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.4.0](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.58.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.58.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |
| <b>ARM64</b>                                  |
| keng-controller-arm64         | [1.58.0-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller-arm64)    |
| ixia-c-traffic-engine-arm64   | [1.8.0.563](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine-arm64)       |


### Release Feature(s):
* <b><i>Ixia Chassis & Appliances(AresOne-P)</i></b>: Support added for Macsec & MKA over devices. [details](https://github.com/open-traffic-generator/models/pull/459)
  ```go
      // -- Macsec Config
      device := config.Devices().Add().SetName("device1")
      eth1 := device.Ethernets().Add().SetName("eth1").SetMac("00:00:11:01:01:01")
      eth1.Connection().SetPortName("p1")
      ...
      macsec := device.Macsec().EthernetInterfaces().Add().SetEthName(eth1.Name()).SecureEntity().SetName("eth1-macsec")
      macsec.DataPlane().Encapsulation().CryptoEngine().EncryptDecrypt().HardwareAcceleration().InlineCrypto()
      mka := macsec.KeyGenerationProtocol().Mka().SetName("eth1-mka")
      mka.Basic().KeySource().Psk()
      mka.Basic().KeySource().Psks().Add().
        SetCakValue("0123456789ABCDEF0123456789ABCDEF").SetCakName("AABBCCDD")
      mka.Tx().SecureChannels().Add().SetName("eth1-sc").SetSystemId(eth1.Mac())
  ```

  <b><i>Notes</i></b>:
    - This feature is supported only on AresOne-P load module in all fan-out Macsec modes.
    - IxOS version 26.1.2605.1 0.HF002490 must be installed on the chassis which is a hot fix build over IxOS 26.1.EA release.
    - To see decrypted packets, Keysight specific wireshark should be used, which can be download from: [version: 3.2.6.345](https://downloads.ixiacom.com/support/downloads_and_updates/public/IxNetwork/26.0.0/26.0.2601.6/wireshark.exe)
    - If an issue is encountered during Macsec testing on this hardware which is not resolved after rebooting the ports, it might be required to switch the ports to non-macsec mode and back to macsec mode for the ports to become usable again.
      - This can be done through WebUI or using RestAPI calls to the chassis.

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Support added for enabling/disabling Overload Bit for ISIS simulated routers on the fly. [details](https://github.com/open-traffic-generator/models/pull/479)
    ```go
         setAction := gosnappi.NewControlAction()
            setOlBit := setAction.Protocol().Isis().UpdateOverloadBit()
            setOlBit.SetRouterNames([]string{"isis-sim1", "isis-sim2"})
            setOlBit.Set()/Unset()
        client.Api().SetControlAction(setAction)
    ```

### Bug Fix(s):
* <b><i>Ixia-C</i></b>: Issue is fixed where, if multiple flows are configured with flow tracking disabled , only the first such flow was being erroneously transmitted even if start is triggered for all or other configured flows.
* <b><i>Ixia-C</i></b>: Issue is fixed to handle auto `protocol` type for IPv4/v6 header preceding MPLS, or return a more specific warning for unsupported header sequence in flows with `protocol` type set as `auto`.

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
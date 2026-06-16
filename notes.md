### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.57.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.57.0/artifacts/openapi.yaml)         |
| snappi                        | [1.57.0](https://pypi.org/project/snappi/1.57.0)        |
| gosnappi                      | [1.57.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.57.0)        |
| keng-controller               | [1.57.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.544](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.531](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.57.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.4.0](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.57.2](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.57.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |
| <b>ARM64</b>                                  |
| keng-controller-arm64         | [1.55.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller-arm64)    |
| ixia-c-traffic-engine-arm64   | [1.8.0.563](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine-arm64)       |


### Release Feature(s):
* <b><i>Ixia Chassis & Appliances(AresOne-P)</i></b>: Support added for Macsec & MKA over LAG ports. [details](https://github.com/open-traffic-generator/models/pull/459)
  ```go
      // -- Macsec Config
      macsec1 := lagPort1.Macsec()
      secy1 := macsec1.SecureEntity().SetName(macsecPeerName)
      secy1Encapsulation := secy1.DataPlane().Encapsulation()
      secy1Encapsulation.CryptoEngine().EncryptDecrypt().HardwareAcceleration().InlineCrypto()
  
      // -- MKA Config
      mka := secy1.KeyGenerationProtocol().Mka().SetName("PeerA-Mka")
      mka.Basic().KeySource().Psk()
  
      mka.Basic().SetKeyDerivationFunction(gosnappi.MkaBasicKeyDerivationFunctionEnum("aes_cmac_128"))
      mka.Basic().SetSendIcvIndicatiorInMkpdu(false)
      mka.Basic().SetMkaVersion(2)
      scs := mka.Basic().SupportedCipherSuites()
      scs.SetGcmAes256(false)
      scs.SetGcmAesXpn256(false)
  
      onePsk := mka.Basic().KeySource().Psks().Add()
      onePsk.SetCakValue(cak)
      onePsk.SetCakName(ckn)
      secureChannel := mka.Tx().SecureChannels().Add()
      secureChannel.SetName("SecureChannel1").
          SetSystemId(lagPort1.Ethernet().Mac())
  ```
  - To fetch OTG metrics use the following:
    ```go
      // -- MKA Metrics
      reqMetrics := gosnappi.NewMetricsRequest()
      reqMka := reqMetrics.Mka()
      res, err := client.GetMetrics(reqMetrics)
     

      // -- Macsec Metrics
      reqMetrics := gosnappi.NewMetricsRequest()
      reqMacsec := reqMetrics.Macsec()
      res, err := client.GetMetrics(reqMetrics) 
      // Supported Macsec Metrics are session_state, session_flap_count, 
      // in_pkts_ok, in_pkts_bad, in_pkts_not_valid, in_pkts_invalid, 
      // in_octets_validated, in_octets_decrypted
    ```
  - To fetch gNMI metrics use the following:
    ```sh
      # -- MKA Metrics
      /mka/peers/peer[name=*]

      # -- Macsec Metrics
      /macsec/interfaces/interface[name=*]
      # Supported Macsec Metrics from gNMI are session-state, flaps, 
      # rx-valid-pkts. rx-bad-pkts, rx-invalid-pkts
    ```

  <b><i>Notes</i></b>:
    - This feature is supported only on AresOne-P load module in RG mode = “4 x 100GE_MACSEC”.
      - This mode should be set in chassis manually before running Macsec test.
    - IxOS version 26.1.2605.1 0.HF002490 must be installed on the chassis which is a hot fix build over IxOS 26.1.EA release.
    - To see decrypted packets, Keysight specific wireshark should be used, which can be download from: [version: 3.2.6.345](https://downloads.ixiacom.com/support/downloads_and_updates/public/IxNetwork/26.0.0/26.0.2601.6/wireshark.exe)
    - If an issue is encountered during Macsec testing on this hardware which is not resolved after rebooting the ports, it might be required to switch the ports to non-macsec mode and back to macsec mode for the ports to become usable again.
      - This can be done through WebUI or using RestAPI calls to the chassis.

* <b><i>Ixia-C</i></b>: Support added for `LACP` header in flow. [details](https://github.com/open-traffic-generator/models/pull/435)
    ```go
        f1Eth := flow.Packet().Add().Ethernet()
        f1Eth.Src().SetValue("00:00:00:00:00:AA")
        f1Eth.Dst().SetValue("01:80:C2:00:00:02")

        f1Lacp := flow.Packet().Add().Lacp()
        f1Lacpdu := f1Lacp.Lacpdu()

        f1LacpActor := f1Lacpdu.Actor()
        f1LacpActor.SystemPriority().SetValue(32768)
        f1LacpActor.SystemId().SetValue("00:00:00:00:00:AA")
        f1LacpActor.Key().SetValue(13)
        f1LacpActor.PortPriority().SetValue(32768)
        f1LacpActor.PortNumber().SetValue(25)
        f1LacpActor.ActorState().Activity.SetValue(1)
        f1LacpActor.ActorState().Aggregation.SetValue(1)
        f1LacpActor.ActorState().Collecting.SetValue(1)

        f1LacpPartner := f1Lacpdu.Partner()
        f1LacpPartner.SystemPriority().SetValue(32768)
        f1LacpPartner.SystemId().SetValue("00:0c:29:1e:a2:6d")
        f1LacpPartner.Key().SetValue(1)
        f1LacpPartner.PortPriority().SetValue(32768)
        f1LacpPartner.PortNumber().SetValue(1)
        f1LacpPartner.PartnerState().Distributing.SetValue(1)  
    ```

    Note: `flows[i].metrics.enable` should be set to `false`, to ensure that instrumentation data is not appended to the `LACP` PDU being transmitted on the wire.

* <b><i>ARM64 Support</i></b>: Support is now available for native arm64 images for keng-controller, ixia-c-traffic-engine & keng-licenseserver.
    - Notes:
        - This is meant for standalone deployment of aforementioned containers in docker environment, not in KNE environments.
        - Method of deployment will remain the same, just image path should point to the location of arm64 image variants (metioned in build details under <b>ARM64</b> section).
         
### Bug Fix(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where OSPFv3 does not come up and stays in ExStart state due to MTU having lesser value than expected in DBDescription packet transmitted.

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.61.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.61.0/artifacts/openapi.yaml)         |
| snappi                        | [1.61.0](https://pypi.org/project/snappi/1.61.0)        |
| gosnappi                      | [1.61.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.61.0)        |
| keng-controller               | [1.61.0-15](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.544](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.536](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.61.0-9](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.4.0](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.61.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.61.0-15](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |
| <b>ARM64</b>                                  |
| keng-controller-arm64         | [1.61.0-15](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller-arm64)    |
| ixia-c-traffic-engine-arm64   | [1.8.0.563](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine-arm64)       |


### Release Feature(s):
* <b><i>Ixia Chassis & Appliances(AresOne-P)</i></b>: Support added for Macsec & Static Key over LAG & devices.
  ```go
      // 32 hex = 128-bit SAK
	sakA := "AABBCCDDEEFF00112233445566778899"
	sakB := "00112233445566778899AABBCCDDEEFF"
	ssci := "00000001"
	salt := "123456789ABCDEF012345678" // 16-byte salt for XPN; begin for AES-128
	
    // macsec interface
	secy1 := d1.Macsec().EthernetInterfaces().Add().SetEthName(d1Eth.Name()).SecureEntity().SetName("Macsec-1")
	enc1 := secy1.DataPlane().Encapsulation()
	enc1.CryptoEngine().EncryptDecrypt().HardwareAcceleration().InlineCrypto()
	enc1.Tx().SetIncludeSci(true)

     //macsec static-key configuration
	sk1 := secy1.KeyGenerationProtocol().StaticKey()
	sk1.SetCipherSuite(gosnappi.SecureEntityStaticKeyCipherSuite.GCM_AES_128)
	tx1 := sk1.Tx().SecureChannels().Add().SetSystemId(d1Eth.Mac()).SetPortId(1)
	tx1.Saks().Add().SetSak(sakA).SetSsci(ssci).SetSalt(salt)
           rx1 := sk1.Rx().SecureChannels().Add().SetDutSciSystemId("00:00:22:02:02:02").SetDutSciPortId(1)
	rx1.Saks().Add().SetSak(sakB).SetSsci(ssci).SetSalt(salt)
  ```

  <b><i>Notes</i></b>:
    - This feature is supported only on the AresOne-P load module. 
        - For LAG, the supported mode is RG mode = “4 x 100GE_MACSEC”.
        - For devices, it is supported in all fan-out MACsec modes.
    - IxOS version 26.1.2605.1 0.HF002490 must be installed on the chassis which is a hot fix build over IxOS 26.1.EA release.
    - To see decrypted packets, Keysight specific wireshark should be used, which can be download from: [version: 3.2.6.345](https://downloads.ixiacom.com/support/downloads_and_updates/public/IxNetwork/26.0.0/26.0.2601.6/wireshark.exe)
    - If an issue is encountered during Macsec testing on this hardware which is not resolved after rebooting the ports, it might be required to switch the ports to non-macsec mode and back to macsec mode for the ports to become usable again.
      - This can be done through WebUI or using RestAPI calls to the chassis.


### Bug Fix(s):
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where `get_metrics/flows` was sometimes returning TX and RX counters as 0 for the 51st and subsequent flows when more than 50 flows were configured. 
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed for flows containing multiple ethernet headers, where FCS was incorrectly added for inner ethernet header also, further resulting in incorrect data-integrity errors if data-integrity was enabled.


### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
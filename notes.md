### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [1.40.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v1.40.0/artifacts/openapi.yaml)         |
| snappi                        | [1.40.3](https://pypi.org/project/snappi/1.40.3)        |
| gosnappi                      | [1.40.3](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v1.40.3)        |
| keng-controller               | [1.40.0-15](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.8.0.245](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-52](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.482](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [1.40.0-5](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.34](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.40.3](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [1.40.0-15](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                        | [1.5.10](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.5/1.5.10/artifacts.tar)         |

***Note***

`gosnappi` will support go version >=v1.24 and `snappi` will support python version from `v3.8` to `v3.12`.

### Release Features(s):
* <b><i>UHD400</i></b>: Support added for capturing packets on multiple test ports.
    ```go
        // Enabling capture ports​
        enableCapture := config.Captures().Add().SetName("Capture")​
        enableCapture.SetPortNames([]string{"p1", "p2", "p3", "p4"})​

        // startCapture on enabled ports​
        for _, capture := range gosnappi.Config.Captures().Items() {​
            capturePorts = append(capturePorts, capture.PortNames()...)​
        }​
        ​
        s := gosnappi.NewControlState()​
        s.Port().Capture().SetPortNames(portNames).SetState(gosnappi.StatePortCaptureState.START)​
        client.Api().SetControlState(s, "StartCapture")​
        ​
        // Retrieve Capture​
        captureFileObj, err := os.Create(“capture_test.pcap”)​
        req := gosnappi.NewCaptureRequest().SetPortName(portName)​
        captureBytes, err := client.Api().GetCapture(req)​
        captureFileObj.Write(captureBytes)​
        pcap.OpenOffline(outCaptureFile)​
    ```​

* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>:Support added for extended IPv6 routing header type 4(IPv6 SR) as Data traffic.
    ```go
        // go-snappi snippet​
        f1Eth := f1.Packet().Add().Ethernet()​
        ...
        f1Ip := f1.Packet().Add().Ipv6()​
        ...​

        // IPv6 SR Header ​
        f1ExtHdr := f1.Packet().Add().Ipv6ExtensionHeader()​
        f1SR := f1ExtHdr.Routing().SegmentRouting()​
        f1SR.SegmentsLeft().SetValue(2)​
        f1SR.LastEntry().SetValue(2)​
        f1SegList := f1SR.SegmentList()​
        f1SegList.Add().Segment().SetValue("5000:0:0:1:0:0:0:1")​
        f1SegList.Add().Segment().SetValue("1000:0:0:1:0:0:0:1")​
        ...
    ```

### Bug Fix(s): 
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: Issue is fixed where for certain scaled ISIS simulated topology configs `"context deadline exceeded"` error was being encountered on `set_config`.

### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: `StartProtocols`/`set_control_state.protocol.all.start` can get stuck till the time all DHPCv4/v6 clients receive the leased IPv4/v6 addresses from the DHCPv4/v6 server/relay agent. This may result in getting `"context deadline exceeded"` error in the test program.
* <b><i>UHD400</i></b>: Packets will not be transmitted if `flows[i].rate.pps` is less than 50.
* <b><i>UHD400</i></b>: `values` for fields in flow packet headers can be created with maximum length of 1000 values. If larger set of values are required for a field which are random, please use `random` instead of `values`.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 
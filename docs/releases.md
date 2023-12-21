# Ixia-c Release Notes and Version Compatibility

## Release  v0.1.0-158 (Latest)
> 21st December, 2023

#### About

This build includes new features.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.13.4](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.13.4/artifacts/openapi.yaml)         |
| snappi                        | [0.13.4](https://pypi.org/project/snappi/0.13.4)        |
| gosnappi                      | [0.13.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.13.4)        |
| keng-controller               | [0.1.0-158](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.6.0.109](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.348](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [0.13.4-1](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.14](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.13.4](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [0.1.0-158](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                    | [1.0.27](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.0/1.0.27/artifacts.tar)         |

# Release Features(s)
* 


#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 

## Release  v0.1.0-84
> 7th December, 2023

#### About

This build includes new features.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.13.2](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.13.2/artifacts/openapi.yaml)         |
| snappi                        | [0.13.2](https://pypi.org/project/snappi/0.13.2)        |
| gosnappi                      | [0.13.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.13.2)        |
| keng-controller               | [0.1.0-84](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.6.0.100](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.340](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [0.13.2-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.13](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.13.2](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [0.1.0-84](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                    | [1.0.27](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.0/1.0.27/artifacts.tar)         |

# Release Features(s)
* <b><i>Ixia-C</i></b>: Support added to trigger link `up/down` on test ports using the API `set_control_state.port.link`. This applicable only when the test port is directly connected to device under test via `veth` connection, e.g in KNE single node cluster, containerlab.
  ```go
    portStateAction := gosnappi.NewControlState()
    linkState := portStateAction.Port().Link().
                    SetPortNames([]string{port.Name()}).
                    SetState(gosnappi.StatePortLinkState.DOWN/UP)
    api.SetControlState(portStateAction)
  ```
  - It removes the deviation (`deviation_ate_port_link_state_operations_unsupported`) which was added in `featuresprofile` tests for no supporting the LinkState trigger in <b><i>Ixia-C</i></b>.


#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 

## Release  v0.1.0-81
> 24th November, 2023

#### About

This build includes new features and bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.13.2](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.13.2/artifacts/openapi.yaml)         |
| snappi                        | [0.13.2](https://pypi.org/project/snappi/0.13.2)        |
| gosnappi                      | [0.13.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.13.2)        |
| keng-controller               | [0.1.0-81](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.6.0.100](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.339](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [0.13.2-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.13](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.13.2](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [0.1.0-81](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                    | [1.0.27](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.0/1.0.27/artifacts.tar)         |

# Release Features(s)
* Support for BGP/BGP+ passive mode <b><i>Ixia-C, UHD400 and Ixia Chassis & Appliances(Novus, AresOne)</i></b>. If `passive_mode` of a peer is set to true, it will wait for the remote peer to initiate the BGP session.
  - User needs to set `devices[i].bgp.ipv4/v6_interfaces[j].peers[k].advance.passive_mode` to `true` for enabling passive mode.

* When `layer1[i].speed` is not explicitly set, the current speed of underlying test interface shall be assumed.
  - This allows setting of `layer1` MTU in tests to run on  setups with different port speeds on <b><i>Ixia-C and Ixia Chassis & Appliances(Novus, AresOne)</i></b> without any modifications.
    ```go
      otgConfig.Layer1().Add().
          SetName("layerOne").
          SetPortNames(portNames).
          SetMtu(9000)
    ```
  - For traffic with `flow.rate.percentage` specified and `layer1[i].speed` not specified, the rate is now automatically calculated based on the port speed of the port from where traffic is being transmitted.

# Bug Fix(s)
* Issue where `devices[i].bgp.ipv4/v6_interfaces[j].peers[k].v4/v6_routes[m].communities` was not being sent properly for <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b> is now fixed.


#### Known Issues
* <b><i>Ixia Chassis & Appliances(Novus, AresOne)</i></b>: If `keng-layer23-hw-server` version is upgraded/downgraded, the ports which will be used from this container must be rebooted once before running the tests.
* <b><i>Ixia-C</i></b>: Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down. 
* <b><i>Ixia-C</i></b>: Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* <b><i>Ixia-C</i></b>: The metric `loss` in flow metrics is currently not supported.
* <b><i>Ixia-C</i></b>: When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets. 

## Release  v0.1.0-53
> 10th November, 2023

#### About

This build includes new features and bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.13.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.13.0/artifacts/openapi.yaml)         |
| snappi                        | [0.13.0](https://pypi.org/project/snappi/0.13.0)        |
| gosnappi                      | [0.13.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.13.0)        |
| keng-controller               | [0.1.0-53](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.6.0.85](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.337](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [0.13.0-6](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.13](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.13.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [0.1.0-53](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                    | [1.0.27](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.0/1.0.27/artifacts.tar)         |

# Release Features(s)
* Support added for link `up/down` trigger for <b><i>UHD400​</i></b>. 
  ```go
    portStateAction := gosnappi.NewControlState().
                          Port().
                          Link().
                          SetPortNames([]string{"port1"}).
                          SetState(gosnappi.StatePortLinkState.DOWN)
    gosnappi.setControlState(portStateAction)
  ```
* Support added for 0x8100(Vlan) and 0x6007(Google Discovery Protocol) ether types in data plane traffic in <b><i>UHD400</i></b>.


# Bug Fix(s)
* Some tests were failing because packets were not sent on wire due to frame size of flows not being sufficient to include tracking information in <b><i>Ixia Chassis & Appliances(AresOne only)​</i></b> is fixed.
* `egress` tracking on VLAN id or other fields for more than 3 bits was not working in <b><i>Ixia Chassis & Appliances(Novus, AresOne)​</i></b>, is fixed.
  - `egress` tracking now supports upto 11 bits.
* Issue in ARP resolution in certain cases is now fixed in <b><i>UHD400​</i></b>. 


#### Known Issues
* If `keng-layer23-hw-server` version is upgraded/downgraded, the ports from Ixia Chassis & Appliances(Novus, AresOne) which will be used from this container must be rebooted once before running the tests.
* Adding more than 256 devices on a single ixia-c-port causing failure for Ixia Chassis & Appliances(Novus, AresOne).
* Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* With certain DUTs, ssh service hangs if ISIS L1 MD5 is enabled.
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.1.0-26
> 3rd November, 2023

#### About

This build includes stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.13.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.13.0/artifacts/openapi.yaml)         |
| snappi                        | [0.13.0](https://pypi.org/project/snappi/0.13.0)        |
| gosnappi                      | [0.13.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.13.0)        |
| keng-controller               | [0.1.0-26](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.6.0.85](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.337](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [0.13.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.13](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.13.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [0.1.0-26](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
| UHD400                    | [1.0.26](https://downloads.ixiacom.com/support/downloads_and_updates/public/UHD400/1.0/1.0.26/artifacts.tar)         |


#### Known Issues
* If `keng-layer23-hw-server` version is upgraded/downgraded, the ports from Ixia Chassis & Appliances(Novus, AresOne) which will be used from this container must be rebooted once before running the tests.
* Adding more than 256 devices on a single ixia-c-port causing failure for Ixia Chassis & Appliances(Novus, AresOne).
* Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* With certain DUTs, ssh service hangs if ISIS L1 MD5 is enabled.
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)


## Release  v0.1.0-3
> 20th October, 2023

#### About

This build includes new features, stability and bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.13.0](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.13.0/artifacts/openapi.yaml)         |
| snappi                        | [0.13.0](https://pypi.org/project/snappi/0.13.0)        |
| gosnappi                      | [0.13.0](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.13.0)        |
| keng-controller               | [0.1.0-3](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller)    |
| ixia-c-traffic-engine         | [1.6.0.85](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| keng-app-usage-reporter       | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.337](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-protocol-engine)    | 
| keng-layer23-hw-server        | [0.13.0-2](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-layer23-hw-server)    |
| keng-operator                 | [0.3.13](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-operator)        | 
| otg-gnmi-server               | [1.13.0](https://github.com/orgs/open-traffic-generator/packages/container/package/otg-gnmi-server)         |
| ixia-c-one                    | [0.1.0-3](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Release Feature(s)
* Ixia-C now offers following existing licensed features free for community use (without requiring Keysight Licensing Solution):
  1. `ixia-c-protocol-engine`, which enables control plane emulation in Ixia-C is now publicly downloadable.
  2. Emulation of one or more IPv4 and IPv6 interfaces with Address Resolution Protocol (ARP) and Neighbor Discovery (ND), respectively, is now supported.
  3. Automatic destination MAC address resolution for flows with IPv4 / IPv6 endpoints is now supported.
  4. Configuring one BGP session over IPv4 / IPv6, advertising V4 / V6 routes is now supported.
* Users exercising full feature set ([Keysight Elastic Network Generator aka KENG](https://www.keysight.com/us/en/products/network-test/protocol-load-test/keysight-elastic-network-generator.html)) will now have to subscribe to Keysight Licensing Solution. Please reach out to Keysight for more details.
* `keng-layer23-hw-server`, which facilitates control and data plane operations on **Ixia Chassis & Appliances(Novus, AresOne)** is now publicly downloadable (but can only be used with Keysight Licensing Solution)
* Support is added for overload bit and extended ipv4 reachability in `get_states` for isis_lsps in **Ixia Chassis & Appliances(Novus, AresOne)**; gNMI path for `isis_lsps`:
  ```
    +--rw isis-routers
      +--ro isis-router* [name]
          +--ro name     -> ../state/name
          +--ro state
            +--ro name?                  string
            .
            .
            +--ro link-state-database
                +--ro lsp-states
  ```

> The container image paths have changed for some Ixia-C artifacts. Please review **Build Details** for correct paths.

#### Bug Fix(s)
* Memory leak in **Ixia Chassis & Appliances(Novus, AresOne)** is fixed for long duration tests.
* `gosnappi` now correctly validates required primitive types when they're not explicitly set by users.
* IS-IS metric is no longer sent as 63 when configured as 200 (or more than 63) with wide metrics enabled on **Ixia Chassis & Appliances(Novus, AresOne)**.


#### Known Issues
* If `keng-layer23-hw-server` version is upgraded/downgraded, the ports from Ixia Chassis & Appliances(Novus, AresOne) which will be used from this container must be rebooted once before running the tests.
* Adding more than 256 devices on a single ixia-c-port causing failure for Ixia Chassis & Appliances(Novus, AresOne).
* Flow Tx is incremented for flow with tx endpoints as LAG, even if no packets are sent on the wire when all active links of the LAG are down.
* With certain DUTs, ssh service hangs if ISIS L1 MD5 is enabled.
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)


## Release  v0.0.1-4554
> 29th September, 2023

#### About

This build includes bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.12.5](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.12.5/artifacts/openapi.yaml)         |
| snappi                        | [0.12.6](https://pypi.org/project/snappi/0.12.6)        |
| gosnappi                      | [0.12.6](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.12.6)        |
| ixia-c-controller             | [0.0.1-4554](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.85](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.331](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.12.5-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.6](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.12.7](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-4554](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Bug Fix(s)
* `monitor.flow_metrics` will now correctly reports `bytes_tx`.
* The VLAN TPID field in flow packet header configuration is now set to correct default of 65535 when it’s not encapsulating known protocol header.

#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4478
> 14th September, 2023

#### About

This build includes stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.12.3](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.12.3/artifacts/openapi.yaml)         |
| snappi                        | [0.12.3](https://pypi.org/project/snappi/0.12.3)        |
| gosnappi                      | [0.12.3](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.12.3)        |
| ixia-c-controller             | [0.0.1-4478](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.45](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.326](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.12.3-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.6](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.12.5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-4478](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4435
> 1st September, 2023

#### About

This build includes bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.12.2](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.12.2/artifacts/openapi.yaml)         |
| snappi                        | [0.12.2](https://pypi.org/project/snappi/0.12.2)        |
| gosnappi                      | [0.12.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.12.2)        |
| ixia-c-controller             | [0.0.1-4435](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.325](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.12.2-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.4](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.12.4](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-4435](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
`
#### Bug Fix(s)
* `set_config` fails with `unsuccessful Response: RX runtime not configured for port: ` if large port testbed is used on subsequent test runs is fixed.
#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4399
> 21st August, 2023

#### About

This build includes new features.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.12.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.12.1/artifacts/openapi.yaml)         |
| snappi                        | [0.12.1](https://pypi.org/project/snappi/0.12.1)        |
| gosnappi                      | [0.12.1](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.12.1)        |
| ixia-c-controller             | [0.0.1-4399](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.320](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.12.1-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.4](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.12.2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-4399](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
`

# Release Feature(s)
* Support for deprecated control, action and update APIs (`set_transmit_state`, `set_link_state`, `set_capture_state`, `update_flows`, `set_route_state`, `send_ping`, `set_protocol_state`, `set_device_state`) have been removed. Please use following `set_control_state`, `set_control_action` and `update_config` APIs instead of the previous ones. Please refer to [go utils](https://github.com/open-traffic-generator/conformance/commit/ecffd7edf93a4e60105a263cc7a074e2abe26ae4#diff-2f28df5cf5ed455b[…]c48b9ac5ef7ac25e5a018a) and [python utils](https://github.com/open-traffic-generator/conformance/commit/ecffd7edf93a4e60105a263cc7a074e2abe26ae4#diff-205d55e3f01484e637c6b5b597a6dfb44e74638964605a23b20d5fa72e773a38) for further details usage.
* Most properties in OTG with integer data type have been assigned correct integer format (from `uint32`, `uint64`, `int32` and `int64`). Please [click here](https://github.com/open-traffic-generator/models/pull/301) to examine all changes.
* Once you upgrade the new ixia-c release, in addition to removing the deprecated APIs from the test programs, data types of some variables in the test programs might need to be changed to avoid compilation errors.


#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4306
> 4th August, 2023

#### About

This build includes stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.11.11](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.11/artifacts/openapi.yaml)         |
| snappi                        | [0.11.17](https://pypi.org/project/snappi/0.11.17)        |
| gosnappi                      | [0.11.17](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.17)        |
| ixia-c-controller             | [0.0.1-4306](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.318](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.11.11-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.4](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.11.16](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-4306](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |
`

#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4167
> 21st July, 2023

#### About

This build includes new features.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.11.10](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.10/artifacts/openapi.yaml)         |
| snappi                        | [0.11.16](https://pypi.org/project/snappi/0.11.16)        |
| gosnappi                      | [0.11.16](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.16)        |
| ixia-c-controller             | [0.0.1-4167](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.316](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.11.10-13](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.4](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.11.16](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-4167](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |


# Release Feature(s)
* Enabling `metric_tags` for egress tracking is now also supported on ipv6.src/dst, ipv6.traffic_class, ipv6.flow_label and ipv6.payload_length. <b><i>[Ixia-C]</i></b>
  ```go
    eth := flow.EgressPacket().Add().Ethernet()
    ipv6 := flow.EgressPacket().Add().Ipv6()
    ipv6Tag := ipv6.Dst().MetricTags().Add()
    ipv6Tag.SetName("flow_ipv6_dst")
    ipv6Tag.SetOffset(120)
    ipv6Tag.SetLength(8)
  ```
* Support is available in gNMI to fetch the drill-down statistics for egress tracking as follows <b><i>[Ixia-C]</i></b> [details](https://github.com/open-traffic-generator/models-yang/blob/main/artifacts/open-traffic-generator-flow.txt):
    ```
      1. Flow level metrics + Tagged Metrics:
          example path: "flows/flow[name=f1]“
      2. Only Flow level metrics:
          example path: "flows/flow[name=f1]/state“
      3. Only Tagged metrics 
          example path: "flows/flow[name=f1]/tagged-metrics“
      4. Filtered Tagged metrics: 
          example path: "flows/flow[name=f1]/tagged-metrics/tagged-metric[name-value-pairs=flow_ipv6_dst=0x2]”
    ```
# Bug Fix(s)
* For `flow.duration.continuous` type of traffic in Ixia-C, intermittent issue where last few packets in a traffic flow were not accounted for in `flow_metrics.frames_rx` statistics after stopping a flow is fixed.
* Proper error mesage is propagated to user if user has used community edition of Ixia-C (instead of licensed edition) and invoked any API/Configuration not supported by it.
  example: `Device configuration is not supported in free version of controller.`

#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4139
> 29th June, 2023

#### About

This build includes new features.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.11.10](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.10/artifacts/openapi.yaml)         |
| snappi                        | [0.11.16](https://pypi.org/project/snappi/0.11.16)        |
| gosnappi                      | [0.11.16](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.16)        |
| ixia-c-controller             | [0.0.1-4139](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.315](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.11.10-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.11.16](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-4139](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

# Release Features(s)
* Support added for multiple Rx endpoints both port traffic.
  ```go
  // Port Traffic
  flow.SetName("flow:p1->p2,p3").
    TxRx().Port().
    SetTxName("p1").
    SetRxNames([]string{"p2", "p3"})
  ```
* Support added for Rx port disaggregation of flow metrics.
  ```go
  flow := config.Flows().Add().SetName("flow")
  flow.Metrics(). PredefinedMetricTags().SetRxName(true)
  ```

  ```json
  // gNMI state fetch on flows will show the drilldown as given below
  "updates": [
    {
    "Path": "flows/flow[name=f1]",
    "values": {
      "flows/flow": {
      "open-traffic-generator-flow:name": "f1",
      "open-traffic-generator-flow:state": {                     // Contains the aggregated per-flow stats
        ....
      },
      "open-traffic-generator-flow:tag-metrics": {              // Contains the disaggregated per-flow stats
        "tag-metric": [
        {
          "name-value": "rx_name=p2",
          "state": {
            ....
            "name-value": "rx_name=p2",
            "tags": [
              {
              "tag-name": "rx_name",
              "tag-value": 
                {
                  "value-as-string": "p2",
                  "value-type": "STRING"
                }
          ....
        },
        {
          "name-value": "rx_name=p3",
          "state": {
            ....
          }
        }
      ....
    }
  ]
  ```

 
#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4124
> 16th June, 2023

#### About

This build includes new features.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.11.9](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.9/artifacts/openapi.yaml)         |
| snappi                        | [0.11.15](https://pypi.org/project/snappi/0.11.14)        |
| gosnappi                      | [0.11.15](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.14)        |
| ixia-c-controller             | [0.0.1-4124](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.310](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.11.9-6](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.11.14](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-4124](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

# Release Features(s)
* Support added for weighted pairs for packet size distribution in traffic flows.
  - `predefined` packet size distributions supported are `imix`, `ipsec_imix`, `ipv6_imix`, `standard_imix`, `tcp_imix`. It can be configured as follows:
    ```go 
      myFlow.Size().WeightPairs().SetPredefined(gosnappi.FlowSizeWeightPairsPredefined.IMIX)
    ```
  - Custom packet size distribution is also supported. It can configured as follows,
    ```go
      customWeightPairs := myFlow.Size().WeightPairs().Custom()
      customWeightPairs.Add().SetSize(64).SetWeight(7)
      customWeightPairs.Add().SetSize(570).SetWeight(4)
      customWeightPairs.Add().SetSize(1518).SetWeight(1)
    ```
* Support is added for egress tracking based on IPv4 total length.

 
#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4080
> 2nd June, 2023

#### About

This build includes bug fix.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.11.9](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.9/artifacts/openapi.yaml)         |
| snappi                        | [0.11.15](https://pypi.org/project/snappi/0.11.14)        |
| gosnappi                      | [0.11.15](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.14)        |
| ixia-c-controller             | [0.0.1-4080](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.02.21.29](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.11.9-3](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.11.14](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-4080](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

 
#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4064
> 18th May, 2023

#### About

This build includes bug fix.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.11.8](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.8/artifacts/openapi.yaml)         |
| snappi                        | [0.11.14](https://pypi.org/project/snappi/0.11.14)        |
| gosnappi                      | [0.11.14](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.14)        |
| ixia-c-controller             | [0.0.1-4064](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.02.21.17](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.11.8-12](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.11.13](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-4064](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

# Bug Fix(s)
* [Stop exposing TLS 1.0/1.1 ](https://github.com/open-traffic-generator/ixia-c/issues/125) in `ixia-c-controller`.
 
#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-4013
> 5th May, 2023

#### About

This build includes new features.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.11.8](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.8/artifacts/openapi.yaml)         |
| snappi                        | [0.11.14](https://pypi.org/project/snappi/0.11.14)        |
| gosnappi                      | [0.11.14](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.14)        |
| ixia-c-controller             | [0.0.1-4013](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.299](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.11.8-8](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.11.13](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-4013](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

# Release Features(s)
* Egress tracking now also supports tracking for `vlan`, `mpls` packet headers.
* Support added in `ixia-c-gnmi-server` for fetching Latency measurements.
  - User can enable latency measurement by setting `f1.Metrics().SetEnable(true).Latency().SetEnable(true)`.
    - Only `cut_through` latency mode  is supported.
  - User can fetch latency measurements using given models-yang path.
    ```
      module: open-traffic-generator-flow
      +--rw flows
        +--ro flow* [name]
            +--ro name              -> ../state/name
            +--ro state
            |  ....
            |  ....
            |  +--ro minimum-latency?   otg-types:timeticks64
            |  +--ro maximum-latency?   otg-types:timeticks64
            |  +--ro average-latency?   otg-types:timeticks64
            |  ....
            |  ....

    ```

# Bug Fix(s)
* Intermittent crash in ixia-c-controller while fetching `flow_metrics` is fixed.
 
#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-3927
> 24th April, 2023

#### About

This build includes new features.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.11.8](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.8/artifacts/openapi.yaml)         |
| snappi                        | [0.11.14](https://pypi.org/project/snappi/0.11.14)        |
| gosnappi                      | [0.11.14](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.14)        |
| ixia-c-controller             | [0.0.1-3927](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.298](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.11.8-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.11.10](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3927](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

# Release Features(s)
* A new property `egress_packet` inside flow has been introduced to configure expected packet shape as it is received on the test port.
      ```go
        eth := flow.EgressPacket().Add().Ethernet()
        ipv4 := flow.EgressPacket().Add().Ipv4()
      ```
* A new property `metric_tags` has been introduced for fields inside headers configured in `egress_packet` to enable tracking metrics for each applicable value corresponding to a portion of or all bits inside the field.
    ```go
      ipv4Tag := ipv4.Dst().MetricTags().Add()
      ipv4Tag.SetName("flow_ipv4_dst")
      ipv4Tag.SetOffset(24)
      ipv4Tag.SetLength(8)
    ```
   -  As of this release, enabling metric_tags is only supported on ethernet.src/dst, ipv4.src/dst, ipv4.tos. Support for more fields shall be added in upcoming releases.

  - Limitations:
    - The total number of tracking bits available on an ixia-c Rx port is 12 bits. Out of these some of the bits are needed for tracking flows, example 2 flows need 1 bit, 4 flows need 2 bits, 8 flows need 3 bits etc. The sum of `metric_tag.length` for each field inside each header configured in `egress_packet` cannot exceed the remaining bits available on the Rx port.
    - The total number of tracking fields that can be configured across a set of flows which have the same Rx port, is two.

* A new property is introduced in `get_metrics.flow` to fetch tagged metrics.
 - User can set `get_metrics.flow.tagged_metrics.include=false` not to include `tagged_metrics` in the `flow_metrics` response. 
 - Specific `tagged_metrics` can be fetched by setting `get_metrics.flow.tagged_metrics.filters[i].name`.
 
#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-3889
> 31st March, 2023

#### About

This build includes new features.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.11.4](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.4/artifacts/openapi.yaml)         |
| snappi                        | [0.11.6](https://pypi.org/project/snappi/0.11.6)        |
| gosnappi                      | [0.11.6](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.6)        |
| ixia-c-controller             | [0.0.1-3889](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.290](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.11.4-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.11.5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3889](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

### Features(s)
* All API response errors over gRPC and HTTP transport can now be inspected like so:
    ``` snappi
        # snippet of error handling in snappi
        try:
        # call set config
        api.set_config(payload)
        except Exception as e:
            err = api.from_exception(e)  # helper function to parse exception
            if err is not None: # exception was of otg error format
                print(err.code)
                print(err.errors)
            else: # some other exception
                print(e)
    ```

    ``` gosnappi
        // gosnappi snippet for error handling
        resp, err := api.SetConfig(config)
        if err != nil {
            // helper function to parse error
            // retuns a bool with err, indicating wheather the error was of otg error format 
            errSt, ok := api.FromError(err)
            if ok {
                fmt.Println(errSt.Code())
                if errSt.errSt.HasKind() {
                fmt.Println(errSt.Kind())
                }
                fmt.Println(errSt.Errors())
            } else {
                fmt.Println(err.Error())
            }
        }
    ```


#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-3865
> 16th March, 2023

#### About

This build includes new features.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.11.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.11.1/artifacts/openapi.yaml)         |
| snappi                        | [0.11.1](https://pypi.org/project/snappi/0.11.1)        |
| gosnappi                      | [0.11.1](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.11.1)        |
| ixia-c-controller             | [0.0.1-3865](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.283](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.11.1-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.11.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3865](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

### Features(s)
* Warning messages shall now be automatically printed on STDOUT if a property or an API with status deprecated or under-review is exercised in `snappi` / `gosnappi`. This may also lead to linters raising deprecation error.
* New API endpoints `/control/state` and `/control/action` have been exposed consolidating pre-existing API endpoints inside `/control/` (now deprecated) in order to reduce API surface and introducing clean organization. Please see [snappi-tests utils](https://github.com/open-traffic-generator/snappi-tests/blob/main/tests/utils/common.py) for usage.
* API endpoints `/results/*` have now been renamed to `/monitor/*` .


#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-3841
> 3rd March, 2023

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages), We stopped publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom).

#### About

This build includes new features.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.10.12](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.10.12/artifacts/openapi.yaml)         |
| snappi                        | [0.10.9](https://pypi.org/project/snappi/0.10.9)        |
| gosnappi                      | [0.10.9](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.10.9)        |
| ixia-c-controller             | [0.0.1-3841](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.35](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.279](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.10.12-2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.10.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3841](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

### Features(s)
* API version compatibility check is now automatically performed between ixia-c containers upon API calls to `ixia-c-controller` . It can be disabled by booting `ixia-c-controller` container with `--disable-version-check` flag.
* API version compatibility check can now be automatically performed between `snappi`/`gosnappi` and ixia-c-controller upon API calls by enabling version check flag in API handle like so:
    - gosnappi
    ```
        api := gosnappi.NewApi()
        api.SetVersionCompatibilityCheck(true)
    ````
    - snappi
    ```
        api = snappi.api(version_check=True)
    ```
    In upcoming releases, this will be enabled by default.


#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-3807
> 17th February, 2023

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages), We stopped publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom).

#### About

This build contains bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.10.9](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.10.9/artifacts/openapi.yaml)         |
| snappi                        | [0.10.7](https://pypi.org/project/snappi/0.10.7)        |
| gosnappi                      | [0.10.7](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.10.7)        |
| ixia-c-controller             | [0.0.1-3807](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.30](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.271](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.10.7-8](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.10.14](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3807](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

### Bug Fix(s)
* Concurrent API calls (where at least one call was `set_config`) to `ixia-c-controller` was resulting in crash.

#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-3767
> 2nd February, 2023

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages), We stopped publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom).

#### About

This build contains bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.10.7](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.10.7/artifacts/openapi.yaml)         |
| snappi                        | [0.10.5](https://pypi.org/project/snappi/0.10.5)        |
| gosnappi                      | [0.10.5](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.10.5)        |
| ixia-c-controller             | [0.0.1-3768](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.29](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.271](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.10.7-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.10.8](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3768](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

### Bug Fix(s)
* Issue where TCP header length was not set correctly is fixed. [#117](https://github.com/open-traffic-generator/ixia-c/issues/117)

#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-3724
> 20th January, 2023

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages), We stopped publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom).

#### About

This build contains bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.10.6](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.10.6/artifacts/openapi.yaml)         |
| snappi                        | [0.10.4](https://pypi.org/project/snappi/0.10.4)        |
| gosnappi                      | [0.10.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.10.4)        |
| ixia-c-controller             | [0.0.1-3724](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.24](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.256](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.10.6-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.10.6](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3722](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

### Bug Fix(s)
* Payload size field in all inner headers for tunneling protocols do not take into account inner FCS is fixed. [#112](https://github.com/open-traffic-generator/ixia-c/issues/112)


#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.0.1-3698
> 15th December, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages), We stopped publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom).

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.10.5](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.10.5/artifacts/openapi.yaml)         |
| snappi                        | [0.10.3](https://pypi.org/project/snappi/0.10.3)        |
| gosnappi                      | [0.10.3](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.10.3)        |
| ixia-c-controller             | [0.0.1-3698](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.252](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-operator               | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.10.5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3698](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |


#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.0.1-3662
> 1st December, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.9.10](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.10/artifacts/openapi.yaml)         |
| snappi                        | [0.9.8](https://pypi.org/project/snappi/0.9.8)        |
| gosnappi                      | [0.9.8](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.8)        |
| ixia-c-controller             | [0.0.1-3662](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.243](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-operator               | [0.3.0](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.9.9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3662](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

### Features(s)
* `ixia-c-controller` now runs with a non-root user inside the container (instead of root user previously)
* `ixia-c-controller` now listens on non-privileged HTTPs port 8443 (instead of 443 previously)


#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.


## Release  v0.0.1-3619
> 10th November, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.9.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.1/artifacts/openapi.yaml)         |
| snappi                        | [0.9.4](https://pypi.org/project/snappi/0.9.4)        |
| gosnappi                      | [0.9.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.4)        |
| ixia-c-controller             | [0.0.1-3619](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.238](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-operator               | [0.2.6](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.9.7](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3619](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

### Features(s)
* `ixia-c-controller` and `ixia-c-gnmi-server` can now accept the environment variables `HTTP_PORT` and `HTTP_SERVER` respectively, overriding the values provided for corresponding arguments `--http-port` and `--http-server`.

* `ixia-c-controller` and `ixia-c-gnmi-server` can now be run using an arbitrary UID (user ID), to support deployment in OpenShift environment.

#### Bug Fix(s)
* Fixed [#15](https://github.com/open-traffic-generator/ixia-c-operator/issues/15).


#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.0.1-3587
> 28th October, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### About

This build contains bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.9.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.1/artifacts/openapi.yaml)         |
| snappi                        | [0.9.4](https://pypi.org/project/snappi/0.9.4)        |
| gosnappi                      | [0.9.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.4)        |
| ixia-c-controller             | [0.0.1-3587](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.236](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-operator               | [0.2.5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.9.5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3587](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |


#### Bug Fix(s)

* [#101](https://github.com/open-traffic-generator/ixia-c/issues/101) fixed.


#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.


## Release  v0.0.1-3423
> 29th September, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.9.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.1/artifacts/openapi.yaml)         |
| snappi                        | [0.9.4](https://pypi.org/project/snappi/0.9.4)        |
| gosnappi                      | [0.9.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.4)        |
| ixia-c-controller             | [0.0.1-3423](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.232](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-operator               | [0.2.2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.9.5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3423](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Known Limitations

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.0.1-3383
> 16th September, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.9.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.1/artifacts/openapi.yaml)         |
| snappi                        | [0.9.4](https://pypi.org/project/snappi/0.9.4)        |
| gosnappi                      | [0.9.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.4)        |
| ixia-c-controller             | [0.0.1-3383](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.17](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.225](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-operator               | [0.2.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.9.3](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3380](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Release Features(s)

* Support added for `increment` and `decrement` `values` in all `MPLS` packet header fields. 
* Support added for raw traffic where `tx` and `rx` endpoints could be same.
* Support added in `traffic-engine-service` deployment to disable IPv6 networking.
    - `OPT_ENABLE_IPv6` environment flag is introduced. If it is `Yes` ipv6 networking will be enabled and if it is `No` ipv6 networking status will be unchanged.

#### Bug Fix(s)

* `get_config` is failing, if config contains TCP header. it is fixed now. [#184](https://github.com/open-traffic-generator/snappi/issues/184)

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets

## Release  v0.0.1-3182 (Latest)
> 1st September, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.9.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.1/artifacts/openapi.yaml)         |
| snappi                        | [0.9.3](https://pypi.org/project/snappi/0.9.3)        |
| gosnappi                      | [0.9.3](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.3)        |
| ixia-c-controller             | [0.0.1-3182](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.217](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-operator               | [0.2.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.9.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3182](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Release Features(s)

* `ixia-c-controller` container now supports gRPC requests on default TCP port 40051 (alongside TCP port 8443 for HTTP) and hence `ixia-c-grpc-server` container is no longer needed.
* There has been a breaking change in OTG API to provide stronger compatibility guarantees across different `semver patch versions` of snappi and ixia-c-controller.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets

## Release  v0.0.1-3113
> 18th August, 2022

#### Announcement

From now onwards `ixia-c` container images will be hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) as well for the next 3 months. (until 18th November, 2022)

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.8.6](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.6/artifacts/openapi.yaml)         |
| snappi                        | [0.8.8](https://pypi.org/project/snappi/0.8.8)        |
| gosnappi                      | [0.8.8](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.8)        |
| ixia-c-controller             | [0.0.1-3113](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.214](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-operator               | [0.1.95](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.8.13](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-grpc-server            | [0.8.9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-grpc-server)         |
| ixia-c-one                    | [0.0.1-3113](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Release Features(s)

* Support added for setting transmit state on subset of configured flows.
  https://github.com/open-traffic-generator/ixia-c/issues/56

#### Bug Fix(s)

* When flow duration is configured using `fixed_seconds`, then in some cases packet transmission does not stop after specified duration has elapsed.
  https://github.com/open-traffic-generator/ixia-c/issues/95

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets


## Release  v0.0.1-3027
> 4th August, 2022

#### About

Support added for static `MPLS` packet header in flows.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.8.6](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.6/artifacts/openapi.yaml)         |
| snappi                        | [0.8.8](https://pypi.org/project/snappi/0.8.8)        |
| gosnappi                      | [0.8.8](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.8)        |
| ixia-c-controller             | [0.0.1-3027](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.209     | 
| ixia-c-operator               | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.8.10](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.8.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |
| ixia-c-one                    | [0.0.1-3027](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Release Features(s)

* Support added for static `MPLS` packet header in flows.
    - Fixed value is supported for all fields.
    - Dynamic `MPLS` is not supported yet.
        - `label` field's  default choice is `value` if it is selected as `auto`.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-3002
> 27th July, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.8.5](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.5/artifacts/openapi.yaml)         |
| snappi                        | [0.8.5](https://pypi.org/project/snappi/0.8.5)        |
| gosnappi                      | [0.8.5](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.5)        |
| ixia-c-controller             | [0.0.1-3002](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.205     | 
| ixia-c-operator               | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.8.8](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.8.7](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |
| ixia-c-one                    | [0.0.1-3002](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.


## Release  v0.0.1-3000
> 21st July, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.8.5](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.5/artifacts/openapi.yaml)         |
| snappi                        | [0.8.5](https://pypi.org/project/snappi/0.8.5)        |
| gosnappi                      | [0.8.5](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.5)        |
| ixia-c-controller             | [0.0.1-3000](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.203     | 
| ixia-c-operator               | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.8.8](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.8.7](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |
| ixia-c-one                    | [0.0.1-3000](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.


## Release  v0.0.1-2994
> 1st July, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.8.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.1/artifacts/openapi.yaml)         |
| snappi                        | [0.8.2](https://pypi.org/project/snappi/0.8.2)        |
| gosnappi                      | [0.8.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.2)        |
| ixia-c-controller             | [0.0.1-2994](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.192     | 
| ixia-c-operator               | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.8.3](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.8.2](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |
| ixia-c-one                    | [0.0.1-2994](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2992
> 30th June, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.8.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.1/artifacts/openapi.yaml)         |
| snappi                        | [0.8.2](https://pypi.org/project/snappi/0.8.2)        |
| gosnappi                      | [0.8.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.2)        |
| ixia-c-controller             | [0.0.1-2992](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.191     | 
| ixia-c-operator               | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.8.3](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.8.2](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |
| ixia-c-one                    | [0.0.1-2992](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2969
> 16th June, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.15](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.15/openapi.yaml)         |
| snappi                        | [0.7.41](https://pypi.org/project/snappi/0.7.41)        |
| gosnappi                      | [0.7.41](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.41)        |
| ixia-c-controller             | [0.0.1-2969](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.181     | 
| ixia-c-operator               | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.7.31](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.17](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |
| ixia-c-one                    | [0.0.1-2969](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2934
> 2nd June, 2022

#### About

This build contains bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.13](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.13/openapi.yaml)         |
| snappi                        | [0.7.37](https://pypi.org/project/snappi/0.7.37)        |
| gosnappi                      | [0.7.37](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.37)        |
| ixia-c-controller             | [0.0.1-2934](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.26](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.174     | 
| ixia-c-operator               | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.7.27](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.15](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |
| ixia-c-one                    | [0.0.1-2934](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Bug Fix(s)
* `ixia-c-controller` will return an empty response instead of error when `metrics` / `states` are queried right after boot-up.
* `ixia-c-gnmi-server` will return an empty response instead of error when `metrics` / `states` are queried without ever setting config

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2897
> 19th May, 2022

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml)         |
| snappi                        | [0.7.18](https://pypi.org/project/snappi/0.7.18)        |
| gosnappi                      | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)        |
| ixia-c-controller             | [0.0.1-2897](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.26](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.165     | 
| ixia-c-operator               | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.7.23](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.12](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |
| ixia-c-one                    | [0.0.1-2897](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### New Feature(s)

* `ixia-c-one` is now supported on platforms with `cgroupv2` enabled. https://github.com/open-traffic-generator/ixia-c/issues/77

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2801
> 9th May, 2022

#### About

This build includes stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml)         |
| snappi                        | [0.7.18](https://pypi.org/project/snappi/0.7.18)        |
| gosnappi                      | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)        |
| ixia-c-controller             | [0.0.1-2801](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.26](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.158     | 
| ixia-c-operator               | [0.1.89](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.7.15](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2790
> 5th May, 2022

#### About

This build includes stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml)         |
| snappi                        | [0.7.18](https://pypi.org/project/snappi/0.7.18)        |
| gosnappi                      | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)        |
| ixia-c-controller             | [0.0.1-2790](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.26](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.158     | 
| ixia-c-operator               | [0.0.80](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.7.15](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2770
> 21st April, 2022

#### About

This build includes stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml)         |
| snappi                        | [0.7.18](https://pypi.org/project/snappi/0.7.18)        |
| gosnappi                      | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)        |
| ixia-c-controller             | [0.0.1-2770](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.0.0.275](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.154     | 
| ixia-c-operator               | [0.0.80](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.7.13](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.


## Release  v0.0.1-2755
> 7th April, 2022

#### About

This build includes following bug fix
- Clearing of `port` and `flow` statistics as part of `set_config`.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml)         |
| snappi                        | [0.7.18](https://pypi.org/project/snappi/0.7.18)        |
| gosnappi                      | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)        |
| ixia-c-controller             | [0.0.1-2755](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.23](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.152     | 
| ixia-c-operator               | [0.0.75](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### Bug Fix(s)

* Clearing of `port` and `flow` statistics is now part of `set_config`. 

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2738
> 25th March, 2022

#### About

This build includes following new functionalities
- fix in handling of `ether_type` field of ethernet packet

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml)         |
| snappi                        | [0.7.18](https://pypi.org/project/snappi/0.7.18)        |
| gosnappi                      | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)        |
| ixia-c-controller             | [0.0.1-2738](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.23](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.151     | 
| ixia-c-operator               | [0.0.75](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### New Feature(s)

* Users would be able to set `ether_type` in ethernet header which may not be based on the next header type.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2727
> 24th March, 2022

#### About

This build includes following new functionalities
- correct received(rx) rate statistics in port metrics
- auto destination mac learning support in destination mac field of ethernet packet

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml)         |
| snappi                        | [0.7.18](https://pypi.org/project/snappi/0.7.18)        |
| gosnappi                      | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)        |
| ixia-c-controller             | [0.0.1-2727](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.23](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.151     | 
| ixia-c-operator               | [0.0.75](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### New Feature(s)

* Correct received(rx) rate statistics support is incorporated as part of port metrics.
    * `frames_rx_rate`
    * `bytes_rx_rate`

* [Breaking Change] Auto learning of destination MAC is currently supported for both IPv4 and IPv6 Flows without any VLAN(originated from device endpoints) by setting ethernet destination with `choice` as `auto` in the packet. Earlier this was working by setting ethernet destination mac with "00:00:00:00:00:00" in the packet header.
    ```
        {
            "choice": "ethernet",
            "ethernet": {
                "dst": {
                    "choice": "auto"
                },
                "src": {
                    "choice": "value",
                    "value": "00:00:01:01:01:01"
                }
            }
        },
    ````

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2678
> 11th March, 2022

#### About

This build contains stability and debuggability enhancements.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.3](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.3/openapi.yaml)         |
| snappi                        | [0.7.13](https://pypi.org/project/snappi/0.7.13)        |
| gosnappi                      | [0.7.13](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.13)        |
| ixia-c-controller             | [0.0.1-2678](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.23](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.146     | 
| ixia-c-operator               | [0.0.75](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.7.5](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.7](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2662
> 24th February, 2022

#### About

This build implements transmit(tx) statistics & transmit state of flow metrics.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.3](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.3/openapi.yaml)         |
| snappi                        | [0.7.13](https://pypi.org/project/snappi/0.7.13)        |
| gosnappi                      | [0.7.13](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.13)        |
| ixia-c-controller             | [0.0.1-2662](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.23](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.144     | 
| ixia-c-operator               | [0.0.75](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.7.5](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.6](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### New Feature(s)

* Transmit(tx) statistics & Transmit state support is incorporated as part of flow metrics.
    * `transmit`
    * `frames_tx`
    * `frames_tx_rate`

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2610
> 10th February, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.3](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.3/openapi.yaml)         |
| snappi                        | [0.7.13](https://pypi.org/project/snappi/0.7.13)        |
| gosnappi                      | [0.7.13](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.13)        |
| ixia-c-controller             | [0.0.1-2610](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.5](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.133     | 
| ixia-c-operator               | [0.0.72](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.7.5](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.5](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.



## Release v0.0.1-2597
> 27th January, 2022

#### About

This build contains debuggability enhancements.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.2](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.2/openapi.yaml)         |
| snappi                        | [0.7.6](https://pypi.org/project/snappi/0.7.6)        |
| gosnappi                      | [0.7.6](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.6)        |
| ixia-c-controller             | [0.0.1-2597](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.2](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.133     | 
| ixia-c-operator               | [0.0.70](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.7.4](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.4](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2543
> 16th December, 2021

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.2](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.2/openapi.yaml)         |
| snappi                        | [0.7.3](https://pypi.org/project/snappi/0.7.3)        |
| gosnappi                      | [0.7.3](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.3)        |
| ixia-c-controller             | [0.0.1-2543](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.2](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.127     | 
| ixia-c-operator               | [0.0.70](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.7.2](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.2](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.
## Release v0.0.1-2446
> 2nd December, 2021

#### About

This build introduces ability to return large `FramesTx/RX` values by `metric` APIs.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.6.13](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.13/openapi.yaml)         |
| snappi                        | [0.6.21](https://pypi.org/project/snappi/0.6.21)        |
| gosnappi                      | [0.6.21](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.6.21)        |
| ixia-c-controller             | [0.0.1-2446](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.0.15](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.115     | 
| ixia-c-operator               | [0.0.70](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.6.18](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.6.17](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |


#### New Feature(s)

* Maximum `FramesTx` and `FramesRx` value that can be correctly returned by `flow_metrics` and `port_metrics` has been increased from 2147483648 to 9.223372e+18

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2399
> 18th November, 2021

#### About

This build introduces ability to auto plug in default values for missing fields with primitive types upon receiving JSON payload.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.6.10](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.10/openapi.yaml)         |
| snappi                        | [0.6.16](https://pypi.org/project/snappi/0.6.16)        |
| gosnappi                      | [0.6.16](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.6.16)        |
| ixia-c-controller             | [0.0.1-2399](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.0.15](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.111     | 
| ixia-c-operator               | [0.0.70](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.6.14](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.6.15](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |


#### New Feature(s)

* Upon receiving JSON payload, ixia-c-controller will now automatically plug in default values for missing fields with primitive types.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2367
> 5th November, 2021

#### About

This build introduces uniform logging across some Ixia-c components.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.6.7](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.7/openapi.yaml)         |
| snappi                        | [0.6.12](https://pypi.org/project/snappi/0.6.12)        |
| gosnappi                      | [0.6.12](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.6.12)        |
| ixia-c-controller             | [0.0.1-2367](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.0.15](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.96      | 
| ixia-c-operator               | 0.0.1-65       | 
| ixia-c-gnmi-server            | [0.6.11](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.6.11](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)         |


#### Bug Fix(s)

* Introduced structured logging for `ixia-c-gnmi-server` and `ixia-c-grpc-server` to aid uniform logging across Ixia-c components.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2342
> 27th October, 2021

#### About

This build contains validation bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.6.5](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.5/openapi.yaml)         |
| snappi                        | [0.6.5](https://pypi.org/project/snappi/0.6.5)        |
| gosnappi                      | [0.6.5](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.6.5)        |
| ixia-c-controller             | [0.0.1-2342](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.0.15](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.83      | 
| ixia-c-operator               | 0.0.1-65       | 
| ixia-c-gnmi-server            | [0.6.6](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.6.6](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)         |


#### Bug Fix(s)

* Validation has been fixed for traffic configuration consisting of IPv4 and IPv6 interface names

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.


## Release v0.0.1-2337
> 21st October, 2021

#### About

This build contains bugfixes for SetConfig and FPS values in GetMetrics.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.6.5](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.5/openapi.yaml)         |
| snappi                        | [0.6.5](https://pypi.org/project/snappi/0.6.5)        |
| gosnappi                      | [0.6.5](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.6.5)        |
| ixia-c-controller             | [0.0.1-2337](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.0.14](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.83      | 
| ixia-c-operator               | 0.0.1-65       | 
| ixia-c-gnmi-server            | [0.6.6](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.6.6](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)         |


#### New Feature(s)

* The race condition during connection initialization in `SetConfig` is fixed for scenarios involving large port count.
* FPS value in `GetMetrics` for ports and flows is fixed for scenarios involving multiple consecutive SetTransmitState calls.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2289
> 29th September, 2021

#### About

This build contains support for performance optimisation through concurrent port operations.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.6.1](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.1/openapi.yaml)         |
| snappi                        | [0.6.1](https://pypi.org/project/snappi/0.6.1)        |
| ixia-c-controller             | [0.0.1-2289](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.0.13](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.70      | 
| otg-gnmi-server               | [0.6.1](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)         |
| otg-grpc-server               | [0.6.1](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)         |


#### New Feature(s)

* Performance is optimised through concurrent port operations.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.


## Release v0.0.1-2185 
> 8th September, 2021

#### About

This build contains support for updating flow rate without disrupting transmit state.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.5.4](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.5.4/openapi.yaml)         |
| snappi                        | [0.5.3](https://pypi.org/project/snappi/0.5.3)        |
| ixia-c-controller             | [0.0.1-2185](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.0.11](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.56     | 
| otg-gnmi-server               | [0.5.2](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)         |
| otg-grpc-server               | [0.5.3](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)         |


#### New Feature(s)

* Updating flow rate without disrupting transmit state is now supported. Rate of multiple flows can be updated simultaneously through `update_flows` api without stopping the traffic. 

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.


## Release v0.0.1-2120 
> 27th August, 2021

#### About

This build contains support for capture filter, setting GRE checksum flag, redirecting Ixia-c controller log to stdout and some bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.4.12](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.4.12/openapi.yaml)         |
| snappi                        | [0.4.25](https://pypi.org/project/snappi/0.4.25)        |
| ixia-c-controller             | [0.0.1-2120](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.0.9](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.50     | 
| otg-gnmi-server               | [0.4.4](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)         |
| otg-grpc-server               | [0.0.9](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)         |


#### New Feature(s)

* Capture filters are now supported. Multiple patterns can be specified in the configuration.
* Controller log is now redirected to stdout. `docker logs` can now be used to access Ixia-c controller logs.
* Checksum field in `GRE` header now can be set.

#### Bug Fixes

* All patterns of IPv6 value now can be set for `increment` and `decrement` properties in flow header fields.
* Default value of step for `decrement` properties in flow header fields is now set correctly.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.


## Release v0.0.1-1622
> 25th June, 2021

#### About

This build contains support for protocols GRE and VXLAN (RFC 2784), enabling/disabling flow metrics and some bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.4.0](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.4.0/openapi.yaml) |
| snappi                        | 0.4.0         |
| ixia-c-controller             | 0.0.1-1622    |
| ixia-c-traffic-engine         | 1.4.0.1       |
| ixia-c-app-usage-reporter     | 0.0.1-36      |

#### New Feature(s)

* Flow header configuration for protocols `GRE` and `VXLAN (RFC 2784)` are now supported.
* Flow metrics is now disabled by default to allow transmitting packets with `unaltered payload `(i.e. without any timestamps and instrumentation bytes embedded in it).
* Flow metrics (including metrics that are its sub-properties, e.g. `latency` and `timestamp`) can now be explicitly enabled on per-flow basis.

#### Bug Fixes

* `ixia-c-controller` can now safely serve multiple parallel requests from different clients preventing any undefined behavior.
* Port metrics can now be fetched for ports which are not part of flow configuration.
* Providing port locations for `ixia-c-traffic-engine` running in unsupported mode will now throw a user-friendly error.
* Default values for `increment` and `decrement` properties in flow header fields are now aligned per Open Traffic Generator API.

#### Known Issues

* Checksum field in `GRE` header currently cannot be set.
* The metric `loss` in flow metrics is currently not supported.


## Release v0.0.1-1388
> 31st May, 2021

#### About

This build contains support for flow delay and some bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.3.10](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.3.10/openapi.yaml) |
| snappi                        | 0.3.20        |
| ixia-c-controller             | 0.0.1-1388    |
| ixia-c-traffic-engine         | 1.2.0.12      |
| ixia-c-app-usage-reporter     | 0.0.1-36      |

#### New Feature(s)

* Ixia-c now supports `delay` parameter in flow configuration.  Refer to [v0.3.10](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.3.10/openapi.yaml) of the Open Traffic Generator API specification for more details.

#### Bug Fixes

* The flow configuration parameter `inter_burst_gap` when specified in nanoseconds can now be set to a value larger than 4.2 seconds.
* Invalid values can now be set for the `phb` (per hob behavior) field in the DSCP bits in the IPv4 header.
* The `set_config` method will return an error when flows are over subscribed.
* Fixed an error in calculation for packet counts when `duration` is set in terms of fixed_seconds.

#### Known Issues

* The metrics `frames_rx_rate` and `bytes_rx_rate` in port statistics are not calculated correctly and are always zero.
* The metric `min_latency_ns` in flow statistics is not calculated correctly and is always zero.

# Licensing

## License consumption mechanism and feature licenses

Elastic Network Generator [licenses](../licensing.md) include the following features which depends on the license edition. Details on how the features are consumed are as follows:

### Feature Licenses

| Feature Licenses                    | Developer            | Team            | System                 |
|-------------------------------------|----------------------|-----------------|------------------------|
| KENG-SEAT                           | 1                    |  8              |  16                    |
| KENG-SEAT​-UHD                       | N/A                  |  8              |  16                    |
| KENG-SEAT​-IXHW                      | N/A                  |  N/A            |  16                    |
| KENG-DPLU                           | 50                   |  400            |  800                   |
| KENG-CPLU                           | 50                   |  400            |  800                   |
| KENG-UNLIMITED-CP                   | N/A                  |  N/A            |  16                    |

The exact list of feature licenses that are required by a specific test configuration, is calculated based on the test port type, port speed, protocol, protocol sessions, and etc. Overall, the list of required licenses is referred to as Test Cost.

### Test Cost Calculation

```
Test Cost = Seat Cost + CP Cost * KENG-CPLU + DP Cost * KENG-DPLU​
```

| Port Type        | Condition                     | Seat Cost                                                             | CP Cost                            | DP cost                        |
|------------------|-------------------            |-----------------------------------------------------------------------|-------------------------           |---------------                 |
| Ixia-c SW        | `If CP Cost <= 50`            |  `1x KENG-SEAT`                                                       |  `SUM (Protocol Cost)`            ​ |  `SUM (Speed Cost)`            |
| Ixia-c SW        | `If CP Cost > 50`<sup>3</sup> |  `1x KENG-SEAT`<br/>`1x KENG-UNLIMITED-CP`                            |  `50`                              |  `SUM (Speed Cost)`            |
| UHD400T          | `If CP Cost <= 50`​            |  `1x KENG-SEAT`​<br/>`1x KENG-SEAT-UHD`​                                |  `SUM (Protocol Cost)​`             |  `0`                           |
| UHD400T          | `If CP Cost > 50`<sup>3</sup> |  `1x KENG-SEAT`<br/>`1x KENG-SEAT-UHD`<br/>`1x KENG-UNLIMITED-CP`     |  `50`                              |  `0`                           |
| IxOS Hardware    |                               |  `1x KENG-SEAT`<br/>`1x KENG-SEAT-IXHW`​                               |  `0`                               |  `0`                           |

- **Seat** is the number of the running `keng-controller` instances, with a configuration that exceeds the capabilities of the Community Edition.
- **The Data Plane License Unit** (`KENG-DPLU`) is associated with the traffic port capacity.
The number of required units is determined as a sum of the configured port speeds (1, 10, 25, 40, 50, 100GE). The maximum port performance might be less than the configured port speed.
- **The Control Plane License unit** (`KENG-CPLU`) is associated with the control plane protocol scale. The number of required CP units is determined as a sum of the configured protocol sessions.
- If `KENG-UNLIMITED-CP` is not available, an exact number of `KENG-CPLU` will be consumed.
- See [Control Plane Cost](#control-plane-cost) for the `Protocol Cost` and [Data Plane Cost](#data-plane-cost) for the `Speed Cost`.

### Control Plane Cost

Applies only to the Ixia-c software and UHD400T ports.

```
CP Cost = For each Port: SUM (Protocol Cost)
```

| Protocol                     | Session Definition                                                                       | Protocol Cost/Session | Comment                                   |
|------------------------------|-----------------------------------------                                                 |-----------------------|-----------------------                    |
| IP Interface (ARP, ND)       | devices: <br /> - ethernets: <br /> - ipv4_addresses:<br />  - ipv6_addresses:           |  0                    |                                           |
| IP Loopbacks​                 | devices: <br /> - ipv4_loopbacks:<br />  - ipv6_loopbacks:                               |  0                    |                                           |
| LLDP​                         | lldp: <br /> - connection:<br />  - port_name:                                           |  1                    | Session = Test Port with LLDP enabled     |
| LACP                         | lacp: <br /> - ports:<br />  - port_name: <br /> lacp:                                   |  1                    | Session = LAG group, no matter group size​ |
| BGP                          | devices: <br /> - bgp: <br /> - ipv4_addresses:<br />  - ipv6_addresses: <br />- peers:​  | 1                     | Session = BGP peer                        |
| ISIS                         | devices: <br /> - isis: <br /> - interfaces:<br />  - eth_name: ​                         | 1                     | Session = ISIS interface                  |
| RSVP                         | devices: <br /> - rsvp: <br /> - ipv4_interfaces:<br />  - neighbor_ip: ​                 | 1                     | Session = RSVP neighbor​                   |

### Data Plane Cost

Applies only to the Ixia-c software ports.

| Test Port Speed        | DP Cost         |
|------------------------|-----------------|
| 1GE                    | 1               |
| 10GE                   | 10              |
| 25GE                   | 25              |
| 40GE                   | 40              |
| 50GE                   | 50              |
| 100GE                  | 100             |
| 200GE                  | 200             |
| 400GE                  | 400             |

## Sample license consumption scenarios

### Test configuration

Number of `keng-controller` instances: `1`

* Number of ports: `4`
* Port type: `Ixia-c software`
* Port Speed: `100GE`
* Protocol scale: `100 BGP sessions/port`

### Scenario 1: Limited control plane licenses

```
KENG-SEAT:         1 = (1 keng-controller instance and ixia-c SW port)
KENG-DPLU:         400 = (100G speed * 4 ports)
KENG-CPLU:         400 = (100 BGP sessions/port * 4 ports)
```

### Scenario 2: Unlimited control plane licenses

```
KENG-SEAT:         1 = (1 keng-controller instance and ixia-c SW port)
KENG-DPLU:         400 = (100G speed * 4 ports)
KENG-CPLU:         50 = (CP cost = 400 (100 BGP sessions/port * 4 ports) which is greater than 50 and unlimited cp capability is present)
KENG-UNLIMITED-CP: 1
```

## Q&A

<details>
<summary>When the licenses are checked-out / checked-in?</summary>
<br>
The license check-out/check-in mechanism in the keng-controller works as follows:</br>

1. Calculate the Test Cost. For example,  Test Cost = N.</br>
2. Based on the calculation performed in step (1), check-out the licenses at the time of the OTG SetConfig API call.</br>
3. Execute the test if license check-out is successful.</br>
4. For the next configuration, calculate Test Cost, For example, Test Cost = M.</br>

```
if M == N:
    - keng-controller will not have any communication with license servers
else if M > N:
    - keng-controller will not check-in licenses
    - it will attempt to check-out required additional licenses
else if M < N:
    - keng-controller will check-in surplus of the licenses
```
</details>

<details>
<summary>Does licensing have impact on API response time?</summary>
<br>
On the timing aspect, the entire license check-out/check-in mechanism works concurrently with the control plane and the data plane configurations in the ports during the OTG SetConfig operation. Therefore, potentially there is a minimal impact in the OTG SetConfig API response time. If the license server is on a remote site from the controller, the OTG SetConfig API response time might get impacted due to the network latency.
</details>

<details>
<summary>What happens if license servers are not available?</summary>
<br>
The keng-controller can work with up to 4 license servers. The controller tries to connect to all the license servers during the startup. If none of them is available, the controller capabilities are reduced to the Community Edition. After that, a background routine is initiated to make recurrent attempts to connect the configured license servers in 30 second intervals. <br />

Once the controller is able to establish a connection with any of the license servers, for any new configuration beyond capabilities of the Community Edition, the keng-controller will try to check-out a license from the license server with which the connection is established. <br />
</details>

<details>
<summary>What is the message generated when the license server is not available?</summary>
<br>
When a configured license server is not reachable, the log message with error code 13 is generated by the keng-controller:</br>
<br>
"level":"warn","ctx":"impl/licensing","Not all license server could be reached":"code: 13 ...error details... "
</details>

<details>
<summary>What is the error generated when a license cannot be checked out?</summary>
<br>
There are two possible scenarios when the license cannot checkout.<br>
<br>
Scenario 1: Any of the license servers does not have the adequate license features that are required for the test configuration. It will throw an error with the error code 13 and the following error message:<br>
<br>
Current configuration requires following additional license feature(s): {...details...} which is not available in configured license server(s): {...details...} Available license feature(s) in license-server(s) are {...details...}.
<br>
<br>
Scenario 2: Previously active license server is no longer available/reachable. It will throw an error with the error code 13 and the following error message:<br>
<br>
issue consuming license from server ...address...: rpc error: code = DeadlineExceeded desc = context deadline exceeded
<br>
</details>

<details>
<summary>After how many retries things are considered dead and how long does it take?</summary>
<br>
The controller will keep probing the list of license servers that are supplied at the time in the background routine in every 30 seconds during the controller lifetime.
</details>

<details>
<summary>What happens if the controller can't check-out the license for a specific server?</summary>
<br>
The keng-controller will attempt to check out licenses from the next available license server in the configured list.
</details>

<details>
<summary>How long does a license remain checked-out?</summary>
<br>
For the duration of the current test configuration, the license will remain checked-out. Once the new test configuration is applied that doesn't require the license, the license will be checked-in.
</details>

<details>
<summary>How to check-in all the licenses?</summary>
<br>
To check-in all the licenses, apply an empty configuration. Alternatively, gracefully stop the keng-controller container.
</details>

<details>
<summary>What happens of the controller can't check-in the license back?</summary>
<br>
There is a keep-alive mechanism between the controller and the license server. If the controller crashes, is forcefully stopped, or lost the connection to the license server, the licenses will be automatically checked-in after 5 minutes of keep-alive inactivity.
</details>

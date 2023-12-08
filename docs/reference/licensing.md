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

## Liveliness check and timeout on license server communication

### FAQ

<details>
<summary>What is the impact of the frequent license checking on the test execution time for individual test and batch?</summary>
<br>
The license check-out/check-in mechanism in the keng-controller works as follows:

1. Calculate the Test Cost. For example,  Test Cost = N.
2. Based on the calculation performed in step (1), check-out the licenses at the time of the OTG SetConfig API call.
3. Execute the test if license check-out is successful.
4. For the next configuration, calculate Test Cost, For example, Test Cost = M.

```bash
if M == N:
    - keng-controller will not have any communication with license servers
else if M > N:
    - keng-controller will not check-in licenses
    - it will attempt to check-out required additional licenses
else if M < N:
    - keng-controller will check-in surplus of the licenses
```

On the timing aspect, the entire license check-out/check-in mechanism works concurrently with the control plane and the data plane configurations in the ports during the OTG SetConfig operation. Therefore, potentially there is a minimal impact in the OTG SetConfig API response time, specially when the license server is in the same pod/host. Although, in case of the license server that is present in a separate host in the LAN OTG Setconfig API response time, might get impacted due to latency.
</details>

<details>
<summary>What is the granularity of a license?</summary>
<br>
It depends on various aspects port type, port speed, protocol type, and the number of protocol sessions. For details on the granular license features and associated consummation mechanism, see [License consumption mechanism and feature licenses](#license-consumption-mechanism-and-feature-licenses).
</details>

<details>
<summary>What happens if the controller does not find the active license server on boot – how long shall it try?</summary>
<br>
The Keng-controller is allowed to be given a bootstrap input of 4 license servers in the maximum. The Keng-controller tries to connect to those license servers during the bootstrap. If neither of them is connected, the controller capability is set as the community capability. <br />
A background routine is initiated to make recurrent attempts to connect those configured license servers in 30 second intervals. <br />
It is possible that none of the license servers is reachable, after recurrent attempts. Till that point any configuration beyond community capability will return errors. <br />
If the keng-controller is able to communicate or establish connection with any of the license servers, in any of the recurrent attempts, then for the configuration which is beyond the community standard, keng-controller will try to check-out a license from the license server with which the connection is established. <br />
</details>

<details>
<summary>What are the messages it generates, if the server is not found?</summary>
<br>
If any of the configured license servers are not reachable, the keng-controller capability is kept to community capability. For the configuration beyond community capability will throw error as mentioned above.
</details>

<details>
<summary>What are the error codes and messages it generates, when the license is needed but it cannot be checked out?</summary>
<br>
There are two possible scenarios when the license cannot checkout.

* Scenario 1: Any of the license servers does not have the adequate license features that are required for the test configuration. It will throw an error with the `error code 13` and the following error message:

    `Current configuration requires following additional license feature(s): {map[KENG-DPLU:50 KENG-SEAT:1]} which is not available in configured license server(s): {[ip1, ip2]} Available license feature(s) in license-server(s) are {ip1 : map[KENG-DPLU:0 KENG-SEAT:0] ,ip2 : map[KENG-DPLU:0 KENG-SEAT:0] }.`

* Scenario 2: Configured license server is not available/reachable. It will throw an error with the `error code 13` and the following error message:

    `issue consuming license from server 10.39.35.77: rpc error: code = DeadlineExceeded desc = context deadline exceeded`

</details>

<details>
<summary>After how many retries things are considered dead and how long does it take?</summary>
<br>
Details about the "Retry" behavior for liveness check:<br>
The controller keeps on probing liveliness check on the list of license servers that are supplied on boot-up time in the background routine in every 30 seconds during the controller lifetime.
</details>

<details>
<summary>What happens if there are more than one license servers alive at the time of the last check, but it is no longer available, when the controller actually checks the license from the first one?</summary>
<br>
The keng-controller will attempt to check out licenses from the next available license server in the configured list.
</details>

<details>
<summary>How long does a license remain valid, after it is granted?</summary>
<br>
Once a specific count of license features or a collection of the same details of a license feature are given in the [License consumption mechanism and feature licenses](#license-consumption-mechanism-and-feature-licenses), it is granted by the license server to an instance of the keng-controller. The validity will be determined by the subsequent incoming test configurations details as mentioned above.
</details>

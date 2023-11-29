# Licensing

## Section 1: License consumption mechanism and feature licenses

Elastic Network Generator [licenses](../licensing.md) include the following features depending on the license edition. Details on how the features are consumed are given below.

### Table 1: KENG Feature Licenses

  | Feature Licenses                    | Developer            | Team            | System                 |
  |-------------------------------------|----------------------|-----------------|------------------------|
  | KENG-SEAT                           | 1                    |  8              |  16                    |
  | KENG-SEAT​-UHD                       | N/A                  |  8              |  16                    |
  | KENG-SEAT​-IXHW                      | N/A                  |  N/A            |  16                    |
  | KENG-DPLU                           | 50                   |  400            |  800                   |
  | KENG-CPLU                           | 50                   |  400            |  800                   |
  | KENG-UNLIMITED-CP                   | N/A                  |  N/A            |  16                    |

The exact list of feature licenses required by a specific test configuration is calculated based on the test port type, port speed, protocol, protocol sessions etc. Overall, the list of required licenses is referred to as Test Cost.

### Table 2: Test Cost Calculation Matrix

  | Port Type        | Condition                     | Seat Cost                                                             | Control Plane (CP) Cost            | Data Plane (DP) cost           |
  |------------------|-------------------            |-----------------------------------------------------------------------|-------------------------           |---------------                 |
  | Ixia-c SW        | `If CP Cost <= 50`            |  `1x KENG-SEAT`                                                       |  `SUM (Protocol Cost)`<sup>1</sup>​ |  `SUM (Speed Cost)`<sup>2</sup>|
  | Ixia-c SW        | `If CP Cost > 50`<sup>3</sup> |  `1x KENG-SEAT`<br/>`1x KENG-UNLIMITED-CP`                            |  `50`                              |  `SUM (Speed Cost)`<sup>2</sup>|
  | UHD400T          | `If CP Cost <= 50`​            |  `1x KENG-SEAT`​<br/>`1x KENG-SEAT-UHD`​                                |  `SUM (Protocol Cost)​`<sup>1</sup> |  `0`                           |
  | UHD400T          | `If CP Cost > 50`<sup>3</sup> |  `1x KENG-SEAT`<br/>`1x KENG-SEAT-UHD`<br/>`1x KENG-UNLIMITED-CP`     |  `50`                              |  `0`                           |
  | IxOS Hardware    |                               |  `1x KENG-SEAT`<br/>`1x KENG-SEAT-IXHW`​                               |  `0`                               |  `0`                           |

 <sup>1</sup> See reference table [Table 3](#table-3-control-plane-cost-reference-table) for `Protocol Cost`. <br />
 <sup>2</sup> See reference table [Table 4](#table-4-data-plane-speed-cost-reference-table) for `Speed Cost`. <br />
 <sup>3</sup> If `KENG-UNLIMITED-CP` is not available, an exact required number of `KENG-CPLU` will be consumed.

 * Seat is the number of running `keng-controller` instances with a configuration exceeding capabilities of the Community Edition.
 * Data Plane License Unit (`KENG-DPLU`) is associated with traffic port capacity.
 * The number of required units is determined as a sum of configured port speeds (1, 10, 25, 40, 50, 100GE). Maximum port performance might be less than configured port speed.
 * Control Plane License unit (`KENG-CPLU`) is associated with control plane protocol scale. The number of required CP units is determined as a sum of configured protocol sessions.

```
Test Cost = Seat Cost + CP Cost * KENG-CPLU + DP Cost * KENG-DPLU​
```

### Table 3: Control Plane Cost Reference Table

  | Protocol                     | Session Definition                      | Protocol Cost/Session             | Comment                |
  |------------------------------|-----------------------------------------|-----------------------------------|------------------------|
  | IP Interface (ARP, ND)       | devices: <br /> - ethernets: <br /> - ipv4_addresses:<br />  - ipv6_addresses:          |  0              |                      |
  | IP Loopbacks​                 | devices: <br /> - ipv4_loopbacks:<br />  - ipv6_loopbacks:          |  0              |                      |
  | LLDP​                         | lldp: <br /> - connection:<br />  - port_name:          |  1              | Session = Test Port with LLDP enabled               |
  | LACP                         | lacp: <br /> - ports:<br />  - port_name: <br /> lacp:         |  1              | Session = LAG group, no matter group size​               |
  | BGP                          | devices: <br /> - bgp: <br /> - ipv4_addresses:<br />  - ipv6_addresses: <br />- peers:​ | 1            | Session = BGP peer  |
  | ISIS                         | devices: <br /> - isis: <br /> - interfaces:<br />  - eth_name: ​ | 1            | Session = ISIS interface  |
  | RSVP                         | devices: <br /> - rsvp: <br /> - ipv4_interfaces:<br />  - neighbor_ip: ​ | 1            | Session = RSVP neighbor​   |


        CP Cost/Port = SUM (Protocol Cost) on each port


### Table 4: Data Plane Speed Cost Reference Table

  | DP Port Speed         | 1G         | 10G       | 25G       | 40G        | 50G        | 100G      |
  |-----------------------|------------|-----------|-----------|------------|------------|-----------|
  | DP Cost               | 1          | 10        | 25        | 40         | 50         | 100       |


### Sample Use case


**Test configuration**

Number of `keng-controller` instances: `1`

* Number of ports: `4`
* Port Speed: `100G`
* Protocol: `100 BGP sessions/port`
* Port type: `Ixia-c software`

#### Scenario 1: Unlimited CP capability `KENG-UNLIMITED-CP` is unavailable

**Consumed features**

    KENG-SEAT: 1 = (1 keng-controller instance and ixia-c SW port)
    KENG-DPLU: 400 = (100G speed * 4 ports)
    KENG-CPLU: 400 = (100 BGP sessions/port * 4 ports)


#### Scenario 2: Unlimited CP capability `KENG-UNLIMITED-CP` is available

**Consumed features**

    KENG-SEAT: 1 = (1 keng-controller instance and ixia-c SW port)
    KENG-DPLU: 400 = (100G speed * 4 ports)
    KENG-CPLU: 50 = (CP cost = 400 (100 BGP sessions/port * 4 ports) which is greater than 50 	and unlimited cp capability is present)
    KENG-UNLIMITED-CP: 1

## Section 2: Liveliness check and timeout on license server communication

### Q1. What is the impact of frequent license checking on test execution time for individual test and batch?

License check-out/check-in mechanism in keng-controller works as follows:

1. Calculate Test Cost, let's say it is N
2. Based on calculation done in step (1), check-out the licenses at the time of OTG SetConfig API call.
3. Execute the test if license check-out is successful.
4. For the next configuration, calculate Test Cost, let's say it is M

```
if M == N:
    - keng-controller will not have any communication with license servers
else if M > N:
    - keng-controller will not check-in licenses
    - it will attempt to check-out required additional licenses
else if M < N:
    - keng-controller will check-in surplus of the licenses
```

On the timing aspect the entire aforementioned license check-out/check-in mechanism works concurrently with control plane and data plane configuration in ports during OTG SetConfig operation. Therefore, potentially there is minimal impact in OTG SetConfig API response time, specially when the license server is in the same pod/host. Although, in case of license server sitting in separate host in LAN OTG Setconfig API response time might get impacted due to latency.

### Q2. What is the granularity of license?

It depends on various aspects port type, port speed, protocol type and number of protocol sessions. For details on granular license features and associated consummation mechanism, please refer to [Section 1](#section-1-license-consumption-mechanism-and-feature-licenses).

### Q3. What happens if the controller does not find the active license server on boot – how long does it try?

Keng-controller is allowed to be given a bootstrap input of maximum 4 license servers. Keng-controller is trying to connect to those license servers during bootstrap. If neither of them is connected, then keng-controller capability is set as community capability. <br />
A background routine is initiated to make recurrent attempts to connect those configured license servers in 30 second intervals. <br />
It is possible that after recurrent attempts none of the license servers is reachable. Till that point any configuration beyond community capability will return error. <br />
Meanwhile, in any of the recurrent attempt  keng-controller is able to communicate or establish connection with any of the license servers, then for the configuration beyond the community standard, keng-controller will try to check-out a license from the license server with which the connection is established. <br />

### Q4. What message it generates if server not found?

If any of the configured license servers are not reachable, the keng-controller capability is kept to community capability. For the configuration beyond community capability will throw error as mentioned in Q1.

### Q5. What exactly is the error code and message when the license is needed but cannot be checked out?

There are two possible scenarios when license cannot checkout.

* Scenario 1: Any of the license servers doesn't have adequate license features required for the test configuration. It will throw error with `error code 13` and the following error message:

    `Current configuration requires following additional license feature(s): {map[KENG-DPLU:50 KENG-SEAT:1]} which is not available in configured license server(s): {[ip1, ip2]} Available license feature(s) in license-server(s) are {ip1 : map[KENG-DPLU:0 KENG-SEAT:0] ,ip2 : map[KENG-DPLU:0 KENG-SEAT:0] }.`

* Scenario 2: Configured license server is not available/reachable. It will throw error with `error code 13` and the following error message:

    `issue consuming license from server 10.39.35.77: rpc error: code = DeadlineExceeded desc = context deadline exceeded`

### Q6. Details about the “Retry” behavior for liveness check– how many retries, after how many retries things are considered dead, how long does it take?

The controller keeps on probing liveliness check on the list of license servers supplied on boot-up time in background routine every 30 seconds during controller lifetime.

### Q7. What happens if there is more than one license servers alive at the time of the last check, but when the controller actually checks the license from the first one, it is no longer available?

The keng-controller will attempt to check out license from next available license server in the configured list.

### Q8. Clarify once a license is granted then how long it is valid?

Once a specific count of license feature or collection of same details of license feature are given in the above [Section 1](#section-1-license-consumption-mechanism-and-feature-licenses) is granted by the license server to an instance of the keng-controller, validity of it will be determined by subsequent incoming test configurations details on which is mentioned in Q1.

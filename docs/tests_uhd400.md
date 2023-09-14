# Introduction

The UHD-400G-T16 is a high-performance ultra high density, highly flexible, software defined tester for all your next generation testing needs. It works seamlessly with diverse testbeds like a single Device Under Test, or a network with multiple devices, or it can even integrate into a network simulation/emulation environment on a Kubernetes cluster.

Ports 1 to 16 on the UHD operate as traffic generator ports.

![UHD](res/UHD100T32.png "UHD-400G")

Some terms before we get started:

- OTG - Open Traffic Generator is an API that defines a standard, model-driven and vendor-neutral interface for emulating layer 2-7 network devices and generating test traffic. 

    [https://github.com/open-traffic-generator](https://github.com/open-traffic-generator)

- Ixia-c - A container based reference implementation of Open Traffic Generator API.  

    [https://github.com/open-traffic-generator/ixia-c](https://github.com/open-traffic-generator/ixia-c)

- Snappi - An auto-generated SDK used to write testing scripts. It can be executed against any traffic generator conforming to Open Traffic Generator API, for example Ixia-c. Ixia-c supports client SDKs in various languages, most prevalent being `snappi`. 

    [https://github.com/open-traffic-generator/snappi](https://github.com/open-traffic-generator/snappi)

## Features
- Support for wire-speed stateless traffic on 16x400G ports
- Support for the Ixia-c protocol engine on all 16 traffic generator ports
- Support for simple counter modifiers on:
    - Source/Destination MAC Address
    - VLAN ID
    - Outer Source/Destination IPv4 address
    - Outer Source/Destination TCP/UDP Port
- Support for existing Ixia-c scripts
- Support for custom control plane applications through the front panel ports

# Getting Started
## In the Box
- UHD-400G-T16 1U Tester
- HP ProLiant DL360p 1U Server
- Intel 10Gb PCI-E NIC SFP+ X520-DA1 (pre-installed in the server)
- QSFP to 4xSFP copper breakout cable
- 8 QSFP-DD copper cables

## Initial Setup

![UHD Connections](res/uhd-connections.png)
![Server Connections](res/server-connections.png)

1. Attach the serial and management network connections to the UHD tester and HP server.
2. Connect the SFP 10GE port (on the rear panel) of the server to front panel port 32 on the UHD (bottom right). Use the QSFP to SFP copper breakout cable incuded in the box. Ensure that you connect the labeled SFP to the 10GE port.
3. To run the preinstalled demo programs decribed below, connect odd-numbered ports to closest even-numbered ports back-to-back. For example, connect port 1 to port 2, port 3 to port 4, and so on. You can use the QSFP-DD cables provided for the back-to-back connections.

### Default Management Network Settings

- UHD
    - IP: DHCPv4
    - Hostname: `uhd-400g-te`
- Server
    - IP: DHCPv4
    - Hostname: `uhd-400g-pe`

#### Logging in with the Serial Console

##### UHD

- Set the serial console baud rate to 9600
- Login to the BMC with User: `admin` Password: `admin`
- Login to KCOS (the x86 processor) with user: `console`
- When prompted, login to the admin shell with User: `admin` Password: `admin`

The follwoing output should appear (press Enter if the console doesn't respond):

```shell

OpenBMC Release 1.0.0.14

bmc login: admin
Password: admin
Last login: Mon Aug 10 22:19:33 -0700 2020 on /dev/ttyS2.
You are in SOL session.
Use ctrl-x to quit.
-----------------------


kcos-0090fb6bd1dd login: console
Error: Kubernetes cluster unreachable
Welcome to UHD
KCOS System Versions:
---
system:
  running: "0.0.0+master.20220224.143758.4901c9ce"
  available:
    - name: "factory"
      version: "1.1.6+20210309.191956.8fe166e8"
    - name: "new"
      version: "0.0.0+master.20220224.143758.4901c9ce"
    - name: "old"
      version: "0.0.0+master.20220110.220701.6f3e6c0e"
  links:
    "current": "new"
    "last-good": "factory"

2: mgmt0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:90:fb:6b:d1:dd brd ff:ff:ff:ff:ff:ff
    inet 169.254.117.9/16 brd 169.254.255.255 scope link mgmt0
       valid_lft forever preferred_lft forever
    inet 10.36.71.234/22 brd 10.36.71.255 scope global dynamic mgmt0
       valid_lft 14967sec preferred_lft 14967sec
    inet6 fe80::290:fbff:fe6b:d1dd/64 scope link
       valid_lft forever preferred_lft forever
login: admin
admin@localhost's password: admin

26122d2ae710:~$ 
```

#### Logging in with Admin SSH

Admin Shell To setup mgmt network configurations.

- Port: `22`
- User: `admin`
- Password: `admin`

#### Configure the network settings

- Configure the network settings such as IP address/hostname for `mgmt0` interface on both the UHD and the server. Follow the `KCOS` admin shell directions for detailed instructions for the CLI.

Examples:

```shell
# set static IP
kcos networking ip set mgmt0 10.36.81.43/22 10.36.80.1
# get current IP
kcos networking ip show
```

## Connecting the Demo Testbed
The demo testbed consists of a server and the UHD connected to each other. The server is used to run the control plane. In this case we are using the Ixia-c protocol engine. The UHD provides stateless traffic generation and analysis services. The server acts as the protocol engine(PE) and the UHD as the traffic engine(TE) in the demos described below.

![Demo Testbed connections](res/testbed_connections.svg "Demo Testbed Connections")



## Sample `gosnappi` scripts

Two sample `gosnappi` scripts can be found in the directory [`gosnappi/`](./gosnappi) of the following git repo: https://gitlab.it.keysight.com/p4isg/uhd-400g-docs. They are also located in the admin shell of the UHD. 

The two sample scripts provided are `uhd_b2b.go` and `uhd_b2b_bgp.go`. 

- `uhd_b2b.go` sends a fixed packet count with incrementing MAC and IP addresses. The script then collects and verifies the flow statistics.
- `uhd_b2b_bgp.go` configures 1 BGP session per  port and advertises 2 routes. The script then sends a fixed packet count across those routes. The script finally collects and verifies the flow statistics. 

The scripts' topology assumes a back-to-back connection between odd- and even-numbered ports (for example, 1<-->2, 3<-->4, ..., 15<-->16).

To build `./build.sh` (Go must be installed):

```shell
# build
./build.sh

# Run uhd_b2b
./gosnappi/uhd_b2b -host https://<ip of UHD>

# Run uhd_b2b_bgp
./gosnappi/uhd_b2b_bgp -host https://<ip of UHD>
```

For information on gosnappi, see https://github.com/open-traffic-generator/snappi/tree/main/gosnappi.

## UHD Interface Manager

UHD Interface Manager is a client-side CLI to deploy custom containers that are virtually connected to a specific front panel port of the UHD. Each of these custom containers has a netdev interface named `eth1` which is virtually-wired to the front panel port of the UHD.    


```shell
./uhd-ifmgr/test_iperf.sh <ip of UHD>
```

See [./uhd-ifmgr/test_iperf.sh](./uhd-ifmgr/test_iperf.sh) for a reference example of how to deploy  custom containers and access them using `kubectl`.

## Known Limitations
- Support for only 1 stream per port 
- No support for latency measurements
- No support for modifiers at a specific byte offset
- No L4 checksum correction on payload modifications
- No support for user defined stats
- No support for capture


## Reference

<details>

<summary><b>Expand</b> this section for sample output of `uhd_b2b` test</summary>

```shell
./gosnappi/uhd_b2b -host https://10.36.79.196

2022/02/28 20:17:04 Total ports is 2
2022/02/28 20:17:04 Creating gosnappi client for gRPC server grpc-service.default.svc.cluster.local:40051 ...
2022/02/28 20:17:04 Connecting to server at https://10.36.79.196
2022/02/28 20:17:04 Creating port p1 at location uhd://nanite-bfs-v1.nanite-bfs:7531;1
2022/02/28 20:17:04 Creating port p2 at location uhd://nanite-bfs-v1.nanite-bfs:7531;2
2022/02/28 20:17:04 Creating flow p1->p2-IPv4
2022/02/28 20:17:04 Flow p1->p2-IPv4 srcMac 00:11:22:33:44:00 dstMac 00:11:22:33:44:01
2022/02/28 20:17:04 Flow p1->p2-IPv4 srcIp 10.1.1.1 dstIp 10.1.1.2
2022/02/28 20:17:04 Creating flow p2->p1-IPv4
2022/02/28 20:17:04 Flow p2->p1-IPv4 srcMac 00:11:22:33:44:01 dstMac 00:11:22:33:44:00
2022/02/28 20:17:04 Flow p2->p1-IPv4 srcIp 10.1.1.2 dstIp 10.1.1.1
2022/02/28 20:17:04 flows:
- duration:
    choice: fixed_packets
    fixed_packets:
      gap: 12
      packets: 5000000
  metrics:
    enable: true
    loss: false
    timestamps: false
  name: p1->p2-IPv4
  packet:
  - choice: ethernet
    ethernet:
      dst:
        choice: increment
        increment:
          count: 10000
          start: "00:11:22:33:44:01"
          step: "00:00:00:00:01:00"
      src:
        choice: increment
        increment:
          count: 10000
          start: "00:11:22:33:44:00"
          step: "00:00:00:00:01:00"
  - choice: ipv4
    ipv4:
      dst:
        choice: increment
        increment:
          count: 10000
          start: 10.1.1.2
          step: 0.1.0.0
      src:
        choice: increment
        increment:
          count: 10000
          start: 10.1.1.1
          step: 0.1.0.0
  rate:
    choice: percentage
    percentage: 10
  size:
    choice: fixed
    fixed: 64
  tx_rx:
    choice: port
    port:
      rx_name: p2
      tx_name: p1
- duration:
    choice: fixed_packets
    fixed_packets:
      gap: 12
      packets: 5000000
  metrics:
    enable: true
    loss: false
    timestamps: false
  name: p2->p1-IPv4
  packet:
  - choice: ethernet
    ethernet:
      dst:
        choice: increment
        increment:
          count: 10000
          start: "00:11:22:33:44:00"
          step: "00:00:00:00:01:00"
      src:
        choice: increment
        increment:
          count: 10000
          start: "00:11:22:33:44:01"
          step: "00:00:00:00:01:00"
  - choice: ipv4
    ipv4:
      dst:
        choice: increment
        increment:
          count: 10000
          start: 10.1.1.1
          step: 0.1.0.0
      src:
        choice: increment
        increment:
          count: 10000
          start: 10.1.1.2
          step: 0.1.0.0
  rate:
    choice: percentage
    percentage: 10
  size:
    choice: fixed
    fixed: 64
  tx_rx:
    choice: port
    port:
      rx_name: p1
      tx_name: p2
layer1:
- mtu: 1500
  name: l1
  port_names:
  - p1
  - p2
  promiscuous: true
  speed: speed_400_gbps
ports:
- location: uhd://nanite-bfs-v1.nanite-bfs:7531;1
  name: p1
- location: uhd://nanite-bfs-v1.nanite-bfs:7531;2
  name: p2
 <nil>
2022/02/28 20:17:04 Setting Config ...
2022/02/28 20:17:05 api: SetConfig, choice:  - took 559 ms
2022/02/28 20:17:05 Setting TransmitState ...
2022/02/28 20:17:06 api: SetTransmitState, choice: start - took 1042 ms
2022/02/28 20:17:06 Waiting for condition to be true ...
2022/02/28 20:17:06 Getting Metrics ...
2022/02/28 20:17:09 api: GetMetrics, choice: flow - took 2990 ms
2022/02/28 20:17:09 api: GetFlowMetrics, choice:  - took 2990 ms
2022/02/28 20:17:09 Getting Metrics ...
2022/02/28 20:17:09 api: GetMetrics, choice: port - took 41 ms
2022/02/28 20:17:09 api: GetPortMetrics, choice:  - took 41 ms
2022/02/28 20:17:09 

Port Metrics
-----------------------------------------------------------------
Name           Frames Tx      Frames Rx      
p1             5000000        5000000        
p2             5000000        5000000        
-----------------------------------------------------------------


Flow Metrics
--------------------------------------------------
Name           Frames Rx      
p1->p2-IPv4    5000000        
p2->p1-IPv4    5000000        
--------------------------------------------------


2022/02/28 20:17:09 Done waiting for condition to be true
2022/02/28 20:17:09 api: WaitFor, choice: condition to be true - took 3031 ms
2022/02/28 20:17:09 Total time is 4.647671319s
2022/02/28 20:17:09 Closing gosnappi client ...
```

</details>

<details>

<summary><b>Expand</b> this section for sample output of `uhd_b2b_bgp` test</summary>

```shell
./gosnappi/uhd_b2b_bgp -host https://10.36.79.196
2022/02/28 20:22:32 Total ports is 2
2022/02/28 20:22:32 Creating gosnappi client for gRPC server grpc-service.default.svc.cluster.local:40051 ...
2022/02/28 20:22:32 Connecting to server at https://10.36.79.196
2022/02/28 20:22:32 Creating port p1 at location uhd://nanite-bfs-v1.nanite-bfs:7531;1+r0.rustic.svc.cluster.local:50071
2022/02/28 20:22:32 Creating port p2 at location uhd://nanite-bfs-v1.nanite-bfs:7531;2+r1.rustic.svc.cluster.local:50071
2022/02/28 20:22:32 Creating flow p1->p2-IPv4
2022/02/28 20:22:32 Flow p1->p2-IPv4 srcMac 00:11:22:33:44:00 dstMac 00:11:22:33:44:01
2022/02/28 20:22:32 Flow p1->p2-IPv4 srcIp 100.1.1.1 dstIp 100.1.1.2
2022/02/28 20:22:32 Creating flow p2->p1-IPv4
2022/02/28 20:22:32 Flow p2->p1-IPv4 srcMac 00:11:22:33:44:01 dstMac 00:11:22:33:44:00
2022/02/28 20:22:32 Flow p2->p1-IPv4 srcIp 100.1.1.2 dstIp 100.1.1.1
2022/02/28 20:22:32 devices:
- bgp:
    ipv4_interfaces:
    - ipv4_name: d1ipv4
      peers:
      - as_number: 1111
        as_number_width: four
        as_type: ebgp
        name: BGPv4 Peer p1
        peer_address: 100.1.1.2
        v4_routes:
        - addresses:
          - address: 11.1.11.0
            count: 2
            prefix: 24
            step: 2
          name: p1d1peer1rrv4
          next_hop_address_type: ipv4
          next_hop_ipv4_address: 0.0.0.0
          next_hop_ipv6_address: ::0
          next_hop_mode: local_ip
    router_id: 100.1.1.1
  ethernets:
  - ipv4_addresses:
    - address: 100.1.1.1
      gateway: 100.1.1.2
      name: d1ipv4
      prefix: 24
    mac: "00:11:22:33:44:00"
    mtu: 1500
    name: d1Eth
    port_name: p1
  name: d1
- bgp:
    ipv4_interfaces:
    - ipv4_name: d2ipv4
      peers:
      - as_number: 2222
        as_number_width: four
        as_type: ebgp
        name: BGPv4 Peer p2
        peer_address: 100.1.1.1
        v4_routes:
        - addresses:
          - address: 12.1.12.0
            count: 2
            prefix: 24
            step: 2
          name: p2d2peer1rrv4
          next_hop_address_type: ipv4
          next_hop_ipv4_address: 0.0.0.0
          next_hop_ipv6_address: ::0
          next_hop_mode: local_ip
    router_id: 100.1.1.2
  ethernets:
  - ipv4_addresses:
    - address: 100.1.1.2
      gateway: 100.1.1.1
      name: d2ipv4
      prefix: 24
    mac: "00:11:22:33:44:01"
    mtu: 1500
    name: d2Eth
    port_name: p2
  name: d2
flows:
- duration:
    choice: fixed_packets
    fixed_packets:
      gap: 12
      packets: 5000000
  metrics:
    enable: true
    loss: false
    timestamps: false
  name: p1->p2-IPv4
  packet:
  - choice: ethernet
    ethernet:
      dst:
        choice: value
        value: "00:11:22:33:44:01"
      src:
        choice: value
        value: "00:11:22:33:44:00"
  - choice: ipv4
    ipv4:
      dst:
        choice: value
        value: 100.1.1.2
      src:
        choice: value
        value: 100.1.1.1
  rate:
    choice: percentage
    percentage: 10
  size:
    choice: fixed
    fixed: 64
  tx_rx:
    choice: port
    port:
      rx_name: p2
      tx_name: p1
- duration:
    choice: fixed_packets
    fixed_packets:
      gap: 12
      packets: 5000000
  metrics:
    enable: true
    loss: false
    timestamps: false
  name: p2->p1-IPv4
  packet:
  - choice: ethernet
    ethernet:
      dst:
        choice: value
        value: "00:11:22:33:44:00"
      src:
        choice: value
        value: "00:11:22:33:44:01"
  - choice: ipv4
    ipv4:
      dst:
        choice: value
        value: 100.1.1.1
      src:
        choice: value
        value: 100.1.1.2
  rate:
    choice: percentage
    percentage: 10
  size:
    choice: fixed
    fixed: 64
  tx_rx:
    choice: port
    port:
      rx_name: p1
      tx_name: p2
layer1:
- mtu: 1500
  name: l1
  port_names:
  - p1
  - p2
  promiscuous: true
  speed: speed_400_gbps
ports:
- location: uhd://nanite-bfs-v1.nanite-bfs:7531;1+r0.rustic.svc.cluster.local:50071
  name: p1
- location: uhd://nanite-bfs-v1.nanite-bfs:7531;2+r1.rustic.svc.cluster.local:50071
  name: p2
 <nil>
2022/02/28 20:22:32 Setting Config ...
2022/02/28 20:22:33 api: SetConfig, choice:  - took 710 ms
2022/02/28 20:22:33 Setting SetProtocolState ...
2022/02/28 20:22:33 api: SetProtocolState, choice: start - took 835 ms
2022/02/28 20:22:33 Waiting for condition to be true ...
2022/02/28 20:22:33 Getting Metrics ...
2022/02/28 20:22:34 api: GetMetrics, choice: bgpv4 - took 68 ms
2022/02/28 20:22:34 api: GetBgpv4Metrics, choice:  - took 68 ms
2022/02/28 20:22:34 

BGPv4 Metrics
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Name                        BGPv4 Peer p1  BGPv4 Peer p2  
Session State               down           down           
Session Flaps               0              0              
Routes Advertised           0              0              
Routes Received             0              0              
Route Withdraws Tx          0              0              
Route Withdraws Rx          0              0              
Keepalives Tx               0              0              
Keepalives Rx               0              0              
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


2022/02/28 20:22:34 Getting Metrics ...
2022/02/28 20:22:34 api: GetMetrics, choice: bgpv4 - took 40 ms
2022/02/28 20:22:34 api: GetBgpv4Metrics, choice:  - took 40 ms
2022/02/28 20:22:34 

BGPv4 Metrics
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Name                        BGPv4 Peer p1  BGPv4 Peer p2  
Session State               down           down           
Session Flaps               0              0              
Routes Advertised           0              0              
Routes Received             0              0              
Route Withdraws Tx          0              0              
Route Withdraws Rx          0              0              
Keepalives Tx               0              0              
Keepalives Rx               0              0              
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


2022/02/28 20:22:35 Getting Metrics ...
2022/02/28 20:22:35 api: GetMetrics, choice: bgpv4 - took 40 ms
2022/02/28 20:22:35 api: GetBgpv4Metrics, choice:  - took 40 ms
2022/02/28 20:22:35 

BGPv4 Metrics
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Name                        BGPv4 Peer p1  BGPv4 Peer p2  
Session State               down           down           
Session Flaps               0              0              
Routes Advertised           0              0              
Routes Received             0              0              
Route Withdraws Tx          0              0              
Route Withdraws Rx          0              0              
Keepalives Tx               0              0              
Keepalives Rx               0              0              
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


2022/02/28 20:22:35 Getting Metrics ...
2022/02/28 20:22:35 api: GetMetrics, choice: bgpv4 - took 43 ms
2022/02/28 20:22:35 api: GetBgpv4Metrics, choice:  - took 43 ms
2022/02/28 20:22:35 

BGPv4 Metrics
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Name                        BGPv4 Peer p1  BGPv4 Peer p2  
Session State               down           down           
Session Flaps               0              0              
Routes Advertised           0              0              
Routes Received             0              0              
Route Withdraws Tx          0              0              
Route Withdraws Rx          0              0              
Keepalives Tx               0              0              
Keepalives Rx               0              0              
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


2022/02/28 20:22:36 Getting Metrics ...
2022/02/28 20:22:36 api: GetMetrics, choice: bgpv4 - took 38 ms
2022/02/28 20:22:36 api: GetBgpv4Metrics, choice:  - took 38 ms
2022/02/28 20:22:36 

BGPv4 Metrics
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Name                        BGPv4 Peer p1  BGPv4 Peer p2  
Session State               up             up             
Session Flaps               0              0              
Routes Advertised           2              2              
Routes Received             2              2              
Route Withdraws Tx          0              0              
Route Withdraws Rx          0              0              
Keepalives Tx               2              2              
Keepalives Rx               2              2              
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


2022/02/28 20:22:36 Done waiting for condition to be true
2022/02/28 20:22:36 api: WaitFor, choice: condition to be true - took 2235 ms
2022/02/28 20:22:36 Setting TransmitState ...
2022/02/28 20:22:37 api: SetTransmitState, choice: start - took 953 ms
2022/02/28 20:22:37 Waiting for condition to be true ...
2022/02/28 20:22:37 Getting Metrics ...
2022/02/28 20:22:39 api: GetMetrics, choice: flow - took 2646 ms
2022/02/28 20:22:39 api: GetFlowMetrics, choice:  - took 2646 ms
2022/02/28 20:22:39 Getting Metrics ...
2022/02/28 20:22:39 api: GetMetrics, choice: port - took 66 ms
2022/02/28 20:22:39 api: GetPortMetrics, choice:  - took 66 ms
2022/02/28 20:22:39 

Port Metrics
-----------------------------------------------------------------
Name           Frames Tx      Frames Rx      
p1             5000000        5000000        
p2             5000000        5000000        
-----------------------------------------------------------------


Flow Metrics
--------------------------------------------------
Name           Frames Rx      
p1->p2-IPv4    5000000        
p2->p1-IPv4    5000000        
--------------------------------------------------


2022/02/28 20:22:39 Done waiting for condition to be true
2022/02/28 20:22:39 api: WaitFor, choice: condition to be true - took 2713 ms
2022/02/28 20:22:39 Total time is 7.46707886s
2022/02/28 20:22:39 Setting SetProtocolState ...
2022/02/28 20:22:39 api: SetProtocolState, choice: stop - took 47 ms
2022/02/28 20:22:39 Closing gosnappi client ...
```

</details>

<details>

<summary><b>Expand</b> this section for sample output of `test_iperf` test</summary>

```shell
This script will,
1. Load kubeconfig to access UHD cluster
2. Deploy netshoot containers to run as custom service behind UHD Port 1 and 2
3. Run iperf in those containers and use UHD ports for interface
Press any key to continue...
++ which kubectl
+ '[' '!' -f /usr/local/bin/kubectl ']'
+ export KUBECONFIG=/tmp/uhd400gconfig
+ KUBECONFIG=/tmp/uhd400gconfig
+ kubectl config set-cluster uhd400g --server=https://10.36.79.196:6443 --insecure-skip-tls-verify
Cluster "uhd400g" set.
+ kubectl config set-credentials uhd400g-user --token=eyJhbGciOiJSUzI1NiIsImtpZCI6Ik9nNGFBZkVoU21hcjZuSUY4cEtiTjgxVjJqcm80OWxIU25fUVZ0anpwazQifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJydXN0aWMiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlY3JldC5uYW1lIjoici10b2tlbi04djRyNSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJyIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiMjUyNWViYzYtOTBlMi00NWM2LWJhNzgtYTM1YmEwNjZkZmZjIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OnJ1c3RpYzpyIn0.Z3_U7c2tBWuWCdd8Wns98xZMRprJ0DO91XVlVVRgA5jS-Rcb8jVUej5pOXmvVc8FFj3ZOkggN2rdWDpNKSMDSLRuKeP47B76A0if1sUeci_sUve9ZcDuteS-t60kFOyBZG8YHPDDCArPaQedPoMpB96ekbmhJ5sprxwHKdYqT5Q_AxkoYd_8MWPESXjyxdyL-ogAtLP-KDT82_xxSW_ZMyu1CvjaqIQzNKivPk8BG72ByKjbSFBMV9ZYpFaumzOZUWZcuy_kfJ_k6TMyMCKg9FwUvSYMy39tRIY5rC3h-MTZCBSvlWpYCrlklHHsnR0pdMvtQbZMhXXO_7oMdYe9Eg
User "uhd400g-user" set.
+ kubectl config set-context uhd400g --user=uhd400g-user --cluster=uhd400g --namespace=rustic
Context "uhd400g" modified.
+ kubectl config use-context uhd400g
Switched to context "uhd400g".
+ ./uhdIfMgr -custom -image nicolaka/netshoot:v0.1 -cmd '["/bin/sh"]' -args '["-cx", "sleep inf"]' -port 2 -host 10.36.79.196
INFO[0000] Trying to connect to gRPC server at 10.36.79.196:443 
INFO[0000] OK!                                          
+ ./uhdIfMgr -custom -image nicolaka/netshoot:v0.1 -cmd '["/bin/sh"]' -args '["-cx", "sleep inf"]' -port 1 -host 10.36.79.196
INFO[0000] Trying to connect to gRPC server at 10.36.79.196:443 
INFO[0000] OK!                                          
+ sleep 10
+ kubectl wait --for=condition=available deploy -l cpport.keysight.com=1.0 --timeout=100s
deployment.apps/c0 condition met
+ kubectl wait --for=condition=available deploy -l cpport.keysight.com=2.0 --timeout=100s
deployment.apps/c1 condition met
+ kubectl get pods -l cpport.keysight.com=1.0
NAME                  READY   STATUS    RESTARTS   AGE
c0-6fc56dbbbd-nvlsd   1/1     Running   0          11s
+ kubectl get pods -l cpport.keysight.com=2.0
NAME                 READY   STATUS    RESTARTS   AGE
c1-dd9b4b99f-qlht2   1/1     Running   0          12s
++ get_pod 1
++ kubectl get pods -l cpport.keysight.com=1.0 -o 'jsonpath={.items[].metadata.name}'
+ kubectl exec c0-6fc56dbbbd-nvlsd -- /bin/bash -cx 'ip link set eth1 up \
    && ip ad flush eth1 \
    && ip ad ad 5.6.7.8/24 dev eth1 \
    && kill `pidof iperf` || true \
    && iperf -s &'
+ ip link set eth1 up
+ ip ad flush eth1
+ ip ad ad 5.6.7.8/24 dev eth1
++ pidof iperf
+ kill
kill: usage: kill [-s sigspec | -n signum | -sigspec] pid | jobspec ... or kill -l [sigspec]
+ true
+ iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size:  128 KByte (default)
------------------------------------------------------------
++ get_pod 2
++ kubectl get pods -l cpport.keysight.com=2.0 -o 'jsonpath={.items[].metadata.name}'
+ kubectl exec c1-dd9b4b99f-qlht2 -- /bin/bash -cx 'ip link set eth1 up \
    && ip ad flush eth1 \
    && ip ad ad 5.6.7.9/24 dev eth1 \
    && iperf -c 5.6.7.8 -i1 -t30'
+ ip link set eth1 up
+ ip ad flush eth1
+ ip ad ad 5.6.7.9/24 dev eth1
+ iperf -c 5.6.7.8 -i1 -t30
------------------------------------------------------------
Client connecting to 5.6.7.8, TCP port 5001
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  1] local 5.6.7.9 port 38046 connected with 5.6.7.8 port 5001
[ ID] Interval       Transfer     Bandwidth
[  1] 0.00-1.00 sec   161 MBytes  1.35 Gbits/sec
[  1] 1.00-2.00 sec   214 MBytes  1.80 Gbits/sec
[  1] 2.00-3.00 sec   215 MBytes  1.80 Gbits/sec
[  1] 3.00-4.00 sec   193 MBytes  1.62 Gbits/sec
[  1] 4.00-5.00 sec   206 MBytes  1.72 Gbits/sec
[  1] 5.00-6.00 sec   201 MBytes  1.69 Gbits/sec
[  1] 6.00-7.00 sec   213 MBytes  1.78 Gbits/sec
[  1] 7.00-8.00 sec   220 MBytes  1.84 Gbits/sec
[  1] 8.00-9.00 sec   204 MBytes  1.71 Gbits/sec
[  1] 9.00-10.00 sec   210 MBytes  1.76 Gbits/sec
[  1] 10.00-11.00 sec   211 MBytes  1.77 Gbits/sec
[  1] 11.00-12.00 sec   201 MBytes  1.69 Gbits/sec
[  1] 12.00-13.00 sec   220 MBytes  1.85 Gbits/sec
[  1] 13.00-14.00 sec   197 MBytes  1.65 Gbits/sec
[  1] 14.00-15.00 sec   200 MBytes  1.68 Gbits/sec
[  1] 15.00-16.00 sec   213 MBytes  1.79 Gbits/sec
[  1] 16.00-17.00 sec   228 MBytes  1.92 Gbits/sec
[  1] 17.00-18.00 sec   223 MBytes  1.87 Gbits/sec
[  1] 18.00-19.00 sec   222 MBytes  1.86 Gbits/sec
[  1] 19.00-20.00 sec   197 MBytes  1.65 Gbits/sec
[  1] 20.00-21.00 sec   215 MBytes  1.80 Gbits/sec
[  1] 21.00-22.00 sec   202 MBytes  1.69 Gbits/sec
[  1] 22.00-23.00 sec   220 MBytes  1.84 Gbits/sec
[  1] 23.00-24.00 sec   199 MBytes  1.67 Gbits/sec
[  1] 24.00-25.00 sec   209 MBytes  1.75 Gbits/sec
[  1] 25.00-26.00 sec   211 MBytes  1.77 Gbits/sec
[  1] 26.00-27.00 sec   195 MBytes  1.64 Gbits/sec
[  1] 27.00-28.00 sec   205 MBytes  1.72 Gbits/sec
[  1] 28.00-29.00 sec   210 MBytes  1.76 Gbits/sec
[  1] 29.00-30.00 sec   194 MBytes  1.63 Gbits/sec
[  1] 0.00-30.02 sec  6.06 GBytes  1.74 Gbits/sec
+ ./uhdIfMgr -host 10.36.79.196 -port 1
INFO[0000] Trying to connect to gRPC server at 10.36.79.196:443 
INFO[0000] OK!                                          
+ ./uhdIfMgr -host 10.36.79.196 -port 2
INFO[0000] Trying to connect to gRPC server at 10.36.79.196:443 
INFO[0000] OK!                                          
+ sleep 10
+ kubectl wait --for=condition=available deploy -l cpport.keysight.com=1.0 --timeout=100s
deployment.apps/r0 condition met
+ kubectl wait --for=condition=available deploy -l cpport.keysight.com=2.0 --timeout=100s
deployment.apps/r1 condition met
```

</details>


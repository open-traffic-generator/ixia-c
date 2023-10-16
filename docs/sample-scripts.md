
The following text was taken from the UHD400 topic.
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


The following test was taken from the IXOS HW topic:

**Sample Test**

Before attempting the sample test, the deployment must be bootstrapped and KENG services running as described in the deployment section above.

The sample test uses 2 back-to-back ports on a chassis and is named `otg-flows.py` in the example shown below.

1. Use the following commands to set up `virtualenv` for Python:

	`python3 -m venv venv`

	`source venv/bin/activate`

	`pip install -r requirements.txt`

2. To run flows using the `snappi` script and report port metrics, use:

	`otg-flows.py -m port`

3. To run flows using the snappi script reporting port flow, use:

	`otg-flows.py -m flow`

```
# Sample Test ?otg-flows.py?
#!/usr/bin/env python3
# Copyright ? 2023 Open Traffic Generator
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

import sys, os
import argparse
import snappi

def port_metrics_ok(api, req, packets):
    res = api.get_metrics(req)
    print(res)
    if packets == sum([m.frames_tx for m in res.port_metrics]) and packets == sum([m.frames_rx for m in res.port_metrics]):
        return True

def flow_metrics_ok(api, req, packets):
    res = api.get_metrics(req)
    print(res)
    if packets == sum([m.frames_tx for m in res.flow_metrics]) and packets == sum([m.frames_rx for m in res.flow_metrics]):
        return True

def wait_for(func, timeout=15, interval=0.2):
    """
    Keeps calling the `func` until it returns true or `timeout` occurs
    every `interval` seconds.
    """
    import time

    start = time.time()

    while time.time() - start <= timeout:
        if func():
            return True
        time.sleep(interval)

    print("Timeout occurred !")
    return False

def arg_metric_check(s):
    allowed_values = ['port', 'flow']
    if s in allowed_values:
        return s
    raise argparse.ArgumentTypeError(f"metric has to be one of {allowed_values}")

def parse_args():
    # Argument parser
    parser = argparse.ArgumentParser(description='Run OTG traffic flows')

    # Add arguments to the parser
    parser.add_argument('-m', '--metric',    required=False, help='metrics to monitor: port | flow',
                                             default='port',
                                             type=arg_metric_check)
    # Parse the arguments
    return parser.parse_args()

def main():
    """
    Main function
    """
    # Parameters
    args = parse_args()

    API = "https://localhost:8443"
   #Replace with values matching your setup/equipment. For example, if IxOS management IP is 10.10.10.10 and you need to use ports 14 and 15 in the slot number 2:
  # P1_LOCATION ="10.10.10.10;2;14"
  # P2_LOCATION ="10.10.10.10;2;15"

    api = snappi.api(location=API, verify=False)
    cfg = api.config()

    # config has an attribute called `ports` which holds an iterator of type
    # `snappi.PortIter`, where each item is of type `snappi.Port` (p1 and p2)
    p1, p2 = cfg.ports.port(name="p1", location=P1_LOCATION).port(name="p2", location=P2_LOCATION)

    # config has an attribute called `flows` which holds an iterator of type
    # `snappi.FlowIter`, where each item is of type `snappi.Flow` (f1, f2)
    f1, f2 = cfg.flows.flow(name="flow p1->p2").flow(name="flow p2->p1")

    # and assign source and destination ports for each
    f1.tx_rx.port.tx_name, f1.tx_rx.port.rx_name = p1.name, p2.name
    f2.tx_rx.port.tx_name, f2.tx_rx.port.rx_name = p2.name, p1.name

    # configure packet size, rate and duration for both flows
    f1.size.fixed, f2.size.fixed = 128, 256
    for f in cfg.flows:
        # send 1000 packets and stop
        f.duration.fixed_packets.packets = 1000
        # send 1000 packets per second
        f.rate.pps = 1000
        # allow fetching flow metrics
        f.metrics.enable = True

    # configure packet with Ethernet, IPv4 and UDP headers for both flows
    eth1, ip1, udp1 = f1.packet.ethernet().ipv4().udp()
    eth2, ip2, udp2 = f2.packet.ethernet().ipv4().udp()

    # set source and destination MAC addresses
    eth1.src.value, eth1.dst.value = "00:AA:00:00:04:00", "00:AA:00:00:00:AA"
    eth2.src.value, eth2.dst.value = "00:AA:00:00:00:AA", "00:AA:00:00:04:00"

    # set source and destination IPv4 addresses
    ip1.src.value, ip1.dst.value = "10.0.0.1", "10.0.0.2"
    ip2.src.value, ip2.dst.value = "10.0.0.2", "10.0.0.1"

    # set incrementing port numbers as source UDP ports
    udp1.src_port.increment.start = 5000
    udp1.src_port.increment.step = 2
    udp1.src_port.increment.count = 10

    udp2.src_port.increment.start = 6000
    udp2.src_port.increment.step = 4
    udp2.src_port.increment.count = 10

    # assign list of port numbers as destination UDP ports
    udp1.dst_port.values = [4000, 4044, 4060, 4074]
    udp2.dst_port.values = [8000, 8044, 8060, 8074, 8082, 8084]

    # print resulting otg configuration
    print(cfg)

    # push configuration to controller
    api.set_config(cfg)

    # start transmitting configured flows
    ts = api.control_state()
    ts.traffic.flow_transmit.state = snappi.StateTrafficFlowTransmit.START
    api.set_control_state(ts)

    # Check if the file argument is provided
    if args.metric == 'port':
        # create a port metrics request and filter based on port names
        req = api.metrics_request()
        req.port.port_names = [p.name for p in cfg.ports]
        # include only sent and received packet counts
        req.port.column_names = [req.port.FRAMES_TX, req.port.FRAMES_RX]

        # fetch port metrics
        res = api.get_metrics(req)

        # wait for port metrics to be as expected
        expected = sum([f.duration.fixed_packets.packets for f in cfg.flows])
        assert wait_for(lambda: port_metrics_ok(api, req, expected)), "Metrics validation failed!"

    elif args.metric == 'flow':
        # create a flow metrics request and filter based on port names
        req = api.metrics_request()
        req.flow.flow_names = [f.name for f in cfg.flows]

        # fetch metrics
        res = api.get_metrics(req)

        # wait for flow metrics to be as expected
        expected = sum([f.duration.fixed_packets.packets for f in cfg.flows])
        assert wait_for(lambda: flow_metrics_ok(api, req, expected)), "Metrics validation failed!"

if __name__ == '__main__':
    sys.exit(main())
```
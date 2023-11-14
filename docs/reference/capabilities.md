# Supported capabilities

## Protocol emulation

| Feature  | OTG model specification | Ixia-c software | IxOS hardware | UHD400T system | Comments  |
|---|---|---|---|---|---|
| <span style="color: grey;">**BGP(v4/v6)**</span>  | Y  | Y  |  Y | Y  |   |
|  v4/v6  Routes   | Y  |  Y |  Y | Y  |   |
|  Route Withdraw/Re-advertise | Y  | Y  | Y  | Y  |   |
|  Md5 Authentication  |  Y  |  Y |  Y | Y  |  |
|  Learned Routes Retrieval | Y  | Y  | Y  |  Y |   |
|  Extended Community  |  Y |  Y | Y  | Y  |   |
|  Graceful Restart (Helper and Restarting) |   | Y  | Y  |  Y |   |
| <span style="color: grey;">**Static LAG**</span>   | Y  | Y  | Y  |  N |   |
| <span style="color: grey;">**LAG with LACP**</span>  | Y  | Y  | Y  |  N |   |
| Protocols/Data over LAG with traffic switch   | Y  |  Y |  N |  N |   |
| <span style="color: grey;">**ISIS**</span> |   |   |   |  N |   |
|  v4/v6 Routes  | Y  |   |   |  N |   |
|  Learned Routes Retrieval |  Y | Y  | _N_  | N  |   |
|  Simulated Topology | N |  N | N  | N  |    |
|  Segment Routing  | N  |  N | N  | N |   |
| Multiple ports/adjacencies  |  Y | N  | N  |  N |   |
| <span style="color: grey;">**RSVP p2p LSPs (Ingress or Egress)**</span>  | Y  |  Y | Y  |  N |  UHD work = MPLS Label insertion in traffic flows. |
|  Srefresh and Bundle extensions | Y  | Y  | Y  | N  |   |
|  <span style="color: grey;">**LLDP**</span> |  Y | Y  |  N |  Y | Should work on UHD as it is.  |
|   Per Port | Y  | Y  | N | Y  |   |
|  Learned LLDP Neighbors | Y  | Y  | N  |  Y |   |
| Per LAG member Port  | Y  |  Y |  N |  N |   |

## Traffic generation

| Feature  | OTG model specification | Ixia-c software | IxOS hardware | UHD400T system | Comments  |
|---|---|---|---|---|---|
|  Egress Tracking | Y  |  Y | Y  |  N |   |
| Imix  | Y  |  Y |  Y |  N |   |
| Dynamic ARP Resolution  | Y  | Y  | Y  |  Y |   |
|  Dynamic Frame Size control | Y  |  Y |  Y |  N |   |
| Dynamic Rate Control  | Y  |  Y |  N |  N |   |
|  Multiple Rx Ports and drilldown  | Y  | Y  |   Y|  N |   |
| <span style="color: grey;">**Packet headers**</span>  |   |   |   |   |   |
| Vlan  | Y  | Y  | Y  | Y  |   |
| IPv4  |  Y | Y  | Y  | Y  |   |
| IPv6  | Y  |  Y | Y  | Y  |   |
| TCP  |  Y |  Y | Y  | Y  |   |
| UDP  |  Y | Y  | Y  | Y  |   |
|  MPLS |  Y | Y  | Y  | N  |   |
|  ARP |  Y | Y  |  Y | Y  |   |
|  PPP |  Y |  Y |  Y | N  |   |
|   GRE| Y  | Y  | Y  |  N |   |
|IGMPv1   | Y  | Y  | Y  | N  |   |
|  ICMP | Y  | Y  |  Y |N   |   |
|  ICMPv6 |  Y | Y  | Y  | N  |   |
| ETHERNETPAUSE  | Y  | Y  |  Y |  N |   |
|  VXLAN | Y  |  Y |  Y | N  |   |
|  PFCPAUSE | Y  | N  |  Y |  N |   |
|  CUSTOM |  Y | Y  |  Y |  N |   |

## Infrastructure

| Feature  | OTG model specification | Ixia-c software | IxOS hardware | UHD400T system | Comments  |
|---|---|---|---|---|---|
|  Capture (Rx only) |  Y |  Y | Y  |  N |   |
|  Link Down/Up  | Y  |  N |  Y | N  |   |
|  MTU greater than 1500 | Y (under disc for L1)  |  N |  Y | N  | Need to change/fix L1 properties for common script to work with MTU setting. Ixia-c pending controller handling . PE/TE supports MTU changes.   |

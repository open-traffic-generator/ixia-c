# Introduction

The UHD-400G-T16 is a high-performance ultra high density, highly flexible, software defined tester for all your next generation testing needs. It works seamlessly with diverse testbeds like a single Device Under Test, or a network with multiple devices, or it can even integrate into a network simulation/emulation environment on a Kubernetes cluster.

Ports 1 to 16 on the UHD operate as traffic generator ports.

![UHD](res/UHD100T32.png "UHD-400G")


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



## Connecting the Demo Testbed
The demo testbed consists of a server and the UHD connected to each other. The server is used to run the control plane. In this case we are using the Ixia-c protocol engine. The UHD provides stateless traffic generation and analysis services. The server acts as the protocol engine(PE) and the UHD as the traffic engine(TE) in the demos described below.

![Demo Testbed connections](res/testbed_connections.svg "Demo Testbed Connections")





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





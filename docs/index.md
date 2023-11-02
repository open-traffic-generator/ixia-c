# <h1 align="center">ixia-c</h1>

<h3 align="center">
  A powerful traffic generator based on the <a href="https://github.com/open-traffic-generator/models" target="_blank">Open Traffic Generator API</a>
</h3>

It is **available for free** and distributed as a multi-container application that consists of a [controller](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-controller), a [traffic-engine](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine), and an [app-usage-reporter](https://github.com/orgs/open-traffic-generator/packages/container/package/keng-app-usage-reporter).

## Key Features

* High Performance
  * Runs on servers or Keysight hardware (commercial version only)
  * Generates kbps to Tbps of traffic using same script
  * 10Gbps @ 64 byte frame size using one Xeon class core (commercial version only)
  * Built using [DPDK](https://www.dpdk.org)
* Fast REST API for automation
  * Easily integrates with test frameworks like [pytest](https://www.pytest.org)
  * Easily integrates into CI/CD pipelines with Jenkins, GitHub, GitLab
* Up to 256 flows per port.  Each Flow supports:
  * Packet Templates for Ethernet, VLAN, VXLAN, GTPv1, GTPv2, IPv4, IPv6, ICMP, ICMPv6, GRE, UDP, & TCP.  More protocols are on the way.
  * Ability to use tools like Scapy to add headers for unsupported protocols.
  * Manipulation of any field in the packet headers
  * Patterns to modify common packet header fields to generate millions of unique packets
  * Ability to track flows based on common packet header fields
  * Configurable frame size
  * Rate specification in pps (packets per second) or % line-rate
  * Ability to send bursts
* Statistics
  * Per port and per flow
  * One way latency measurements (min, max, average) on a per flow basis
* Capture
  * Packets with filters
  * Write to PCAP or redirect to tcpdump

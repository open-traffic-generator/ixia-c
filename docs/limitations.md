# Limitations

* [Table of Contents](readme.md)

* Supported protocol headers are `ethernet`, `ipv4`, `ipv6`, `vlan`, `tcp`, `udp`, `gtpv1`, `gtpv2`, `arp`, `icmp` and `custom`.
* `fixed_packets`, `fixed_seconds`,`continuous` and `burst` are supported for flow duration (fixed number of `burst` is not supported).
* Size of the packet must be a value greater than or equal to 64 bytes.
* Setting random frame size is not supported.
* Only `value`, `values`,`increment` and `decrement` patterns are supported for Protocol Header fields.
* A maximum of `4` increment, decrement and values patterns are supported per flow.
* A maximum of `500K` list entries are supported per list pattern, per flow.
* A maximum of `256 flows` for a given tx-rx port pair is supported.
* Statistics based on `ingress_result_name` is not supported.
* Tx statistics for flow results is not supported.
* Starting or stopping transmit on selected flows is not supported. Pausing flows is not supported.
* `lags`, `devices` and `options` in `Config` are not supported.
* Only `speed`, `promiscuous` and `mtu` settings are supported in `Layer1`.
* In Centos 7+, with Python 2.7+, virtualenv creation fails due to a known limitation 
  (https://github.com/pypa/virtualenv/issues/1609). It can be avoided by upgrading pip and then

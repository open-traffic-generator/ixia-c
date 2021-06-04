#### Release Notes and Version Compatibility

## [31/05/2021] Latest Release: ##

* About the release:
    - This build consists of a feature addition and couple of bug fixes.
 

* Build Details:
    - ixia-c-controller: 0.0.1-1388
    - ixia-c-traffic-engine: 1.2.0.12
    - ixia-c-app-usage-reporter: 0.0.1-36
    - open-traffic-generator: 0.3.10
    - snappi: 0.3.20
 

* New Feature(s):
    - Introduced delay support for all kind of flow duration (i.e. continuous, fixed_packets, fixed_seconds, burst)
 

* Bug Fixes:
    - For burst as flow duration type Inter-Burst-Gap value can be set beyond 4.2 seconds.
    - Introduced a way to allow invalid phb values for dscp priority in case of IPv4 packets. This is just for testing purpose.
    - Added validation to throw an error for over subscribed rate during set_config
    - Fixed an error in calculation for packet count when flow duration is set in terms of fixed_seconds.
 

* Known Issues:
    - Rx Fps & Rx Bytes rate is always remains 0 in port statistics
    - Min Latency is always remains 0 in flow statistics
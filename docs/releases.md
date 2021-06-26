# Ixia-c Release Notes and Version Compatibility

## Release v0.0.1-1622 (Latest)
> 25th June, 2021

#### About

This build contains support for protocols GRE and VXLAN, enabling/disabling flow metrics and some bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.4.0](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.4.0/openapi.yaml) |
| snappi                        | 0.4.0         |
| ixia-c-controller             | 0.0.1-1622    |
| ixia-c-traffic-engine         | 1.4.0.1       |
| ixia-c-app-usage-reporter     | 0.0.1-36      |

#### New Feature(s)

* Flow header configuration for protocols `GRE` and `VXLAN` are now supported.
* Flow metrics is now disabled by default to allow transmitting packets with `unaltered payload `(i.e. without any timestamps and instrumentation bytes embedded in it).
* Flow metrics (including metrics that are its sub-properties, e.g. `latency` and `timestamp`) can now be explicitly enabled on per-flow basis.

#### Bug Fixes

* `ixia-c-controller` can now safely serve multiple parallel requests from different clients preventing any undefined behavior.
* Port metrics can now be fetched for ports which are not part of flow configuration.
* Providing port locations for `ixia-c-traffic-engine` running in unsupported mode will now throw a user-friendly error.
* Default values for `increment` and `decrement` properties in flow header fields are now aligned per Open Traffic Generator API.

#### Known Issues

* Checksum field in `GRE` header currently cannot be set.
* The metric `loss` in flow metrics is currently not supported.


## Release v0.0.1-1388
> 31st May, 2021

#### About

This build contains support for flow delay and some bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.3.10](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.3.10/openapi.yaml) |
| snappi                        | 0.3.20        |
| ixia-c-controller             | 0.0.1-1388    |
| ixia-c-traffic-engine         | 1.2.0.12      |
| ixia-c-app-usage-reporter     | 0.0.1-36      |

#### New Feature(s)

* Ixia-c now supports `delay` parameter in flow configuration.  Refer to [v0.3.10](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.3.10/openapi.yaml) of the Open Traffic Generator API specification for more details.

#### Bug Fixes

* The flow configuration parameter `inter_burst_gap` when specified in nanoseconds can now be set to a value larger than 4.2 seconds.
* Invalid values can now be set for the `phb` (per hob behavior) field in the DSCP bits in the IPv4 header.
* The `set_config` method will return an error when flows are over subscribed.
* Fixed an error in calculation for packet counts when `duration` is set in terms of fixed_seconds.

#### Known Issues

* The metrics `frames_rx_rate` and `bytes_rx_rate` in port statistics are not calculated correctly and are always zero.
* The metric `min_latency_ns` in flow statistics is not calculated correctly and is always zero.

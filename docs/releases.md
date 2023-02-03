# Ixia-c Release Notes and Version Compatibility

## Release  v0.0.1-3767 (Latest)
> 2nd February, 2023

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages), We stopped publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom).

#### About

This build contains bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.10.7](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.10.7/artifacts/openapi.yaml)         |
| snappi                        | [0.10.5](https://pypi.org/project/snappi/0.10.5)        |
| gosnappi                      | [0.10.5](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.10.5)        |
| ixia-c-controller             | [0.0.1-3768](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.29](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.271](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.10.7-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.10.8](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3768](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

### Bug Fix(s)
* Issue where TCP header length was not set correctly is fixed. [#117](https://github.com/open-traffic-generator/ixia-c/issues/117)

#### Known Issues
* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.
* [#118](https://github.com/open-traffic-generator/ixia-c/issues/118)

## Release  v0.0.1-3724
> 20th January, 2023

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages), We stopped publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom).

#### About

This build contains bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.10.6](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.10.6/artifacts/openapi.yaml)         |
| snappi                        | [0.10.4](https://pypi.org/project/snappi/0.10.4)        |
| gosnappi                      | [0.10.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.10.4)        |
| ixia-c-controller             | [0.0.1-3724](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.24](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.256](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-ixhw-server        | [0.10.6-1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-ixhw-server)    |
| ixia-c-operator               | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.10.6](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3722](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

### Bug Fix(s)
* Payload size field in all inner headers for tunneling protocols do not take into account inner FCS is fixed. [#112](https://github.com/open-traffic-generator/ixia-c/issues/112)


#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.0.1-3698
> 15th December, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages), We stopped publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom).

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.10.5](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.10.5/artifacts/openapi.yaml)         |
| snappi                        | [0.10.3](https://pypi.org/project/snappi/0.10.3)        |
| gosnappi                      | [0.10.3](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.10.3)        |
| ixia-c-controller             | [0.0.1-3698](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.252](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-operator               | [0.3.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.10.5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3698](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |


#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.0.1-3662
> 1st December, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.9.10](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.10/artifacts/openapi.yaml)         |
| snappi                        | [0.9.8](https://pypi.org/project/snappi/0.9.8)        |
| gosnappi                      | [0.9.8](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.8)        |
| ixia-c-controller             | [0.0.1-3662](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.243](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-operator               | [0.3.0](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.9.9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3662](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

### Features(s)
* `ixia-c-controller` now runs with a non-root user inside the container (instead of root user previously)
* `ixia-c-controller` now listens on non-privileged HTTPs port 8443 (instead of 443 previously)


#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.


## Release  v0.0.1-3619
> 10th November, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.9.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.1/artifacts/openapi.yaml)         |
| snappi                        | [0.9.4](https://pypi.org/project/snappi/0.9.4)        |
| gosnappi                      | [0.9.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.4)        |
| ixia-c-controller             | [0.0.1-3619](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.238](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-operator               | [0.2.6](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.9.7](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3619](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

### Features(s)
* `ixia-c-controller` and `ixia-c-gnmi-server` can now accept the environment variables `HTTP_PORT` and `HTTP_SERVER` respectively, overriding the values provided for corresponding arguments `--http-port` and `--http-server`.

* `ixia-c-controller` and `ixia-c-gnmi-server` can now be run using an arbitrary UID (user ID), to support deployment in OpenShift environment.

#### Bug Fix(s)
* Fixed [#15](https://github.com/open-traffic-generator/ixia-c-operator/issues/15).


#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.0.1-3587
> 28th October, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### About

This build contains bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.9.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.1/artifacts/openapi.yaml)         |
| snappi                        | [0.9.4](https://pypi.org/project/snappi/0.9.4)        |
| gosnappi                      | [0.9.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.4)        |
| ixia-c-controller             | [0.0.1-3587](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.236](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-operator               | [0.2.5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.9.5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3587](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |


#### Bug Fix(s)

* [#101](https://github.com/open-traffic-generator/ixia-c/issues/101) fixed.


#### Known Issues

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.


## Release  v0.0.1-3423
> 29th September, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.9.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.1/artifacts/openapi.yaml)         |
| snappi                        | [0.9.4](https://pypi.org/project/snappi/0.9.4)        |
| gosnappi                      | [0.9.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.4)        |
| ixia-c-controller             | [0.0.1-3423](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.19](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.232](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-operator               | [0.2.2](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.9.5](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3423](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Known Limitations

* Supported value for `flows[i].metrics.latency.mode` is `cut_through`.
* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets.

## Release  v0.0.1-3383
> 16th September, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.9.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.1/artifacts/openapi.yaml)         |
| snappi                        | [0.9.4](https://pypi.org/project/snappi/0.9.4)        |
| gosnappi                      | [0.9.4](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.4)        |
| ixia-c-controller             | [0.0.1-3383](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.17](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.225](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-operator               | [0.2.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.9.3](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3380](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Release Features(s)

* Support added for `increment` and `decrement` `values` in all `MPLS` packet header fields. 
* Support added for raw traffic where `tx` and `rx` endpoints could be same.
* Support added in `traffic-engine-service` deployment to disable IPv6 networking.
    - `OPT_ENABLE_IPv6` environment flag is introduced. If it is `Yes` ipv6 networking will be enabled and if it is `No` ipv6 networking status will be unchanged.

#### Bug Fix(s)

* `get_config` is failing, if config contains TCP header. it is fixed now. [#184](https://github.com/open-traffic-generator/snappi/issues/184)

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets

## Release  v0.0.1-3182 (Latest)
> 1st September, 2022

#### Announcement

`ixia-c` container images are hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) until 18th November, 2022.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.9.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.9.1/artifacts/openapi.yaml)         |
| snappi                        | [0.9.3](https://pypi.org/project/snappi/0.9.3)        |
| gosnappi                      | [0.9.3](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.9.3)        |
| ixia-c-controller             | [0.0.1-3182](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.217](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-operator               | [0.2.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.9.1](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-one                    | [0.0.1-3182](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Release Features(s)

* `ixia-c-controller` container now supports gRPC requests on default TCP port 40051 (alongside TCP port 8443 for HTTP) and hence `ixia-c-grpc-server` container is no longer needed.
* There has been a breaking change in OTG API to provide stronger compatibility guarantees across different `semver patch versions` of snappi and ixia-c-controller.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets

## Release  v0.0.1-3113
> 18th August, 2022

#### Announcement

From now onwards `ixia-c` container images will be hosted on [GitHub Container Registry](https://github.com/orgs/open-traffic-generator/packages). However we will continue publishing `ixia-c` container images to [DockerHub](https://hub.docker.com/r/ixiacom) as well for the next 3 months. (until 18th November, 2022)

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.8.6](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.6/artifacts/openapi.yaml)         |
| snappi                        | [0.8.8](https://pypi.org/project/snappi/0.8.8)        |
| gosnappi                      | [0.8.8](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.8)        |
| ixia-c-controller             | [0.0.1-3113](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-controller)    |
| ixia-c-traffic-engine         | [1.6.0.9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-traffic-engine)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-app-usage-reporter)      |
| ixia-c-protocol-engine        | [1.00.0.214](https://github.com/orgs/open-traffic-generator/packages/container/package/licensed%2Fixia-c-protocol-engine)    | 
| ixia-c-operator               | [0.1.95](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-operator)        | 
| ixia-c-gnmi-server            | [1.8.13](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-gnmi-server)         |
| ixia-c-grpc-server            | [0.8.9](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-grpc-server)         |
| ixia-c-one                    | [0.0.1-3113](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Release Features(s)

* Support added for setting transmit state on subset of configured flows.
  https://github.com/open-traffic-generator/ixia-c/issues/56

#### Bug Fix(s)

* When flow duration is configured using `fixed_seconds`, then in some cases packet transmission does not stop after specified duration has elapsed.
  https://github.com/open-traffic-generator/ixia-c/issues/95

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.
* When flow transmit is started, transmission will be restarted on any existing flows already transmitting packets


## Release  v0.0.1-3027
> 4th August, 2022

#### About

Support added for static `MPLS` packet header in flows.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.8.6](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.6/artifacts/openapi.yaml)         |
| snappi                        | [0.8.8](https://pypi.org/project/snappi/0.8.8)        |
| gosnappi                      | [0.8.8](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.8)        |
| ixia-c-controller             | [0.0.1-3027](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.209     | 
| ixia-c-operator               | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.8.10](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.8.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |
| ixia-c-one                    | [0.0.1-3027](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Release Features(s)

* Support added for static `MPLS` packet header in flows.
    - Fixed value is supported for all fields.
    - Dynamic `MPLS` is not supported yet.
        - `label` field's  default choice is `value` if it is selected as `auto`.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-3002
> 27th July, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.8.5](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.5/artifacts/openapi.yaml)         |
| snappi                        | [0.8.5](https://pypi.org/project/snappi/0.8.5)        |
| gosnappi                      | [0.8.5](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.5)        |
| ixia-c-controller             | [0.0.1-3002](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.205     | 
| ixia-c-operator               | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.8.8](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.8.7](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |
| ixia-c-one                    | [0.0.1-3002](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.


## Release  v0.0.1-3000
> 21st July, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.8.5](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.5/artifacts/openapi.yaml)         |
| snappi                        | [0.8.5](https://pypi.org/project/snappi/0.8.5)        |
| gosnappi                      | [0.8.5](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.5)        |
| ixia-c-controller             | [0.0.1-3000](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.203     | 
| ixia-c-operator               | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.8.8](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.8.7](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |
| ixia-c-one                    | [0.0.1-3000](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.


## Release  v0.0.1-2994
> 1st July, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.8.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.1/artifacts/openapi.yaml)         |
| snappi                        | [0.8.2](https://pypi.org/project/snappi/0.8.2)        |
| gosnappi                      | [0.8.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.2)        |
| ixia-c-controller             | [0.0.1-2994](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.192     | 
| ixia-c-operator               | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.8.3](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.8.2](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |
| ixia-c-one                    | [0.0.1-2994](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2992
> 30th June, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.8.1](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/open-traffic-generator/models/v0.8.1/artifacts/openapi.yaml)         |
| snappi                        | [0.8.2](https://pypi.org/project/snappi/0.8.2)        |
| gosnappi                      | [0.8.2](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.8.2)        |
| ixia-c-controller             | [0.0.1-2992](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.191     | 
| ixia-c-operator               | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.8.3](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.8.2](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |
| ixia-c-one                    | [0.0.1-2992](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2969
> 16th June, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.15](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.15/openapi.yaml)         |
| snappi                        | [0.7.41](https://pypi.org/project/snappi/0.7.41)        |
| gosnappi                      | [0.7.41](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.41)        |
| ixia-c-controller             | [0.0.1-2969](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.29](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.181     | 
| ixia-c-operator               | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.7.31](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.17](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |
| ixia-c-one                    | [0.0.1-2969](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2934
> 2nd June, 2022

#### About

This build contains bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.13](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.13/openapi.yaml)         |
| snappi                        | [0.7.37](https://pypi.org/project/snappi/0.7.37)        |
| gosnappi                      | [0.7.37](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.37)        |
| ixia-c-controller             | [0.0.1-2934](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.26](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.174     | 
| ixia-c-operator               | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.7.27](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.15](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |
| ixia-c-one                    | [0.0.1-2934](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### Bug Fix(s)
* `ixia-c-controller` will return an empty response instead of error when `metrics` / `states` are queried right after boot-up.
* `ixia-c-gnmi-server` will return an empty response instead of error when `metrics` / `states` are queried without ever setting config

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2897
> 19th May, 2022

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml)         |
| snappi                        | [0.7.18](https://pypi.org/project/snappi/0.7.18)        |
| gosnappi                      | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)        |
| ixia-c-controller             | [0.0.1-2897](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.26](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.165     | 
| ixia-c-operator               | [0.1.94](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.7.23](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.12](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |
| ixia-c-one                    | [0.0.1-2897](https://github.com/orgs/open-traffic-generator/packages/container/package/ixia-c-one/)         |

#### New Feature(s)

* `ixia-c-one` is now supported on platforms with `cgroupv2` enabled. https://github.com/open-traffic-generator/ixia-c/issues/77

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2801
> 9th May, 2022

#### About

This build includes stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml)         |
| snappi                        | [0.7.18](https://pypi.org/project/snappi/0.7.18)        |
| gosnappi                      | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)        |
| ixia-c-controller             | [0.0.1-2801](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.26](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.158     | 
| ixia-c-operator               | [0.1.89](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.7.15](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2790
> 5th May, 2022

#### About

This build includes stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml)         |
| snappi                        | [0.7.18](https://pypi.org/project/snappi/0.7.18)        |
| gosnappi                      | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)        |
| ixia-c-controller             | [0.0.1-2790](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.26](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.158     | 
| ixia-c-operator               | [0.0.80](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.7.15](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2770
> 21st April, 2022

#### About

This build includes stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml)         |
| snappi                        | [0.7.18](https://pypi.org/project/snappi/0.7.18)        |
| gosnappi                      | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)        |
| ixia-c-controller             | [0.0.1-2770](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.0.0.275](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.154     | 
| ixia-c-operator               | [0.0.80](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [1.7.13](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.


## Release  v0.0.1-2755
> 7th April, 2022

#### About

This build includes following bug fix
- Clearing of `port` and `flow` statistics as part of `set_config`.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml)         |
| snappi                        | [0.7.18](https://pypi.org/project/snappi/0.7.18)        |
| gosnappi                      | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)        |
| ixia-c-controller             | [0.0.1-2755](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.23](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.152     | 
| ixia-c-operator               | [0.0.75](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### Bug Fix(s)

* Clearing of `port` and `flow` statistics is now part of `set_config`. 

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2738
> 25th March, 2022

#### About

This build includes following new functionalities
- fix in handling of `ether_type` field of ethernet packet

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml)         |
| snappi                        | [0.7.18](https://pypi.org/project/snappi/0.7.18)        |
| gosnappi                      | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)        |
| ixia-c-controller             | [0.0.1-2738](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.23](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.151     | 
| ixia-c-operator               | [0.0.75](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### New Feature(s)

* Users would be able to set `ether_type` in ethernet header which may not be based on the next header type.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2727
> 24th March, 2022

#### About

This build includes following new functionalities
- correct received(rx) rate statistics in port metrics
- auto destination mac learning support in destination mac field of ethernet packet

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.8](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.8/openapi.yaml)         |
| snappi                        | [0.7.18](https://pypi.org/project/snappi/0.7.18)        |
| gosnappi                      | [0.7.18](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.18)        |
| ixia-c-controller             | [0.0.1-2727](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.23](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.151     | 
| ixia-c-operator               | [0.0.75](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.8](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### New Feature(s)

* Correct received(rx) rate statistics support is incorporated as part of port metrics.
    * `frames_rx_rate`
    * `bytes_rx_rate`

* [Breaking Change] Auto learning of destination MAC is currently supported for both IPv4 and IPv6 Flows without any VLAN(originated from device endpoints) by setting ethernet destination with `choice` as `auto` in the packet. Earlier this was working by setting ethernet destination mac with "00:00:00:00:00:00" in the packet header.
    ```
        {
            "choice": "ethernet",
            "ethernet": {
                "dst": {
                    "choice": "auto"
                },
                "src": {
                    "choice": "value",
                    "value": "00:00:01:01:01:01"
                }
            }
        },
    ````

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2678
> 11th March, 2022

#### About

This build contains stability and debuggability enhancements.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.3](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.3/openapi.yaml)         |
| snappi                        | [0.7.13](https://pypi.org/project/snappi/0.7.13)        |
| gosnappi                      | [0.7.13](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.13)        |
| ixia-c-controller             | [0.0.1-2678](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.23](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.146     | 
| ixia-c-operator               | [0.0.75](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.7.5](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.7](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release  v0.0.1-2662
> 24th February, 2022

#### About

This build implements transmit(tx) statistics & transmit state of flow metrics.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.3](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.3/openapi.yaml)         |
| snappi                        | [0.7.13](https://pypi.org/project/snappi/0.7.13)        |
| gosnappi                      | [0.7.13](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.13)        |
| ixia-c-controller             | [0.0.1-2662](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.23](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.144     | 
| ixia-c-operator               | [0.0.75](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.7.5](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.6](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### New Feature(s)

* Transmit(tx) statistics & Transmit state support is incorporated as part of flow metrics.
    * `transmit`
    * `frames_tx`
    * `frames_tx_rate`

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2610
> 10th February, 2022

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.3](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.3/openapi.yaml)         |
| snappi                        | [0.7.13](https://pypi.org/project/snappi/0.7.13)        |
| gosnappi                      | [0.7.13](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.13)        |
| ixia-c-controller             | [0.0.1-2610](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.5](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.133     | 
| ixia-c-operator               | [0.0.72](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.7.5](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.5](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.



## Release v0.0.1-2597
> 27th January, 2022

#### About

This build contains debuggability enhancements.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.2](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.2/openapi.yaml)         |
| snappi                        | [0.7.6](https://pypi.org/project/snappi/0.7.6)        |
| gosnappi                      | [0.7.6](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.6)        |
| ixia-c-controller             | [0.0.1-2597](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.2](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.133     | 
| ixia-c-operator               | [0.0.70](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.7.4](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.4](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2543
> 16th December, 2021

#### About

This build contains stability fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.7.2](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.7.2/openapi.yaml)         |
| snappi                        | [0.7.3](https://pypi.org/project/snappi/0.7.3)        |
| gosnappi                      | [0.7.3](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.7.3)        |
| ixia-c-controller             | [0.0.1-2543](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.1.2](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.127     | 
| ixia-c-operator               | [0.0.70](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.7.2](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.7.2](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.
## Release v0.0.1-2446
> 2nd December, 2021

#### About

This build introduces ability to return large `FramesTx/RX` values by `metric` APIs.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.6.13](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.13/openapi.yaml)         |
| snappi                        | [0.6.21](https://pypi.org/project/snappi/0.6.21)        |
| gosnappi                      | [0.6.21](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.6.21)        |
| ixia-c-controller             | [0.0.1-2446](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.0.15](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.115     | 
| ixia-c-operator               | [0.0.70](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.6.18](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.6.17](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |


#### New Feature(s)

* Maximum `FramesTx` and `FramesRx` value that can be correctly returned by `flow_metrics` and `port_metrics` has been increased from 2147483648 to 9.223372e+18

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2399
> 18th November, 2021

#### About

This build introduces ability to auto plug in default values for missing fields with primitive types upon receiving JSON payload.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.6.10](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.10/openapi.yaml)         |
| snappi                        | [0.6.16](https://pypi.org/project/snappi/0.6.16)        |
| gosnappi                      | [0.6.16](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.6.16)        |
| ixia-c-controller             | [0.0.1-2399](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.0.15](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.111     | 
| ixia-c-operator               | [0.0.70](https://hub.docker.com/r/ixiacom/ixia-c-operator/tags)        | 
| ixia-c-gnmi-server            | [0.6.14](https://hub.docker.com/r/ixiacom/ixia-c-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.6.15](https://hub.docker.com/r/ixiacom/ixia-c-grpc-server/tags)         |


#### New Feature(s)

* Upon receiving JSON payload, ixia-c-controller will now automatically plug in default values for missing fields with primitive types.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2367
> 5th November, 2021

#### About

This build introduces uniform logging across some Ixia-c components.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.6.7](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.7/openapi.yaml)         |
| snappi                        | [0.6.12](https://pypi.org/project/snappi/0.6.12)        |
| gosnappi                      | [0.6.12](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.6.12)        |
| ixia-c-controller             | [0.0.1-2367](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.0.15](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.96      | 
| ixia-c-operator               | 0.0.1-65       | 
| ixia-c-gnmi-server            | [0.6.11](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.6.11](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)         |


#### Bug Fix(s)

* Introduced structured logging for `ixia-c-gnmi-server` and `ixia-c-grpc-server` to aid uniform logging across Ixia-c components.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2342
> 27th October, 2021

#### About

This build contains validation bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.6.5](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.5/openapi.yaml)         |
| snappi                        | [0.6.5](https://pypi.org/project/snappi/0.6.5)        |
| gosnappi                      | [0.6.5](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.6.5)        |
| ixia-c-controller             | [0.0.1-2342](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.0.15](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.83      | 
| ixia-c-operator               | 0.0.1-65       | 
| ixia-c-gnmi-server            | [0.6.6](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.6.6](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)         |


#### Bug Fix(s)

* Validation has been fixed for traffic configuration consisting of IPv4 and IPv6 interface names

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.


## Release v0.0.1-2337
> 21st October, 2021

#### About

This build contains bugfixes for SetConfig and FPS values in GetMetrics.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.6.5](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.5/openapi.yaml)         |
| snappi                        | [0.6.5](https://pypi.org/project/snappi/0.6.5)        |
| gosnappi                      | [0.6.5](https://pkg.go.dev/github.com/open-traffic-generator/snappi/gosnappi@v0.6.5)        |
| ixia-c-controller             | [0.0.1-2337](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.0.14](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.83      | 
| ixia-c-operator               | 0.0.1-65       | 
| ixia-c-gnmi-server            | [0.6.6](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)         |
| ixia-c-grpc-server            | [0.6.6](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)         |


#### New Feature(s)

* The race condition during connection initialization in `SetConfig` is fixed for scenarios involving large port count.
* FPS value in `GetMetrics` for ports and flows is fixed for scenarios involving multiple consecutive SetTransmitState calls.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.

## Release v0.0.1-2289
> 29th September, 2021

#### About

This build contains support for performance optimisation through concurrent port operations.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.6.1](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.6.1/openapi.yaml)         |
| snappi                        | [0.6.1](https://pypi.org/project/snappi/0.6.1)        |
| ixia-c-controller             | [0.0.1-2289](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.0.13](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.70      | 
| otg-gnmi-server               | [0.6.1](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)         |
| otg-grpc-server               | [0.6.1](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)         |


#### New Feature(s)

* Performance is optimised through concurrent port operations.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.


## Release v0.0.1-2185 
> 8th September, 2021

#### About

This build contains support for updating flow rate without disrupting transmit state.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.5.4](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.5.4/openapi.yaml)         |
| snappi                        | [0.5.3](https://pypi.org/project/snappi/0.5.3)        |
| ixia-c-controller             | [0.0.1-2185](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.0.11](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.56     | 
| otg-gnmi-server               | [0.5.2](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)         |
| otg-grpc-server               | [0.5.3](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)         |


#### New Feature(s)

* Updating flow rate without disrupting transmit state is now supported. Rate of multiple flows can be updated simultaneously through `update_flows` api without stopping the traffic. 

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.


## Release v0.0.1-2120 
> 27th August, 2021

#### About

This build contains support for capture filter, setting GRE checksum flag, redirecting Ixia-c controller log to stdout and some bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.4.12](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.4.12/openapi.yaml)         |
| snappi                        | [0.4.25](https://pypi.org/project/snappi/0.4.25)        |
| ixia-c-controller             | [0.0.1-2120](https://hub.docker.com/r/ixiacom/ixia-c-controller/tags)    |
| ixia-c-traffic-engine         | [1.4.0.9](https://hub.docker.com/r/ixiacom/ixia-c-traffic-engine/tags)       |
| ixia-c-app-usage-reporter     | [0.0.1-37](https://hub.docker.com/r/ixiacom/ixia-c-app-usage-reporter/tags)      |
| ixia-c-protocol-engine        | 1.00.0.50     | 
| otg-gnmi-server               | [0.4.4](https://hub.docker.com/r/otgservices/otg-gnmi-server/tags)         |
| otg-grpc-server               | [0.0.9](https://hub.docker.com/r/otgservices/otg-grpc-server/tags)         |


#### New Feature(s)

* Capture filters are now supported. Multiple patterns can be specified in the configuration.
* Controller log is now redirected to stdout. `docker logs` can now be used to access Ixia-c controller logs.
* Checksum field in `GRE` header now can be set.

#### Bug Fixes

* All patterns of IPv6 value now can be set for `increment` and `decrement` properties in flow header fields.
* Default value of step for `decrement` properties in flow header fields is now set correctly.

#### Known Issues

* The metric `loss` in flow metrics is currently not supported.


## Release v0.0.1-1622
> 25th June, 2021

#### About

This build contains support for protocols GRE and VXLAN (RFC 2784), enabling/disabling flow metrics and some bug fixes.

#### Build Details

| Component                     | Version       |
|-------------------------------|---------------|
| Open Traffic Generator API    | [0.4.0](https://redocly.github.io/redoc/?url=https://github.com/open-traffic-generator/models/releases/download/v0.4.0/openapi.yaml) |
| snappi                        | 0.4.0         |
| ixia-c-controller             | 0.0.1-1622    |
| ixia-c-traffic-engine         | 1.4.0.1       |
| ixia-c-app-usage-reporter     | 0.0.1-36      |

#### New Feature(s)

* Flow header configuration for protocols `GRE` and `VXLAN (RFC 2784)` are now supported.
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

<h1 align="center">Ixia-c & Elastic Network Generator</h1>
<h3 align="center">Agile and composable network test system designed for continuous integration</h3>

<section>
    <div class="container">
        <div class="column">
          <img src="assets/keng-diagram.png">
        </div>
        <div class="column">
            <ul>
                <li>Implements <a href="https://otg.dev" target="_blank">Open Traffic Generator API</a></li>
                <li>Emulates key <a href="reference/capabilities/#protocol-emulation">control plane protocols</a></li>
                <li>Generates complex <a href="reference/capabilities/#traffic-generation">data plane traffic</a></li>
                <li>Supports <a href="deployments">software</a>, <a href="tests-uhd400">white-box</a> and <a href="tests-chassis-app">hardware</a> test ports​</li>
                <li>Reduces time-to-test with fast API response time and <a href="developer/hello-snappi">agile developer experience</a></li>
                <li>Deploys using <a href="quick-start/deployment">modular architecture</a> based on containers and microservices</li>
                <li>Accelerates network validation by <a href="integrated-environments">integrating</a> with popular network emulation software.</li>
            </ul>
        </div>
    </div>
</section>

## Community Edition

First in its class [Ixia-c Community Edition](quick-start/introduction.md) of the Elastic Network Generator with **BGP emulation and full set traffic capabilities** [limited by scale and performance](licensing.md) is available to anyone without registration and at no cost.

## OTG Examples

Explore [otg-examples](https://otg.dev/examples/otg-examples/) library to get hands-on experience with using Open Traffic Generator and Ixia-c. With a minimum Linux host or VM you can be running your first network data and control plane validation scenarios in minutes.

## Key Features

* Software multi-container application:
    * runs on Linux x86 compute,
    * includes software traffic generation and protocol emulation capabilities,
    * built using DPDK to generate high traffic rates on a single CPU core,
    * can control Keysight network test hardware.
* Easily integrates into CI/CD pipelines like GitHub, GitLab, Jenkins.
* Supports test frameworks like Pytest or Golang test.
* Emulates key data center protocols with high scale of sessions and routes:
    * capable of leveraging 3rd party libraries to add unsupported packet formats,
    * provides patterns to modify common packet header fields to generate millions of unique packets.
* Supports:
    * configurable frame sizes,
    * rate specification in pps (packets per second) or % line-rate,
    * ability to send traffic bursts.
* Statistics:
    * per port and per flow,
    * tracks flows based on common packet header fields,
    * one way latency measurements (min, max, average) on a per flow basis,
    * capture packets and write to PCAP or analyze in the test logic.

## Copyright notice

© Copyright Keysight Technologies, Inc. 2021, 2022, 2023
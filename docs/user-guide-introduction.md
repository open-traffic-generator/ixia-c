# Introduction
[Keysight Elastic Network Generator](https://www.keysight.com/us/en/products/network-test/protocol-load-test/keysight-elastic-network-generator.html) is an agile, lightweight, and composable network test software designed for Continuous Integration. It supports vendor neutral Open Traffic Generator models and APIs, integrates with several network emulation platforms, and drives a range of Keysight’s Network Infrastructure Test software products, hardware load modules and appliances.

The Elastic Network Generator software runs in Docker-based containerized environments and emulates key data center control plane protocols while also sending data plane traffic. It has a modern architecture based on micro-services and open-source interfaces and is designed for very fast automated test scenario execution. All of these characteristics enable robust validation of data center networks to deliver top quality of experience.

## Components

Keysight Elastic Network Generator provides an abstraction over various test port implementations –
Ixia-c software, UHD400T white-box and purpose-built IxOS hardware. A test program written in Open Traffic Generator API can be run using any of the supported test port types without modifications.

![Test Port Abstraction via OTG](res/otg-keng-labels-on-white.drawio.svg)

The main components of KENG are:

| Component                     | Description |
| -------------                 | ------------- |
| [Test program](https://otg.dev/clients/) | Script or other executable that contains the code that defines the test processes.  |
| [OTG](https://otg.dev)        | Open Traffic Generator, an evolving API specification that defines the components of a traffic generator such as: test ports (virtual or physical), emulated devices, traffic flows, and statistics and capture capability.  |
| [Elastic Network Generator](https://www.keysight.com/us/en/products/network-test/protocol-load-test/keysight-elastic-network-generator.html)     | Controller that manages the flow of commands from the test program to the traffic generation device (virtual or physical) and the flow of results from the device to the test program.  |
| [Ixia-c](tests-ixia-c.md)             | Containerized software traffic generator.  |
| [UHD400T](tests-uhd400.md)            | Composable test ports based on line-rate white-box switch hardware traffic generator and Ixia-c protocol emulation software. |
| [IxOS Hardware](tests-chassis-app.md) | Keysight Novus or AresONE high-performance network test hardware running IxOS.  |

## Clients

To successfully use an OTG-based Traffic Generator, you need to be able to execute the following tasks over the OTG API:

* Prepare a Configuration and apply it to a Traffic Generator
* Control states of the configured objects like Protocols or Traffic Flows
* Collect and analyze Metrics reported by the Traffic Generator

It is a job of an OTG Client to perform these tasks by communicating with a Traffic Generator via the OTG API. There are different types of such clients, and the choice between them depends on how and where you want to use a Traffic Generator.

There are multiple ways to communicate with KENG through the OTG API:

| Method | Description |
| ------------- | ------------- |
| otgen  | A command-line tool that is an easy way to get started  |
| snappi  | A library that makes it easy create test programs in Python or Go  |
| direct REST or gRPC calls  | An alternative to using snappi  |
| custom OTG client  | Custom OTG client applications  |


## OTG Examples

[OTG examples](https://github.com/open-traffic-generator/otg-examples) repository is a great way to get started with [Open Traffic Generator API](https://otg.dev/). It features a collection of software-only network labs ranging from very simple to more complex. To setup the network labs in software, use the containerized or virtualized NOS images.


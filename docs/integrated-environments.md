# Integrated environments

To successfully use an OTG-based Traffic Generator, you need to be able to execute the following tasks over the OTG API:

* Prepare a Configuration and apply it to a Traffic Generator
* Control states of the configured objects like Protocols or Traffic Flows
* Collect and analyze Metrics reported by the Traffic Generator
  
It is a job of an OTG Client to perform these tasks by communicating with a Traffic Generator via the OTG API. There are different types of such clients, and the choice between them depends on how and where you want to use a Traffic Generator.

[OTG examples](https://github.com/open-traffic-generator/otg-examples) repository is a great way to get started with [Open Traffic Generator API](https://otg.dev/). It features a collection of software-only network labs ranging from very simple to more complex. To setup the network labs in software, use the containerized or virtualized NOS images.

## Infrastructure

To manage the deployment of the example labs, use one of the following tools:

* [Containerlab:](deployments-containerlab.md) Simple yet powerful specialized tool for orchestrating and managing container-based networking labs.
* [OpenConfig KNE:](deployments-kne.md) Kubernetes Network Emulation, which is a Google initiative to develop tooling for quickly setting up topologies of containers running various device OSes.

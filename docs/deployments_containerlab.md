
# Deploy Ixia-c-one using containerlab

## Overview

Ixia-c-one is deployed as single-container application by using [containerlab](https://containerlab.dev/quickstart/) that consists of the following services:

* **containerlab**: Containerlab provides a CLI for orchestrating and managing container-based networking labs. It starts the containers, builds a virtual wiring between them to create lab topologies depending on a user's choice, and manages the labs lifecycle.
* **Ixia-c-one**: Keysight ixia-c-one is a single-container distribution of ixia-c, which in turn is Keysight's reference implementation of Open Traffic Generator API.

  Meet the [keysight_ixia-c-one](https://containerlab.dev/manual/kinds/keysight_ixia-c-one) kind! It is available from containerlab [release 0.26](https://containerlab.dev/rn/0.26/#keysight-ixia-c).
* **srl linux**: Nokia SR Linux is a truly open network operating system (NOS), that makes your data center switching infrastructure more scalable, more flexible, and simpler to operate.

<div align="center">
  <img src="res/ixia-c-one-aur.drawio.svg"></img>
</div>

## Install containerlab

  ```sh
  # download and install the latest release (may require sudo)
  bash -c "$(curl -sL https://get.containerlab.dev)"
  ```

## Deploy the topology

* You can find a sample topology definition in <https://containerlab.dev/lab-examples/ixiacone-srl/>, which consists of Nokia SR Linux and Ixia-c-one nodes that are connected to one-another.
* This consists of a Keysight ixia-c-one node with 2 ports connected to 2 ports on an srl linux node via two point-to-point ethernet links. Both nodes are also connected with their management interfaces to the containerlab docker network.

  ```sh
  # After downloading the sample topology file 
  containerlab deploy --topo ixiac01.clab.yml
  ```
  
- After deployment, you are now ready to run a test using the topology.

## Run a test

* Follow this [link](https://containerlab.dev/lab-examples/ixiacone-srl/#execution) to run a test.

## Destroy/Remove the topology

  ```sh
  # delete a particular topology 
  containerlab destroy --topo ixiac01.clab.yml
  ```

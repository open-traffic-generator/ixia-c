# Troubleshooting

This section explains the troubleshooting scenarios for different environments.

## OTG hardware environment

**<ins>The test fails while it is configuring OTG ports</ins>**: This situation may arise due to various reasons. For example, the port ownership is not cleared by the previous test properly, or the OTG port went to a bad state, and etc. The course of action in such scenarios can be as follows:

* Manually clear the ownership of the port.
* Reboot the chassis ports.
* Restsart the docker containers.
* Use `docker compose` or `docker-compose` to turn the containers down and up.
* Execute the following commands from the directory where you have kept your docker-compose.yaml file.

```sh
docker-compose down
```

```sh
docker-compose up -d
```

**<ins>Configuration is failing port-speed mismatch</ins>**: In this scenario, the OTG port configuration will also fail due to the speed mismatch between the DUT port and chassis port.
To execute the test, do the following:

* Adjust your DUT port speed to the default port speed of the chassis port.
* Reboot the chassis ports.
* Execute your test.


**<ins>Test failed to take port ownership</ins>**: This error is often obvious from the message displayed on the console "Failed to take ownership of the following ports". This situation may occur if previous test did not clear the ownership or somebody else is already owning the port. You can go to the chassis UI and clear the port ownership manually by force.

<p align="center">
<img src="res/clearOwnership.PNG" alt="Clear port ownership">
</p>

Please execute you actions in the following order.
* Clear ownership
* Reboot ports

**<ins>Error while starting protocols</ins>**: Root cause of this ports are in bad state or you ignored some error that already occurred earlier to start protocol engine. The error messages may look quite arbtrary to you like:

* Error occurred while starting protocol on protocol ports:Unable find type: Ixia.Aptixia.Cpf.pcpu.IsisSRGBRangeSubObjectsPCPU
* Error occurred while starting protocol on protocol ports:GetPortSession() is NULL

In this situation a quick heuristic is to reboot the ports and restart the docker containers, following the steps described above. In summary clear ownership, reboot ports and restart containers may resolve many of your problems regarding ATE port configuration error.

**<ins>OTG API call failed like start protocol failed due to "context deadline exceeded" error</ins>**: You can increase the timeout deadline by changing the value of the **timeout** parameter of the ate in the binding file. Default value is 30 (in second) you can increase it as per your setup.

```
  # This option specific to OTG over Ixia-HW.
  otg {
    target: "127.0.0.1:40051" # Change this to the Ixia-c-grpc server endpoint.
    insecure: true
    timeout: 120
  }
```
Also, after this change please don’t forget to restart the containers and reboot the hardware ports.

## KNE environment

**<ins>Topology creation failures for Ixia-C pods </ins>**: This occurrs for multiple reasons as stated below, 
* there is mismatch in Ixia-c build versions and older Operator used. Deploy correct versions as per releases "https://github.com/open-traffic-generator/ixia-c/releases"
* the minimum required resource is not met. 
* there is older version of KNE used in client. Please update KNE to newer release "https://github.com/openconfig/kne/releases/" and deploy the topology.

**<ins>Test fails due to timeout </ins>**: This error occurs when the test timeouts, by default timeout is 10m. We can increase this timeout "-timeout 20m" or make sure all the services are reachable for the test to connect and run.

**<ins>Test fails at set config </ins>**: This error occurs if the configuration is not proper, we will see configuration errors such as mistake in flow configuration, BGP LI flag is not enabled but GetStates is called etc. we can correct the configuration and run the test again.

## UHD environment

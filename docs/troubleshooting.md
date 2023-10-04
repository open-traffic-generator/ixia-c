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

## KNE environment

## UHD environment

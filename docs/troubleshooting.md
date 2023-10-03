# Troubleshooting 
Troubleshooting info for different environment.
### OTG hardware environment
**<ins>The test fails while it is configuring OTG ports</ins>** - This situation may arise due to various reasons such as, port ownership is not cleared by previous test properly, or OTG port went to a bad state, etc. In such scenarios course of action could be
  * Manually clear the ownership of the port.
  * Then reboot the chassis ports.
  * Restsart your docker containres.
  * Use 'docker compose' or docker-compose to turn the containers down and up. Execute the below commands from the directory where you have kept your docker-compose.yaml file.
```
docker-compose down
```
```
docker-compose up -d
```
**<ins>Configuration is failing port-speed mismatch</ins>** - In this case OTG port configuration will also fail due to speed mismatch between DUT port and chassis port. In this scenario you can adjust your DUT’s port speed to the default port speed of the chassis port, reboot the chassis ports and then execute your test.
### KNE environment
### UHD environment

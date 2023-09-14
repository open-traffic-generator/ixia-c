# Licensing 

Description of licensing server (VM) and 3 levels of licenses we provide (take from datasheet)
## KENG License Server
## Deploying the Keysight license server on KVM
KVM Resource requirements:
  
  * 2 CPU Cores
  * 8 GB of RAM
  * Minimum 10GB of storage
  * 1 available physical bridged adapter on KVM for management connectivity

### To deploy Keysight license server from qcow2 image:
1. Download deployment script `ixia_c_license_server_kvm_release.sh` install license server VM.
  ```sh
  # Download script
  curl -o ixia_c_license_server_kvm_release.sh https://<location>/ixia_c_license_server_kvm_release.sh
  # Change permission
  chmod u+x ixia_c_license_server_kvm_release.sh
  # Install License server VM
  ./ixia_c_license_server_kvm_release.sh LICENSE_SERVER_VM DHCP DHCP DHCP DHCP AUTO br0
  ```


## Subscription levels
Keysight Elastic Network Generator (KENG) provides three levels of subscriptions.


  | Capability                          | Developer            | Team                           | System                              |
  |-------------------------------------|----------------------|--------------------------------|-------------------------------------|
  | Software Traffic Port Capacity*     |  50GE                |  400GE                         | 800GE                               |
  | Test Concurrency**                  |  1 Seat              |  8 Seats                       | 16 Seats                            |
  | Software and UHD400T Protocol Scale |  Limited             |  Limited                       | UnLimited                           |
  | Works with UHD400T Hardware         |  N                   |  Y                             | Y                                   |
  | Works with IXOS Hardware            |  N                   |  N                             | Y                                   |

 \* **Maximum Data Plane performance** of software port may be less than the included software traffic port capacity, depending on configuration

 \*\* **Test seat concurrency** applies to quanitity of running controller instances with a configuration that exceeds capabilities of the Keysight Elastic Network Generator Community Edition

 

 

 




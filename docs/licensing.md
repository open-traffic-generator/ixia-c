# Licensing 

Description of licensing server (VM) and 3 levels of licenses we provide (take from datasheet)
## KENG License Server
## Deploying the Keysight license server on KVM
KVM Resource requirements:
  
  * 2 CPU Cores
  * 4 GB of RAM
  * Minimum 10GB of storage
  * 1 available physical bridged adapter on KVM for management connectivity

### To deploy Keysight license server from qcow2 image:
1. Download deployment script `ixia_c_license_server_kvm_release.sh` install license server VM.
  ```sh
  # Download script
  curl -o ixia_c_license_server_kvm_release.sh https://<location>/ixia_c_license_server_kvm_release.sh
  # Change permission
  chmod u+x ixia_c_license_server_kvm_release.sh
  # Usage of parameter options
  ./ixia_c_license_server_kvm_release.sh -h
  # Install License server VM (default)
  ./ixia_c_license_server_kvm_release.sh 
  # Install License server VM with parameters
  ./ixia_c_license_server_kvm_release.sh (VM Name) (IP Address) (Netmask) (Gateway) (DNS Server) (SSH Public Key File) (Bridge) [OPTIONS]
  ```
  Installation parameters:
  | Options      | Description  | 
  |-----------------------------|-----------|
  | VM Name                   |   Name of this VM will be assigned     | 
  | IP Address|   IP Address assigned to this VM. Must be a valid IP address \(Ex: 1.2.3.4\) or "DHCP"     | 
  | Netmask                 |   Netmask used by the VM, in "IP Address" format \(Ex: 1.2.3.4\) or "DHCP"     | 
  | Gateway                 |   Gateway IP Address for this VM, or "DHCP"     | 
  | DNS Server               |   The DNS Server used for this VM, can be "DHCP"      | 
  | SSH Public Key File |  The path to an SSH Key file that the "license_cli" user will use to access this VM. Use the string "AUTO" and we will call 'ssh-keygen -b 1024 -t rsa -f id_rsa -P' and use the resulting file "id_rsa.pub" as the input to the generated VM. |
  | Bridge    | "AUTO" or any named bridge.  If "AUTO", use the default bridge of "virbr0", which is the standard default bridge name. If anything else, the name provided will be used \(Ex: br0\).  This is the bridge that the VM network interface will use.  |


## KENG Subscription levels
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

 

 

 




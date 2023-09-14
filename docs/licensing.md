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
    ./ixia_c_license_server_kvm_release.sh (VM Name) (IP Address) (Netmask) (Gateway) (DNS Server) (SSH Public Key File) (Bridge) 
    ```
    Installation parameters:
    | Parameters      | Description  | 
    |-----------------------------|-----------|
    | VM Name                   |   Name of this VM will be assigned     | 
    | IP Address|   IP Address assigned to this VM. Must be a valid IP address \(Ex: 1.2.3.4\) or "DHCP"     | 
    | Netmask                 |   Netmask used by the VM, in "IP Address" format \(Ex: 1.2.3.4\) or "DHCP"     | 
    | Gateway                 |   Gateway IP Address for this VM, or "DHCP"     | 
    | DNS Server               |   The DNS Server used for this VM, can be "DHCP"      | 
    | SSH Public Key File |  The path to an SSH Key file that the "license_cli" user will use to access this VM. Use the string "AUTO" and we will call 'ssh-keygen -b 1024 -t rsa -f id_rsa -P' and use the resulting file "id_rsa.pub" as the input to the generated VM. |
    | Bridge    | "AUTO" or any named bridge.  If "AUTO", use the default bridge of "virbr0", which is the standard default bridge name. If anything else, the name provided will be used \(Ex: br0\).  This is the bridge that the VM network interface will use.  |
2. Start license server service in the VM
    ```sh
    # ssh to license cli using SSH key
    ssh -i id_rsa license_cli@<license_server_ip_address>
    # To check all available Keysight License Server shell commands
    help
    # Start license server service
    start license-server
    ```
    Available Keysight License Server shell commands:
    | Commands      | Description  | 
    |-----------------------------|-----------|
    | show ip                   |   Shows the current IP address and netmask information for the management interface     | 
    | show licenses   | Shows the currently installed licenses  |
    | show dns-servers  | Show the DNS servers configured |
    | show license-server-status  | Shows the current status of the License Server (active or not active, etc)  |
    | show license-server-auto-start  | Shows the status of the "license-server-auto-start" flag  |
    | show dropbox  | Shows the files that are located in the "dropbox".  These are files that can be imported manually |
    | delete (filename) | Delete the file at "filename" from the "dropbox"  |
    | set ip <interface> <IP/"dhcp"> [<netmask>] [<gateway>] | Sets the current IP address, netmask and gateway address  |
    | set license-server-auto-start (on/off) | Change the status of the License Server, will it auto start at boot or not  |
    | add dns-server (serverIP) (index) | Add a new DNS server. At this time, the "index" option  must be "1" only, and the provided server will be set as the only DNS server.|
    | start license-server  | Starts the License Server on this system  |
    | stop license-server   | Stops the License Server on this system |
    | activate-license (Activation Code) (Quantity) | Adds the selected "Activation Code" of quantity "Quantity" to this License Server |
    | deactivate-license (Activation Code) (Quantity) | Removes the selected "Activation Code" of quantity "Quantity" from this License Server  |
    | offline-import (filename) | Import an offline file from the "dropbox".  See "show dropbox"  |
    | reboot (Seconds)  | Reboots the VM in (Seconds) seconds, which is an integer that is at least 10  |
    | shutdown (Seconds)  | Gracefully shuts down the VM in (Seconds) seconds, which is an integer that is at least 10  |
    | tILU [--offline]  | Starts the interactive Text Based License Utility (ILU) on this server.  Use the optional argument "--offline" to go straight into the Offline Operations screen. |
    
### Install/Uninstall license in license server VM
1. Get avtivation code from Keysight support.
2. SSH to license cli using SSH Key:
    ```sh
    ssh -i id_rsa license_cli@<license_server_ip_address>
    ```
3. Activate license using activation code:
    ```sh
    activate-license XXXX-XXXX-XXXX-XXXX 1
    ```
4. Deactivate license:
    ```sh
    deactivate-license XXXX-XXXX-XXXX-XXXX 1
    ```

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

 

 

 




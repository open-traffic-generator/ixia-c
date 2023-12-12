# Introduction

The UHD400T is a high performance, ultra-high density, and highly flexible software defined Tester, for all your next
generation testing needs. It works seamlessly with diverse testbeds like a single Device Under Test, or a network
with multiple devices.

The UHD400T comes as a 1U rack mount appliance with 16 400GE QSFP-DD ports that provide up to 6.4Tbps
composite throughput.

The UHD400T is configurable via the Keysight Elastic Network Generator. During the setup phase, the physical ports
on the UHD400T can be configured through a REST API.

![UHD](res/UHD400T_front_view.png "UHD400T front view")

## VLAN-Port Mapping

The UHD400T fabric is preconfigured to route the traffic between the trunk port (port 32) and the traffic ports (1-16).
Ports 17-31 are not available for use in the current release.
When the packets arrive at a traffic port, they are encapsulated in a VLAN corresponding to the front panel (see mapping table below) and routed to the trunk port. The process is reversed, when the packets arrive at the trunk port.

The packets that are encapsulated in a VLAN, are routed to the front panel port corresponding to the VLAN.
The trunk packets that are not VLAN-encapsulated or have a VLAN that is not listed in the following mapping table, will be dropped.

![UHD400T](res/system-with-UHD400T.drawio.svg "Example System with UHD400T")

### Mapping Table

| UHD Port | VLAN ID    | UHD Port   | VLAN ID    |
|:---      |:---        |:---        |:---        |
| 1        | 136        |   9        |   320      |
| 2        |  144       |   10       |    312     |
| 3        |  152       |   11       |   304      |
| 4        |   160      |   12       |   296      |
| 5        |   168      |   13       |   288      |
| 6        |  176       |  14        |   280      |
| 7        |   184      |   15       |   272      |
| 8        |    192     |   16       |   264      |

>Note:
The VLAN tagged interfaces can be created by using the following linux command:

```bash
ip link add link <interface-name> name <interface-name>.<vid> type vlan id <vid>
```
## REST API and Automation

For initial setup, a REST API is provided whereby port speeds and other settings can be configured and the link
state checked.

**https://<ip_or_hostname>/port/api/v1** is the base URL for the port APIs. This API is described by the
UHD400T Open API Schema

All of the REST APIs that accept parameters expect a JSON-formatted body. The above schema links describe the
format of the required JSON bodies for each supported API.
Here is a file with samples of the operations supported by the port api.
The traffic generation capabilities of the UHD400T must be configured using OTG format with KENG controller.
Please consult the OTG/KENG documentation for further information.


## System Administration
### KCOS shell
The software provides KCOS shell as a command line interface for system administration.
To access the KCOS shell connect with SSH using the IP address or hostname of the UHD400T unit. Enter the
following credentials:
  - Username: admin
  - Password: admin

The KCOS command line interface appears. You can now run the available CLI commands.
Type kcos help in order to list the available commands.

**Usage:**

  &nbsp; &nbsp; kcos [command]

**Available Commands:**

  &nbsp; &nbsp; date-time Date and Time <br />
  &nbsp; &nbsp; deployment Deployment actions <br />
  &nbsp; &nbsp; exit Exit from the interactive shell <br />
  &nbsp; &nbsp; help Help about any command <br /> 
  &nbsp; &nbsp; licensing Licensing administration <br />
  &nbsp; &nbsp; logs Logs and diagnostics <br />
  &nbsp; &nbsp; networking Networking control <br />
  &nbsp; &nbsp; shell An interactive shell <br />
  &nbsp; &nbsp; snapshot System snapshot operations <br />
  &nbsp; &nbsp; system System control <br />

**Flags:**

  &nbsp; &nbsp; -h, --help help for kcos <br />
  
Use `kcos [command] --help` for more information about a command.

**License activation**

The shell provides the following license related commands:

  &nbsp; &nbsp; **Licensing administration** <br/>
  &nbsp; &nbsp; **Usage:** <br />
  &nbsp; &nbsp; &nbsp; &nbsp; kcos licensing [command] <br/>
  &nbsp; &nbsp; **Available Commands:** <br />
  &nbsp; &nbsp; &nbsp; &nbsp; counted-feature-stats Get counted feature stats for licenses <br />
  &nbsp; &nbsp; &nbsp; &nbsp; hostid HostID of the license server <br />
  &nbsp; &nbsp; &nbsp; &nbsp; licenses Licenses <br />
  &nbsp; &nbsp; &nbsp; &nbsp; offline-license Offline license operation <br />
  &nbsp; &nbsp; &nbsp; &nbsp; offline-request Generate an offline request file <br />
  &nbsp; &nbsp; &nbsp; &nbsp; sync Synchronize the license server with KSM <br />
  &nbsp; &nbsp; **Flags:** <br />
  &nbsp; &nbsp; &nbsp; &nbsp; -h, --help help for licensing <br />
  &nbsp; &nbsp; Use `kcos licensing [command] --help` for more information about a command. <br />

  &nbsp; &nbsp; **Online License Activation** <br />
  &nbsp; &nbsp; &nbsp; &nbsp; If the unit where you wish to install the licenses has internet connectivity you can use the activation codes to enable
license as follows: <br />
  &nbsp; &nbsp; &nbsp; &nbsp; kcos licensing licenses activate -f AAAA-AAAA-AAAA-AAAA:1 <br />
  &nbsp; &nbsp; &nbsp; &nbsp; where AAAA-AAAA-AAAA-AAAA is the name of the license and 1 is the quantity (see kcos licensing licenses
--help for more options) <br />

  &nbsp; &nbsp; **Offline License Activation** <br />
  &nbsp; &nbsp; &nbsp; &nbsp; If the unit where you whish to install the licenses does not have internet connectivity follow the next steps: <br />
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1. Generate a license request <br />
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; kcos licensing offline-request generate <br />
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; which results in something like <br />
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Offline request: sftp://uhd400/home/admin/offlineReq-042938-200a32-bbd4a0-77f5_2022-01-28_19-03-47.bin <br />
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 2. Use a command like the following to copy the offline request file to your workstation: <br />
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; scp admin@uhd400:/home/admin/offlineReq-042938-200a32-bbd4a0-77f5_2022-01-28_19-03-47.bin . <br />
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Note that the filename will be different (i.e. the one that you obtained in the previous step). <br />
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3. Contact Keysight Sales or Support for help in obtaining a license binary from the offline request file. <br />
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 4. Copy the obtained license binary to the UHD400T where you generated the request. Note that importing this binary on a different setup will fail.<br />
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 5. Activate the license <br />
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; kcos licensing offline-license import <br />
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; which should generate a response similar to: <br />
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 042938-200a32-bbd4a0-77f5-2022-01-29-03-09.bin <br />
  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; License successfully installed. <br />

  &nbsp; &nbsp; **Viewing Licenses and Feature Counts used** <br />
  &nbsp; &nbsp; SSH into the KCOS shell on your UHD400T as described above, and use the commands below to view the license
information: <br />

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

![UHD400T](res/system_with_UHD400T.svg "Example System with UHD400T")

**Mapping Table**

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
The VLAN tagged interfaces can be created using the following linux command:

```bash
ip link add link <interface-name> name <interface-name>.<vid> type vlan id <vid>
```

## REST API and Automation

For the initial setup, a REST API is provided, by which the port speeds and the other settings can be configured and the link
state can be checked.

* [https://<ip_or_hostname>/port/api/v1](https://<ip_or_hostname>/port/api/v1) is the base URL for the port APIs. This API is described by the UHD400T Open API Schema.

All the REST APIs that accept parameters, expect a JSON-formatted body. The above schema links describe the
format of the required JSON bodies for each of the supported API.
Here is a file with samples of the operations supported by the port api.
The traffic generation capabilities of the UHD400T must be configured by using the OTG format with the KENG controller.
For more information, see OTG/KENG documentation.

### System Administration

### KCOS shell

The software provides KCOS shell as a command line interface for system administration.
To access the KCOS shell, do the following:

* Connect with SSH by using the IP address or the hostname of the UHD400T unit
* Enter the following credentials:
    * Username: admin
    * Password: admin

The KCOS command line interface appears. You can now run the available CLI commands.

Type `kcos help` in order to list the available commands.

Usage:

`kcos` [command]

Available Commands:

|Command       | Description                      |
|:---          |:---                              |
| `date-time`  | Date and Time                    |
|  `deployment`| Deployment actions               |
|  `exit`      | Exit from the interactive shell  |
|  `help`      | Help about any command           |
|  `licensing` | Licensing administration         |
|  `logs`      | Logs and diagnostics             |
|  `networking`| Networking control               |
|  `shell`     | An interactive shell             |
|  `snapshot`  | System snapshot operations       |
|  `system`    | System control                   |

Flags: `-h, --help`.  Description: help for kcos.

For more information about a command, use `kcos [command] --help`.

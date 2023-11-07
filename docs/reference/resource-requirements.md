# Resource requirement

The minimum memory and cpu requirements for each Ixia-c components are captured in the following table. Kubernetes metrics server has been used to collect the resource usage data.

The memory represents the minimum working set of memory required. For protocol and traffic engines, it varies depending on the number of co-located ports. For example, multiple ports are added to a 'group' for LAG use-cases, when a single test container has more than one test NIC connected to the DUT. The figures are in Mi or MB per container and do not include shared or cached memory across multiple containers/pods in a system.

| Component        |1 Port (Default)| 2 Port  | 4 Port  | 6 Port  |8 Port|
|:---              |:---            |:---     |:---     |:---     |:---  |
| Protocol Engine  | 350            |  420    | 440     |  460    | 480  |
|  Traffic Engine  | 60             | 70      |  90     | 110     | 130  |
|  Controller      |   25*          |         |         |         |      |
|  gNMI            | 15*            |         |         |         |      |

>Note: Controller and gNMI have a fixed minimum memory requirement and is currently not dependent on number of test ports for the topology.

The cpu resource figures are in millicores.

|         |Protocol | Traffic Engine | Controller Engine | gNMI  |
| :---    | :---    | :---           | :---              | :---  |
| Min CPU |   200   |   200          |     10            |   10  |

## Minimum and maximum resource usage based on various test configurations

Depending on the nature of the test run, the memory and cpu resource requirements may vary across all Ixia-c components. The following table captures the memory usage for LAG scenarios with varying numbers of member ports. The minimum value represents the initial memory on topology deployment and the maximum value indicates the peak memory usage during the test run. The values are in Mi or MB.

| Component     | Min/Max    | 1 Port   | 2 Port   | 4 Port   | 6 Port   | 8 Port   |
|:---           |:---        |:---	    |:---      |:---	  |:---	     |:---	    |
|Protocol Engine| Max<br>Min |348<br>323|423<br>360|455<br>360|464<br>360|492<br>360|
|Traffic Engine | Max<br>Min |58<br>47  | 68 <br>49| 90 <br>49|111<br>49 |134<br>49 |
| Controller    | Max<br>Min |21<br>13  | 21<br>13 | 23<br>13 | 24<br>13 |25<br>13  |
|   gNMI        | Max<br>Min |14<br>7   | 14<br>7  | 14<br>7  | 14<br>7  | 14<br>7  |

Following is the memory usage variation with scaling in the control plane. The variation is on the number of BGP sessions (1K, 5K, and 10K), in a back to back setup. The values are in Mi or MB.

| Component      | Min/Max    |   1K     |   5K     |  10K      |
| :----------    | :-------   | :------  | :------  | :-----    |
| Protocol Engine| Max<br>Min |516<br>323|906<br>323|1367<br>323|
| Controller     | Max<br>Min |53<br>12  |149<br>12 |259<br>12  |
| gNMI           | Max<br>Min | 7<br>7   | 7<br>7   |  7<br>7   |

Following is the memory usage variation with scaling in data plane. The variation is on the number of MPLS flows (10, 1K, and 4K), in a back to back setup with labels provided by the RSVP-TE control plane. The values are in Mi or MB.

| Component      | Min/Max    |   10   |   1K   |   4K    |
| :----------    | :-------   | :------| :------| :------ |
| Traffic Engine | Max<br>Min |58<br>47|59<br>47|95<br>47 |
|  Controller    | Max<br>Min |18<br>12|46<br>12|120<br>12|
|  gNMI          | Max<br>Min |10<br>7 |17<br>7 |28<br>7  |

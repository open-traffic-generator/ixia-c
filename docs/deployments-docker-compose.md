# Deploy Ixia-c using docker-compose

Deploying multiple services manually (along with the required parameters) is not always applicable in some scenarios. For convenience, the [deployments](../deployments) directory consists of the following `docker-compose` files:

- `*.yml`: Describes the services for a given scenario and the deployment parameters that are required to start them.
- `.env`: Holds the default parameters, that are used across all `*.yml` files. For example, the name of the interface, the version of docker images, and etc.

If a concerned `.yml` file does not include certain variables from `.env`, those can then safely be ignored.  
Follwoing is the example of a usual workflow, by using  `docker-compose`.

```sh
# change default parameters if needed; e.g. interface name, image version, etc.
vi deployments/.env
# deploy and start services for community users
docker-compose -f deployments/<scenario>.yml up -d
# stop and remove services deployed
docker-compose -f deployments/<scenario>.yml down
```

On most of the systems, `docker-compose` needs to be installed separately even if the docker is already installed. For more information, see [docker prerequisites](prerequisites.md#docker) .

>All the scenarios that are mentioned in the following sections, describe both manual and automated (requiring docker-compose) steps.

## Deployment Parameters

### Controller

  | Controller Parameters       | Optional  | Default                 | Description                                                     |
  |-----------------------------|-----------|-------------------------|-----------------------------------------------------------------|
  | --debug                     |   Yes     | false                   | Enables high volume logs with debug info for better diagnostics.|
  | --disable-app-usage-reporter|   Yes     | false                   | Disables sending of usage data to the app-usage-reporter.              |
  | --http-port                 |   Yes     | 8443                     | TCP port for HTTP server.                                       |
  | --aur-host                  |   Yes     | https://localhost:5600  | Overrides the location of the app-usage-reporter.                       |
  | --accept-eula               |   No      | NA                      | Indicates that the user has accepted EULA, otherwise the controller will not boot up. |
  | --license-servers           |   No      | NA                      | Indicates the ip address of license servers for commercial users. |

  Docker Parameters:

- `--net=host`: It is recommended to allow the use of the host network stack, in order to address the traffic-engine containers using `localhost` instead of `container-ip`, when deployed on the same host.
- `-d`: This starts the container in background.

  Example:

  ```bash
  # For community users
  docker run --net=host -d ghcr.io/open-traffic-generator/keng-controller --accept-eula --debug --http-port 5050

  # For commercial users
  docker run --net=host -d ghcr.io/open-traffic-generator/keng-controller --accept-eula --debug --http-port 5050 --license-servers="ip/hostname of license server"
  ```

### Traffic Engine

  | Environment Variables       | Optional  | Default                 | Description                                                     |
  |-----------------------------|-----------|-------------------------|-----------------------------------------------------------------|
  | ARG_IFACE_LIST              |   No      | NA                      | Name of the network interface to bind to. It must be visible to the traffic-engine's network namespace. For example, `virtual@af_packet,eth1` where `eth1` is the interface name and `virtual@af_packet` indicates that the interface is managed by the host kernel's network stack.|
  | OPT_LISTEN_PORT             |   Yes     | "5555"                  | TCP port on which the controller can establish connection with the traffic-engine.|
  | OPT_NO_HUGEPAGES            |   Yes     | "No"                    | If set to `Yes`, it disables hugepages in the OS. The hugepages needs to be disabled when the network interfaces are managed by the host kernel's stack.|

  Docker Parameters:

- `--net=host`: This is required if the traffic-engine needs to bind to a network interface that is visible in the host network stack but not inside the docker's network.
- `--privileged`: This is required because the traffic-engine needs to exercise capabilities that require elevated privileges.
- `--cpuset-cpus`: The traffic-engine usually requires 1 shared CPU core for management activities and 2 exclusive CPU cores, each for the transmit engine and receive engine. The shared CPU core can be shared across multiple traffic-engines. For example, `--cpuset-cpus="0,1,2"` which indicates that cpu0 is shared, cpu1 is used for transmit and cpu2 is used for receive. If CPU cores are not specified, any arbitrary CPU cores will be chosen.
    > If enough CPU cores are not provided, the available CPU cores may be shared among management, transmit, and the receive engines, that can occasionally result in lower performance.
- `-d`: This starts the container in background.

  Example:

  ```bash
  docker run --net=host --privileged -d         \
    -e OPT_LISTEN_PORT="5555"                   \
    -e ARG_IFACE_LIST="virtual@af_packet,eth1"  \
    -e OPT_NO_HUGEPAGES="Yes"                   \
    --cpuset-cpus="0,1,2"                       \
    ghcr.io/open-traffic-generator/ixia-c-traffic-engine
  ```

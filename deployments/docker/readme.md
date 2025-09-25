# Ixia-C Docker Deployment over Raw Socket

## Manual Steps

1. (Optional) Cleanup all existing containers and images.

   ```sh
   docker stop $(docker ps -aq) && docker rm $(docker ps -aq)
   docker rmi $(docker images -q)
   ```

2. Start an instance of `controller`.

   ```sh
        # implicitly listens on TCP port 8443 and 40051
        # --accept-eula option is confirmation that user has accepted the Ixia-C End-User License Agreement (EULA) 
        # located at https://github.com/open-traffic-generator/ixia-c/blob/main/docs/eula.md
        docker run -d                                        \
            --name=keng-controller                              \
            --publish 0.0.0.0:8443:8443                         \
            --publish 0.0.0.0:40051:40051                       \
            ghcr.io/open-traffic-generator/keng-controller:1.40.0-1                              \
            --accept-eula                                       \
            --trace                                             \
            --disable-app-usage-reporter
   ```


3. Start one or more instances of `traffic-engine`.

   - For `traffic-engine` over raw socket:

     ```sh
        # for network interface eth1
        docker run --privileged -d                           \
            --name=ixia-c-traffic-engine-eth1              \
            -e OPT_LISTEN_PORT="5555"                           \
            -e ARG_IFACE_LIST="virtual@af_packet,eth1"     \
            -e OPT_NO_HUGEPAGES="Yes"                           \
            -e OPT_NO_PINNING="Yes"                             \
            -e WAIT_FOR_IFACE="Yes"                             \
            -e OPT_ADAPTIVE_CPU_USAGE="Yes"                              \
            ghcr.io/open-traffic-generator/ixia-c-traffic-engine:1.8.0.245             

        # for network interface eth2
        docker run --privileged -d                           \
            --name=ixia-c-traffic-engine-eth2              \
            -e OPT_LISTEN_PORT="5555"                           \
            -e ARG_IFACE_LIST="virtual@af_packet,eth2"     \
            -e OPT_NO_HUGEPAGES="Yes"                           \
            -e OPT_NO_PINNING="Yes"                             \
            -e WAIT_FOR_IFACE="Yes"                             \
            -e OPT_ADAPTIVE_CPU_USAGE="Yes"                              \
            ghcr.io/open-traffic-generator/ixia-c-traffic-engine:1.8.0.245
     ```

4. Start one or more instances of `protocol-engine`.

   - For `protocol-engine` over raw socket:

     ```sh
        # for network interface eth1
        docker run --privileged -d                           \
            --net=container:ixia-c-traffic-engine-eth1     \
            --name=ixia-c-protocol-engine-eth1            \
            -e INTF_LIST="eth1"                            \
            ghcr.io/open-traffic-generator/ixia-c-protocol-engine:1.00.0.482                       \

        # for network interface eth2
        docker run --privileged -d                           \
            --net=container:ixia-c-traffic-engine-eth2     \
            --name=ixia-c-protocol-engine-eth2            \
            -e INTF_LIST="eth2"                            \
            ghcr.io/open-traffic-generator/ixia-c-protocol-engine:1.00.0.482  
     ```

5. Ensure existing network interfaces are `Up` and have `Promiscuous` mode enabled.

   ```sh
        # check interface details
        sudo ip addr
        # configure as required
        sudo ip link set eth1 up
        sudo ip link set eth1 promisc on
        sudo ip link set eth2 up
        sudo ip link set eth2 promisc on
   ```

6. Push interface to the containers.
    - It takes a host NIC (say eth1) and injects it into a container’s network namespace so the container can directly use that NIC (bypassing Docker’s default bridge). 
    It symlinks the container’s netns into /var/run/netns, then moves and configures the interface inside that namespace.

    ```sh

        # For Traffic Engine 1
        # Resolve container metadata
        cid=$(docker inspect --format="{{json .Id}}" ixia-c-traffic-engine-eth1 | cut -d\" -f 2)
        cpid=$(docker inspect --format="{{json .State.Pid}}" ixia-c-traffic-engine-eth1 | cut -d\" -f 2)

        # Prepare namespace paths
        orgPath=/proc/${cpid}/ns/net
        newPath=/var/run/netns/${cid}
        
        # Make namespace accessible to ip netns 
        sudo mkdir -p /var/run/netns
        sudo ln -s ${orgPath} ${newPath}
        # Move interface into the container’s netns
        sudo ip link set eth1 netns ${cid}  
        # Rename and configure inside the container           
        sudo ip netns exec ${cid} ip link set eth1 name eth1  
        sudo ip netns exec ${cid} ip -4 addr add 0/0 dev eth1
        sudo ip netns exec ${cid} ip -4 link set eth1 up 

        # For Traffic Engine 2
        # Resolve container metadata
        cid=$(docker inspect --format="{{json .Id}}" ixia-c-traffic-engine-eth2 | cut -d\" -f 2)
        cpid=$(docker inspect --format="{{json .State.Pid}}" ixia-c-traffic-engine-eth2 | cut -d\" -f 2)

        # Prepare namespace paths
        orgPath=/proc/${cpid}/ns/net
        newPath=/var/run/netns/${cid}
        
        # Make namespace accessible to ip netns 
        sudo mkdir -p /var/run/netns
        sudo ln -s ${orgPath} ${newPath}
        # Move interface into the container’s netns
        sudo ip link set eth2 netns ${cid}  
        # Rename and configure inside the container           
        sudo ip netns exec ${cid} ip link set eth2 name eth2  
        sudo ip netns exec ${cid} ip -4 addr add 0/0 dev eth2
        sudo ip netns exec ${cid} ip -4 link set eth2 up 
    ```

6. Create interface-port config-map inside `keng-controller`.
    ```sh
        configDir=/home/ixia-c/controller/config
        OTG_PORTA=$(docker inspect --format="{{json .NetworkSettings.IPAddress}}" ixia-c-traffic-engine-eth1 | cut -d\" -f 2)
        OTG_PORTZ=$(docker inspect --format="{{json .NetworkSettings.IPAddress}}" ixia-c-traffic-engine-eth2 | cut -d\" -f 2)
        
        yml="location_map:
            - location: ${ETH_A}
                endpoint: \"${OTG_PORTA}:5555+${OTG_PORTA}:50071\"
            - location: ${ETH_Z}
                endpoint: \"${OTG_PORTZ}:5555+${OTG_PORTZ}:50071\"
            "
        echo -n "$yml" | sed "s/^        //g" | tee ./config.yaml > /dev/null \
        && docker exec keng-controller mkdir -p ${configDir} \
        && docker cp ./config.yaml keng-controller:${configDir}/ \
        && rm -rf ./config.yaml
    ```

## Automated Steps
```sh
    git clone --recurse-submodule https://github.com/open-traffic-generator/ixia-c.git
    cd ixia-c/deployments/docker
    chmod u+x ./deployment.sh

    # deploy
    ./deployment.sh eth1 eth2 topo new

    # teardown
    ./deployment.sh eth1 eth2 topo rm
```


## Sample go snippet to use after deployment for testing
    ```go
        // Create a new API handle to make API calls against OTG
        api := gosnappi.NewApi()

        // Set the transport protocol to HTTP
        api.NewHttpTransport().SetLocation("https://localhost:8443")

        // Create a new traffic configuration that will be set on OTG
        config := gosnappi.NewConfig()

        // Add a test port to the configuration
        ptx := config.Ports().Add().SetName("ptx").SetLocation("eth1")
        prx := config.Ports().Add().SetName("prx").SetLocation("eth2")
    ```







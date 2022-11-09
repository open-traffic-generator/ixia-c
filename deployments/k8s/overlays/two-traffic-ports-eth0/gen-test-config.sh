#!/bin/sh

TEST_CONFIG_PATH=test-config.yaml
if [ ! -z ${1} ]
then
    TEST_CONFIG_PATH=${1}
fi

gen_test_const() {
    # get pod IPs to be used as source and destination IP in packets
    txIp=$(kubectl get pod -n ixia-c otg-port1 -o 'jsonpath={.status.podIP}')
    rxIp=$(kubectl get pod -n ixia-c otg-port2 -o 'jsonpath={.status.podIP}')
    # send ping to flood arp table and extract gateway MAC
    kubectl exec -n ixia-c otg-port1 -c ixia-c-traffic-engine -- ping -c 1 ${rxIp}
    gatewayMac=$(kubectl exec -n ixia-c otg-port1 -c ixia-c-traffic-engine -- arp -a | head -n 1 | cut -d\  -f4)
    txMac=$(kubectl exec -n ixia-c otg-port1 -c ixia-c-traffic-engine -- ifconfig eth0 | grep ether | sed 's/  */_/g' | cut -d_ -f3)
    rxMac=$(kubectl exec -n ixia-c otg-port2 -c ixia-c-traffic-engine -- ifconfig eth0 | grep ether | sed 's/  */_/g' | cut -d_ -f3)

    yml="otg_test_const:
            txMac: ${txMac}
            rxMac: ${rxMac}
            gatewayMac: ${gatewayMac}
            txIp: ${txIp}
            rxIp: ${rxIp}
        "
    echo -n "$yml" | sed "s/^          //g" | tee -a ${TEST_CONFIG_PATH} > /dev/null
}

gen_config_common() {
    yml="otg_speed: speed_1_gbps
        otg_capture_check: true
        otg_iterations: 100
        otg_grpc_transport: false
        "
    echo -n "$yml" | sed "s/^        //g" | tee -a ${TEST_CONFIG_PATH} > /dev/null
}

gen_test_config() {
    yml="otg_host: https://localhost:443
        otg_ports:
          - port1
          - port2
        "
    echo -n "$yml" | sed "s/^        //g" | tee ${TEST_CONFIG_PATH} > /dev/null

    gen_config_common

    gen_test_const
}

gen_test_config
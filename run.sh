#!/bin/bash

if [[ "$LB_HOST" == "" ]]; then
    echo Variable LB_HOST is undefined.
    exit 1
fi

if [ ! -z "$ZK" ]; then
    echo "run.sh: is using zookeeper: ${ZK}"

    docker run -d --name haproxy --rm -p 81:80 -e ZK=${ZK} -e LB_HOST=$LB_HOST -e HAPROXY_STATS=1 zwotzie/easy-lb-haproxy

else
    echo "run.sh: is using ETCD: ${ETCD}"

    if [[ "$ETCD" == "" ]]; then
        echo Variable ETCD is undefined.
        echo "looks like: http://<ip>:2379 for single node"
        echo "or comma separated for multi hosts"
        echo "export ETCD=http://xxx:2379"
        exit 1
    fi

    docker run --name haproxy --rm -p 81:80 -e ETCD_PEERS=${ETCD} -e HAPROXY_STATS=1 zwotzie/easy-lb-haproxy

fi
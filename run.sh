#!/bin/bash

if [[ "$ETCD" == "" ]]; then
    echo Variable ETCD is undefined.
    echo "looks like: http://<ip>:2379 for single node"
    echo "or comma separated for multi hosts"
    echo "export ETCD=http://xxx:2379"
    exit 1
fi

docker run --name haproxy zwotzie/easy-lb-haproxy --rm -p 81:80 -e ETCD_PEERS=$ETCD -e HAPROXY_STATS=1

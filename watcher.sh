#!/bin/sh

if [ ! -z "$ZK" ]; then
    echo "watcher.sh: is using zookeeper: ${ZK}"

    # attempt to generate a first configuration
    while [ true ]; do
        echo renerating config first time...
        ./confd -onetime -backend zookeeper -node ${ZK} -config-file /etc/confd/conf.d/haproxy.toml
        if [ "$?" != "0" ]; then
            echo "watcher.sh: confd cannot generate initial configuration, retrying in 10 sec..."
            sleep 5
        else
            break
        fi
    done

    # start the watch cycle
    while [ true ]; do
        ./confd -interval 10 -backend zookeeper -node ${ZK} -config-file /etc/confd/conf.d/haproxy.toml
        echo "watcher.sh: confd exited, restarting."
    done

else
    echo "watcher.sh: is using etcd: ${ETCD_PEERS}"

    # make sure the /services key is set in etcd before we start
    for ETCD_URL in ${ETCD_PEERS//,/ }; do
        curl -s -f $ETCD_URL/v2/keys/services -XPUT -d dir=true
        if [ "$?" = "0" ]; then
            break
        fi
    done

    # attempt to generate a first configuration
    ETCD_NODES="-node ${ETCD_PEERS//,/ -node }"
    while [ true ]; do
        ./confd -onetime $ETCD_NODES -config-file /etc/confd/conf.d/haproxy.toml
        if [ "$?" != "0" ]; then
            echo "watcher.sh: confd cannot generate initial configuration, retrying in 10 sec..."
            sleep 10
        else
            break
        fi
    done
fi

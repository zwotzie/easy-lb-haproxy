#!/bin/sh

# start configuration watcher in the background
./watcher.sh &

# start syslog daemon
syslogd

# wait until there is a configuration available
while [ ! -f /usr/local/etc/haproxy/haproxy.cfg ]; do
    echo "boot.sh: ... waiting 1s until /usr/local/etc/haproxy/haproxy.cfg exists"
    sleep 1
done

exec /docker-entrypoint.sh haproxy -f /usr/local/etc/haproxy/haproxy.cfg

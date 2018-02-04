#!/bin/bash
# build a docker image for this service

pushd $(dirname ${BASH_SOURCE[0]})
export SERVICE=$(basename $PWD)

# confd releases: https://github.com/kelseyhightower/confd/releases
[ -e confd ] && rm confd
wget https://github.com/kelseyhightower/confd/releases/download/v0.15.0/confd-0.15.0-linux-amd64
mv confd-0.15.0-linux-amd64 confd

docker build -t zwotzie/easy-lb-haproxy .

popd
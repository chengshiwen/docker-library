#!/bin/sh

for influxdb in $(env | grep "^INFLUXDB_"); do
    name=$(echo $influxdb | cut -d= -f1)
    addr=$(echo $influxdb | cut -d= -f2)
    sed -i "/127.0.0.1:7086/a\    { name=\"${name#INFLUXDB_}\", location=\"http://$addr/write\", timeout=\"10s\" }," /etc/relay.toml
    # sed -i "/127.0.0.1:7089/a\    { name=\"${name#INFLUXDB_}\", location=\"${addr%:*}:8089\", mtu=512 }," /etc/relay.toml
done

sed -i "/127.0.0.1:[78]08[69]/d" /etc/relay.toml

exec "$@"

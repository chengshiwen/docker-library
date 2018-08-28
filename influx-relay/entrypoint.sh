#!/bin/sh

RELAY_HTTP_TIMEOUT=${RELAY_HTTP_TIMEOUT:-10s}
RELAY_BUFFER_SIZE_MB=${RELAY_BUFFER_SIZE_MB:-256}
RELAY_MAX_BATCH_KB=${RELAY_MAX_BATCH_KB:-512}
RELAY_MAX_DELAY_INTERVAL=${RELAY_MAX_DELAY_INTERVAL:-10s}

for influxdb in $(env | grep "^INFLUXDB_"); do
    name=$(echo $influxdb | cut -d= -f1)
    addr=$(echo $influxdb | cut -d= -f2)
    sed -i "/127.0.0.1:7086/a\    { name=\"${name#INFLUXDB_}\", location=\"http://$addr/write\", timeout=\"${RELAY_HTTP_TIMEOUT}\", buffer-size-mb=${RELAY_BUFFER_SIZE_MB}, max-batch-kb=${RELAY_MAX_BATCH_KB}, max-delay-interval=\"${RELAY_MAX_DELAY_INTERVAL}\" }," /etc/relay.toml
    # sed -i "/127.0.0.1:7089/a\    { name=\"${name#INFLUXDB_}\", location=\"${addr%:*}:8089\", mtu=512 }," /etc/relay.toml
done

sed -i "/127.0.0.1:[78]08[69]/d" /etc/relay.toml

exec "$@"

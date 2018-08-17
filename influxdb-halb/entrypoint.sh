#!/bin/sh

if [[ "${1#-}" != "$1" ]]; then
    set -- nginx -g 'daemon off;' "$@"
fi

for influxdb in $(env | grep "^INFLUXDB_"); do
    addr=$(echo $influxdb | cut -d= -f2)
    sed -i "/upstream influxdb/a\    server $addr;" /etc/nginx/conf.d/default.conf
done

for relay in $(env | grep "^RELAY_"); do
    addr=$(echo $relay | cut -d= -f2)
    sed -i "/upstream relay/a\    server $addr;" /etc/nginx/conf.d/default.conf
done

exec "$@"

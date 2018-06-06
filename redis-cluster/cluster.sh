#!/bin/bash

IP=127.0.0.1
PORT=7001
NODES=6
REPLICAS=1
TIMEOUT=5000
ENDPORT=$((PORT+NODES-1))

if [ "$1" == "start" ]; then
    if [ "$IP" == "127.0.0.1" ] || [ "$IP" == "localhost" ]; then
        echo "Public IP required"
        exit 1
    fi
    for port in $(seq $PORT $ENDPORT); do
        echo "Starting redis-$port"
        docker run \
            -d \
            --name redis-$port \
            --restart unless-stopped \
            -p $port:6379 \
            -p 1$port:16379 \
            redis-cluster \
            redis-server \
            --appendonly yes \
            --cluster-enabled yes \
            --cluster-config-file nodes.conf \
            --cluster-node-timeout $TIMEOUT \
            --cluster-announce-ip $IP \
            --cluster-announce-port $port \
            --cluster-announce-bus-port 1$port \
            --stop-writes-on-bgsave-error no
    done
    exit 0
fi

if [ "$1" == "create" ]; then
    HOSTS=""
    for port in $(seq $PORT $ENDPORT); do
        HOSTS="$HOSTS $IP:$port"
    done
    docker exec -i redis-$PORT redis-trib.rb create --replicas $REPLICAS $HOSTS
    exit 0
fi

if [ "$1" == "stop" ]; then
    for port in $(seq $PORT $ENDPORT); do
        echo "Stopping: $(docker stop redis-$port)"
    done
    exit 0
fi

if [ "$1" == "remove" ]; then
    for port in $(seq $PORT $ENDPORT); do
        echo "Removing: $(docker rm -f redis-$port)"
    done
    exit 0
fi

if [ "$1" == "info" ]; then
    docker exec -i redis-$PORT redis-cli -c -h $IP -p $PORT cluster info
    docker exec -i redis-$PORT redis-trib.rb info $IP:$PORT
    exit 0
fi

if [ "$1" == "nodes" ]; then
    docker exec -i redis-$PORT redis-cli -c -h $IP -p $PORT cluster nodes
    exit 0
fi

if [ "$1" == "check" ]; then
    docker exec -i redis-$PORT redis-trib.rb check $IP:$PORT
    exit 0
fi

if [ "$1" == "ping" ]; then
    for port in $(seq $PORT $ENDPORT); do
        echo "ping $IP:$port: $(docker exec -i redis-$PORT redis-cli -c -h $IP -p $port ping)"
    done
    exit 0
fi

echo "Usage: $0 [start|create|stop|remove|info|nodes|ping]"
echo "start       -- Launch redis cluster instances."
echo "create      -- Create a cluster using redis-trib create."
echo "stop        -- Stop redis cluster instances."
echo "remove      -- Remove redis cluster instances."
echo "info        -- Show CLUSTER INFO output of first node."
echo "nodes       -- Show CLUSTER NODES output of first node."
echo "check       -- Show redis-trib.rb check output of first node."
echo "ping        -- Ping all nodes from first node."

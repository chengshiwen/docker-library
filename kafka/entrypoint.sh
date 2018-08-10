#!/bin/bash

KAFKA_ZK_DIR=${KAFKA_ZK_DIR:-/data/zookeeper}
KAFKA_LOG_DIR=${KAFKA_LOG_DIR:-/data/kafka}
KAFKA_NUM_PARTITIONS=${KAFKA_NUM_PARTITIONS:-1}
KAFKA_AD_HOST=${KAFKA_AD_HOST:-localhost}
KAFKA_AD_PORT=${KAFKA_AD_PORT:-9092}

mkdir -p ${KAFKA_ZK_DIR} ${KAFKA_LOG_DIR}

sed -i "s#dataDir=.*#dataDir=${KAFKA_ZK_DIR}#" ${KAFKA_HOME}/config/zookeeper.properties
sed -i "s#log.dirs=.*#log.dirs=${KAFKA_LOG_DIR}#" ${KAFKA_HOME}/config/server.properties
sed -i "s#num.partitions=.*#num.partitions=${KAFKA_NUM_PARTITIONS}#" ${KAFKA_HOME}/config/server.properties
sed -i "/advertised.listeners=PLAINTEXT/a\advertised.listeners=PLAINTEXT://${KAFKA_AD_HOST}:${KAFKA_AD_PORT}" ${KAFKA_HOME}/config/server.properties

supervisord -n $@

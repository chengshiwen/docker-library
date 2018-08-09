#!/bin/bash

KAFKA_ZK_DIR=${KAFKA_ZK_DIR:-/data/zookeeper}
KAFKA_LOG_DIR=${KAFKA_LOG_DIR:-/data/kafka}

mkdir -p ${KAFKA_ZK_DIR} ${KAFKA_LOG_DIR}

sed -i "s#dataDir=.*#dataDir=${KAFKA_ZK_DIR}#" ${KAFKA_HOME}/config/zookeeper.properties
sed -i "s#log.dirs=.*#log.dirs=${KAFKA_LOG_DIR}#" ${KAFKA_HOME}/config/server.properties

supervisord -n $@

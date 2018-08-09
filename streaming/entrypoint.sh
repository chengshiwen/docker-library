#!/bin/bash

sed_key_value() {
    if [[ -n "$2" ]]; then
        sed -i "s#$1=.*#$1=$2#" /usr/local/bin/streaming.sh
    fi
}

sed_key_value HADOOP_HDFS_HOME ${HADOOP_HDFS_HOME}
sed_key_value HADOOP_YARN_HOME ${HADOOP_YARN_HOME}
sed_key_value HADOOP_CONF_DIR ${HADOOP_CONF_DIR}
sed_key_value HADOOP_USER_NAME ${HADOOP_USER_NAME}

sed_key_value SPARK_HOME ${SPARK_HOME}
sed_key_value DRIVER_MEMORY ${DRIVER_MEMORY}
sed_key_value DRIVER_CORES ${DRIVER_CORES}
sed_key_value NUM_EXECUTORS ${NUM_EXECUTORS}
sed_key_value EXECUTOR_MEMORY ${EXECUTOR_MEMORY}
sed_key_value EXECUTOR_CORES ${EXECUTOR_CORES}
sed_key_value YARN_QUEUE ${YARN_QUEUE}
sed_key_value HDFS_DEFAULTFS ${HDFS_DEFAULTFS}
sed_key_value HDFS_ANOMALY_JAR_PATH ${HDFS_ANOMALY_JAR_PATH}
sed_key_value HDFS_ANOMALY_CONF_PATH ${HDFS_ANOMALY_CONF_PATH}

cron -f $@

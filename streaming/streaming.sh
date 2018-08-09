#!/bin/bash

RETRY_NUMBER=10
STUCK_PATH=/tmp/stuck.log
LOG_PATH=/tmp/streaming.log

export JAVA_HOME=/usr/java/latest
export HADOOP_HDFS_HOME=/aiops/opt/hadoop-2.7.6
export HADOOP_YARN_HOME=/aiops/opt/hadoop-2.7.6
export HADOOP_CONF_DIR=/aiops/opt/hadoop-2.7.6/etc/hadoop
export HADOOP_USER_NAME=aiops

SPARK_HOME=/aiops/opt/spark-2.2.2-bin-hadoop2.7
DRIVER_MEMORY=1G
DRIVER_CORES=1
NUM_EXECUTORS=1
EXECUTOR_MEMORY=1G
EXECUTOR_CORES=1
YARN_QUEUE=default
HDFS_DEFAULTFS=localhost:9000
HDFS_ANOMALY_JAR_PATH=/user/aiops/anomaly/core/anomaly.jar
HDFS_ANOMALY_CONF_PATH=/user/aiops/anomaly/core/anomaly.properties

STREAMING_STATE=$(${HADOOP_YARN_HOME}/bin/yarn application -list -appStates SUBMITTED,ACCEPTED,RUNNING | grep "AIOps-Anomaly-Streaming")
STREAMING_RUNNING=$(echo "${STREAMING_STATE}" | grep RUNNING)
APPLICATION_ID=$(echo "${STREAMING_STATE}" | grep -E "SUBMITTED|ACCEPTED|RUNNING" | awk '{print $1}')

submit_streaming() {
    nohup ${SPARK_HOME}/bin/spark-submit \
        --class com.bizseer.anomaly.entry.CLI \
        --master yarn \
        --deploy-mode cluster \
        --driver-memory ${DRIVER_MEMORY} \
        --driver-cores ${DRIVER_CORES} \
        --num-executors ${NUM_EXECUTORS} \
        --executor-memory ${EXECUTOR_MEMORY} \
        --executor-cores ${EXECUTOR_CORES} \
        --queue ${YARN_QUEUE} \
        --name "AIOps-Anomaly-Streaming" \
        hdfs://${HDFS_DEFAULTFS}${HDFS_ANOMALY_JAR_PATH} stream \
        -c hdfs://${HDFS_DEFAULTFS}${HDFS_ANOMALY_CONF_PATH} &> /dev/null &
    echo "0" > ${STUCK_PATH}
    echo "$(date): submit new application, reset count to 0" > ${LOG_PATH}
}

kill_streaming() {
    for app_id in ${APPLICATION_ID}; do
        $HADOOP_YARN_HOME/bin/yarn application -kill ${app_id}
    done
}

if [[ "$1" == "stop" ]] && [[ -n ${APPLICATION_ID} ]]; then
    kill_streaming
    exit 1
fi

if [[ -z ${STREAMING_STATE} ]]; then
    submit_streaming
elif [[ -z ${STREAMING_RUNNING} ]]; then
    if [[ -e ${STUCK_PATH} ]]; then
        STUCK_COUNT=$(head -1 ${STUCK_PATH})
        STUCK_COUNT=$(expr ${STUCK_COUNT} + 1)
        echo "${STUCK_COUNT}" > ${STUCK_PATH}
        echo "$(date): application ${APPLICATION_ID} is not RUNNING, add count to ${STUCK_COUNT}" >> ${LOG_PATH}

        if [[ ${STUCK_COUNT} -gt ${RETRY_NUMBER} ]]; then
            kill_streaming
            echo "$(date): kill retry-failed application ${APPLICATION_ID}" >> ${LOG_PATH}
            submit_streaming
        fi
    else
        echo "1" > ${STUCK_PATH}
    fi
fi

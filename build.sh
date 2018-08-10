#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Usage: $0 <library>"
    exit 1
fi

LIBRARY=${1%%/*}
BUILD_DIR=$(dirname $0)/${LIBRARY}

if [[ ! -d ${BUILD_DIR} ]]; then
    echo "library ${LIBRARY} not exist!"
    exit 1
fi

cd ${BUILD_DIR}
docker build -f Dockerfile -t ${LIBRARY} .

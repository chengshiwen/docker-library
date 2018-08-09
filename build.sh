#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Usage: $0 <name>"
    exit 1
fi

BUILD_DIR=$(dirname $0)/$1

if [[ ! -d ${BUILD_DIR} ]]; then
    echo "$1 not exist!"
    exit 1
fi

cd ${BUILD_DIR}
docker build -f Dockerfile -t $1 .

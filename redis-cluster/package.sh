#!/bin/bash

PACKAGE_DIR=${1:-"."}
PACKAGE_NAME=redis-cluster.tar.gz
PACKAGE_PATH=${PACKAGE_DIR%%/}/${PACKAGE_NAME}

base_dir=$(cd `dirname $0`; pwd)
TEMP=${base_dir}/redis-cluster
rm -rf ${TEMP} && mkdir -p ${TEMP}

echo "Save docker images ..."
docker save -o ${TEMP}/images.tar redis-cluster:latest
cp ${base_dir}/cluster.sh ${TEMP}
find ${TEMP} -name ".DS_Store" -exec rm {} \;
xattr -cr ${TEMP}

echo "Package ${PACKAGE_NAME} ..."
tar zcf ${PACKAGE_PATH} -C ${base_dir} redis-cluster
rm -rf ${TEMP}
echo "Package to: ${PACKAGE_PATH}"

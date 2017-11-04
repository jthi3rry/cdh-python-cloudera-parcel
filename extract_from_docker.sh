#!/bin/bash

set -e

PARCEL_VERSION=${1:-1}
DISTRIBUTION=${2:-centos}
TARGET_OS=${3:-centos7}
OS_VERSION=${4:-el7}
CONDA_URI=${5:-https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh}
PYTHON2_VERSION=${6:-2.7.11}
PYTHON3_VERSION=${7:-3.6.1}
PARCEL_NAME=${8:-CDH_PYTHON}
PARCEL_DIR=${9:-/opt/cloudera/parcels}

TIME=$(date +%s)
CONTAINER_NAME=parcel-build-$TIME

IMAGE_NAME=$(echo $PARCEL_NAME | tr '[:upper:]' '[:lower:]')

echo "Creating parcel: ${PARCEL_NAME}-${PARCEL_VERSION}-${OS_VERSION}.parcel"

docker build --build-arg PARCEL_NAME=${PARCEL_NAME} --build-arg PARCEL_VERSION=${PARCEL_VERSION} --build-arg PARCEL_DIR=$PARCEL_DIR \
                        --build-arg CONDA_URI=${CONDA_URI} \
                        --build-arg PYTHON2_VERSION=${PYTHON2_VERSION} --build-arg PYTHON3_VERSION=${PYTHON3_VERSION} \
                        --build-arg OS_VERSION=${OS_VERSION} --build-arg TARGET_OS=${TARGET_OS} \
                        -t ${IMAGE_NAME}:${TARGET_OS} -f ${DISTRIBUTION}.Dockerfile .

docker run -d --name ${CONTAINER_NAME} -t ${IMAGE_NAME}:${TARGET_OS} /bin/bash
docker cp -L ${CONTAINER_NAME}:${PARCEL_DIR}/${PARCEL_NAME}-${PARCEL_VERSION}-${OS_VERSION}.parcel ./target/
docker kill $CONTAINER_NAME
docker rm $CONTAINER_NAME

# validation
echo "Validation"
java -jar lib/validator.jar -f target/${PARCEL_NAME}-${PARCEL_VERSION}-${OS_VERSION}.parcel

echo "Successfully created ${PARCEL_NAME}-${PARCEL_VERSION}-${OS_VERSION}.parcel"

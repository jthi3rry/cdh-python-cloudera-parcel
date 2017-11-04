#!/usr/bin/env bash

export CDSW_ENGINE=${1:-docker.repository.cloudera.com/cdsw/engine:3}

TIME=$(date +%s)
CONTAINER_NAME=parcel-build-$TIME

# Extract python versions from environment
for py_version in $(docker run -ti --name $CONTAINER_NAME $CDSW_ENGINE env | grep PYTHON._VERSION); do
    eval "export $(echo -e "${py_version}" | tr -d '[:space:]')"
done

docker rm -f $CONTAINER_NAME &>/dev/null

echo "Detected the following python versions from $CDSW_ENGINE:"
echo "Python2: $PYTHON2_VERSION"
echo "Python3: $PYTHON3_VERSION"

## Get package list
#echo "Extracting Python2 packages for CDSW engine $CDSW_ENGINE_VERSION"
#docker run -ti --name $CONTAINER_NAME docker.repository.cloudera.com/cdsw/engine:$CDSW_ENGINE_VERSION \
#        /bin/sh -c "pip freeze 2>/dev/null | grep -v '^cdsw=='" \
#        > source/packages/python2_requirements.txt
#
#docker rm -f $CONTAINER_NAME &>/dev/null
#
#echo "Extracting Python3 packages for CDSW engine $CDSW_ENGINE_VERSION"
#docker run -ti --name $CONTAINER_NAME docker.repository.cloudera.com/cdsw/engine:$CDSW_ENGINE_VERSION \
#        /bin/sh -c "pip3 freeze 2>/dev/null | grep -v '^cdsw=='" \
#        > source/packages/python3_requirements.txt
#
#docker rm -f $CONTAINER_NAME &>/dev/null
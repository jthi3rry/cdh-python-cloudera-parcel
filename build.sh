#!/bin/bash
set -e

PARCEL=${1:-CDH_PYTHON-0.0.1.p0}
PARCEL_NAME=${PARCEL%%-*}
PARCEL_VERSION=${PARCEL#*-}
CONDA_URI=${2:-https://repo.continuum.io/miniconda/Miniconda2-4.3.30-Linux-x86_64.sh}
CDSW_ENGINE=${3:-docker.repository.cloudera.com/cdsw/engine:3}
PARCEL_DIR=${4:-/opt/cloudera/parcels}

CONDA_VERSION=$(echo $CONDA_URI | cut -d - -f 2)

if [[ -z "${PYTHON2_VERSION}" && -z "${PYTHON3_VERSION}" ]]; then
    echo "Extracting CDSW python information"
    source extract_cdsw_python.sh $CDSW_ENGINE
else
    echo "Using the following python versions:"
    echo "Python2: $PYTHON2_VERSION"
    echo "Python3: $PYTHON3_VERSION"
fi

PARCEL_VERSION="${PARCEL_VERSION}-miniconda2_${CONDA_VERSION}-py2_${PYTHON2_VERSION}-py3_${PYTHON3_VERSION}"

echo "Building ${PARCEL_NAME} parcel version ${PARCEL_VERSION} including python ${PYTHON2_VERSION} and ${PYTHON3_VERSION} \
using ${CONDA_URI} with PREFIX $PARCEL_DIR/$PARCEL_NAME-$PARCEL_VERSION"

echo "Create target directory"
mkdir -p ./target

# RHEL/CentOS
./extract_from_docker.sh $PARCEL_VERSION centos centos7 el7 $CONDA_URI $PYTHON2_VERSION $PYTHON3_VERSION $PARCEL_NAME $PARCEL_DIR
./extract_from_docker.sh $PARCEL_VERSION centos centos6 el6 $CONDA_URI $PYTHON2_VERSION $PYTHON3_VERSION $PARCEL_NAME $PARCEL_DIR
# Ubuntu
./extract_from_docker.sh $PARCEL_VERSION ubuntu trusty trusty $CONDA_URI $PYTHON2_VERSION $PYTHON3_VERSION $PARCEL_NAME $PARCEL_DIR
./extract_from_docker.sh $PARCEL_VERSION ubuntu xenial xenial $CONDA_URI $PYTHON2_VERSION $PYTHON3_VERSION $PARCEL_NAME $PARCEL_DIR
# Debian
./extract_from_docker.sh $PARCEL_VERSION debian jessie jessie $CONDA_URI $PYTHON2_VERSION $PYTHON3_VERSION $PARCEL_NAME $PARCEL_DIR
./extract_from_docker.sh $PARCEL_VERSION debian wheezy wheezy $CONDA_URI $PYTHON2_VERSION $PYTHON3_VERSION $PARCEL_NAME $PARCEL_DIR

# Create manifest.json
echo "Create manifest.json"
python ./lib/make_manifest.py ./target

echo "Update index.html"
python ./lib/create_index.py ./target

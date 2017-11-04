ARG TARGET_OS=centos7
FROM centos:${TARGET_OS}
ARG OS_VERSION=el7

ARG PARCEL_NAME=CDH_PYTHON
ARG PARCEL_VERSION=1
ARG PYTHON2_VERSION=2.7.11
ARG PYTHON3_VERSION=3.6.1
ARG CONDA_URI=https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
ARG PARCEL_DIR=/opt/cloudera/parcels

RUN yum install -y bzip2

COPY source/packages/* /tmp/
RUN mkdir -p $PARCEL_DIR && \
    CONDA_EXECUTABLE=$(basename ${CONDA_URI}) && \
    curl -O ${CONDA_URI} && \
    sh ${CONDA_EXECUTABLE} -b -p $PARCEL_DIR/$PARCEL_NAME-$PARCEL_VERSION && \
    rm -f ${CONDA_EXECUTABLE} && \
    export PATH=$PARCEL_DIR/$PARCEL_NAME-$PARCEL_VERSION/bin:$PATH && \
    conda create -y -q --copy -n python2 --file /tmp/python2.txt python=$PYTHON2_VERSION && \
    conda create -y -q --copy -n python3 --file /tmp/python3.txt python=$PYTHON3_VERSION

WORKDIR $PARCEL_DIR

RUN mkdir -p $PARCEL_NAME-$PARCEL_VERSION/{lib,meta}
COPY source/meta/* $PARCEL_NAME-$PARCEL_VERSION/meta/
RUN sed -i \
    -e "s/__OS_VERSION__/${OS_VERSION}/g" \
    -e "s/__PARCEL_VERSION__/${PARCEL_VERSION}/g" \
    -e "s/__PARCEL_NAME__/${PARCEL_NAME}/g" \
    ${PARCEL_NAME}-${PARCEL_VERSION}/meta/parcel.json && \
    sed -i \
    -e "s/__OS_VERSION__/${OS_VERSION}/g" \
    -e "s/__PARCEL_VERSION__/${PARCEL_VERSION}/g" \
    -e "s/__PARCEL_NAME__/${PARCEL_NAME}/g" \
    ${PARCEL_NAME}-${PARCEL_VERSION}/meta/py_env.sh

RUN tar czf ${PARCEL_NAME}-${PARCEL_VERSION}-${OS_VERSION}.parcel ${PARCEL_NAME}-${PARCEL_VERSION} --owner=root --group=root && \
    rm -rf ${PARCEL_NAME}-${PARCEL_VERSION}

CMD ['/bin/bash']
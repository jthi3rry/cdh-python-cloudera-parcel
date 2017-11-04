#!/bin/bash

export CDH_PYTHON2=${PARCELS_ROOT}/${PARCEL_DIRNAME}/envs/python2/bin/python
export CDH_PYTHON3=${PARCELS_ROOT}/${PARCEL_DIRNAME}/envs/python3/bin/python

if [ -z "${CDH_PYTHON}" ]; then
    export CDH_PYTHON=${CDH_PYTHON2}
fi

# Python Parcel

This repository gives an example on how to create a parcel for consistent distribution of Python 2 and 3 on a cluster via Cloudera Manager. It is an adaptation of Aki Ariga's [Cloudera Parcel for R](https://github.com/chezou/cloudera-parcel).

It provides the following:
* Automatic detection of python versions shipped with the CDSW engines.
    * Alternatively, you can supply the versions you'd like by setting `PYTHON2_VERSION` and `PYTHON3_VERSION` environment variables.
* Packages both python 2 & 3 into a single parcel as conda environments.
* Sets up python 2 as the default version for pyspark across the cluster when activating the parcel.
* Provides the ability to run pyspark on python 3 by pointing `PYSPARK_PYTHON` and `PYSPARK_DRIVER_PYTHON` to the python 3 environment instead.

## Prerequisites

* Docker

## Building the Parcels

```
$ ./build.sh [parcel_name-parcel_version]
```

Example:

```
$ ./build.sh CDH_PYTHON-0.0.1.p0
```

The parcels and manifest will be created in the `./target` directory.

### Customizing Python Packages

Packages can be customized by editing `source/packages/python2.txt` and `source/packages/python3.txt`. By default, they include the packages part of the Anaconda distribution.

## Serving the Parcels

Serve the files via any web server. For example:

```
$ cd ./target
$ python -m SimpleHTTPServer 8000
```

## Installing the Parcels

Add the url of your web server to the Remote Parcel Repository URLs in Cloudera Manager. Then download, distribute and activate the CDH_PYTHON parcel.

## Using with PySpark

### Python 2

This is the default python environment when the parcel is activated.

### Python 3

```
export PYSPARK_PYTHON=/opt/cloudera/parcels/CDH_PYTHON/envs/python3/bin/python
export PYSPARK_DRIVER_PYTHON=/opt/cloudera/parcels/CDH_PYTHON/envs/python3/bin/python
```

Or set these up as environment variables in you CDSW project.

## Notes / Known Limitations

* Parcels are built assuming Cloudera Manager's default parcel directory `/opt/cloudera/parcels`. Change this at build time if your parcel directory is different.
  This is because Anaconda/Miniconda requires a prefix at install time and is not easily portable once installed as paths are hardcoded across many files.

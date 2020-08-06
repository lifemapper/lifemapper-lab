#!/bin/bash
#
# Build and install prerequisites for compiling lmlab dependencies
#
. /opt/rocks/share/devel/src/roll/etc/bootstrap-functions.sh

# No opt-python for yum
module unload opt-python
yum install src/RPMS/screen-4.1.0-0.25.20120314git3c2946.el7.x86_64.rpm

# add dynamic libs
echo "/etc/alternatives/jre/lib/amd64" > /etc/ld.so.conf.d/lifemapper-lab-ld.conf
echo "/etc/alternatives/jre/lib/amd64/server" >> /etc/ld.so.conf.d/lifemapper-lab-ld.conf
echo "/opt/lmlab/lib" >> /etc/ld.so.conf.d/lifemapper-lab-ld.conf
echo "/opt/python/lib/" >> /etc/ld.so.conf.d/lifemapper-lab-ld.conf
/sbin/ldconfig

# pip for wheels
module load opt-python
python3.6 -m ensurepip --default-pip
module unload opt-python

# setuptools and wheel for backports.functools_lru_cache install
cd src/setuptools
make prep
cd ../..
module load opt-python
compile setuptools
module unload opt-python
install opt-lifemapper-setuptools

cd src/wheel
make prep
module load opt-python
python3.6 -m ensurepip --default-pip
python3.6 -m pip install *.whl
cd ../..
compile wheel
module unload opt-python

# cython > 0.23.4 for scipy 
cd src/cython
make prep
cd ../..
module load opt-python
compile cython
module unload opt-python
install opt-lifemapper-cython

# numpy for scipy and matplotlib
cd src/numpy
make prep
module load opt-python
python3.6 -m ensurepip --default-pip
python3.6 -m pip install *.whl
cd ../..
compile numpy
module unload opt-python

# matplotlib and dependencies (for biotaphypy)
# rpm only installs wheel files
cd src/matplotlib
make prep
module load opt-python
python3.6 -m ensurepip --default-pip
python3.6 -m pip install *.whl
cd ../..
module unload opt-python

cd src/scipy
make prep
module load opt-python
python3.6 -m ensurepip --default-pip
python3.6 -m pip install *.whl
cd ../..
compile scipy
module unload opt-python
install opt-lifemapper-scipy


# Leave with opt-python loaded
module load opt-python



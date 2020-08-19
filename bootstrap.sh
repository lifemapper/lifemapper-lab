#!/bin/bash
#
# Build and install prerequisites for compiling lmlab dependencies
#
. /opt/rocks/share/devel/src/roll/etc/bootstrap-functions.sh

# No opt-python for yum
module unload opt-python

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


# # install newer verson of proj for gdal
cd src/proj
make prep
cd ../..
compile proj
install lifemapper-proj
/sbin/ldconfig

# gdal and dependencies 
# for gdal
# # for gdal-libs
rpm -i src/RPMS/CharLS-1.0-5.el7.x86_64.rpm 
rpm -i src/RPMS/SuperLU-5.2.0-5.el7.x86_64.rpm 
rpm -i src/RPMS/armadillo-8.300.0-1.el7.x86_64.rpm
rpm -i src/RPMS/arpack-3.1.3-2.el7.x86_64.rpm 
rpm -i src/RPMS/atlas-3.10.1-12.el7.x86_64.rpm 
rpm -i src/RPMS/blas-3.4.2-8.el7.x86_64.rpm 
rpm -i src/RPMS/cfitsio-3.370-10.el7.x86_64.rpm 
rpm -i src/RPMS/freexl-1.0.5-1.el7.x86_64.rpm 
rpm -i src/RPMS/geos-3.5.0-1.rhel7.x86_64.rpm
rpm -i src/RPMS/geos-devel-3.5.0-1.rhel7.x86_64.rpm
rpm -i src/RPMS/gpsbabel-1.5.0-2.el7.x86_64.rpm
rpm -i src/RPMS/hdf5-1.8.12-10.el7.x86_64.rpm
rpm -i src/RPMS/hdf5-devel-1.8.12-10.el7.x86_64.rpm
rpm -i src/RPMS/lapack-3.4.2-8.el7.x86_64.rpm 
rpm -i src/RPMS/libaec-1.0.4-1.el7.x86_64.rpm
rpm -i src/RPMS/libaec-devel-1.0.4-1.el7.x86_64.rpm
rpm -i src/RPMS/libdap-3.13.1-2.el7.x86_64.rpm 
rpm -i src/RPMS/libgeotiff-1.4.0-1.rhel7.x86_64.rpm
rpm -i src/RPMS/libgeotiff-devel-1.4.0-1.rhel7.x86_64.rpm
rpm -i src/RPMS/libgta-1.0.4-1.el7.x86_64.rpm 
rpm -i src/RPMS/libtiff-devel-4.0.3-27.el7_3.x86_64.rpm
rpm -i src/RPMS/libusb-0.1.4-3.el7.x86_64.rpm
rpm -i src/RPMS/netcdf-4.3.3.1-5.el7.x86_64.rpm 
rpm -i src/RPMS/ogdi-3.2.0-4.rhel7.1.x86_64.rpm 
rpm -i src/RPMS/openblas-openmp-0.3.3-2.el7.x86_64.rpm 
rpm -i src/RPMS/openjpeg2-2.3.1-1.el7.x86_64.rpm 
rpm -i src/RPMS/postgresql-libs-9.2.24-1.el7_5.x86_64.rpm
rpm -i src/RPMS/proj-4.8.0-4.el7.x86_64.rpm 
rpm -i src/RPMS/shapelib-1.3.0-2.el7.x86_64.rpm
rpm -i src/RPMS/unixODBC-2.3.1-11.el7.x86_64.rpm 
rpm -i src/RPMS/xerces-c-3.1.1-8.el7_2.x86_64.rpm 
rpm -i src/RPMS/gdal-libs-1.11.4-12.rhel7.x86_64.rpm

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
python3.6 -m pip install *.whl
cd ../..
compile numpy
module unload opt-python

# matplotlib and dependencies (for biotaphypy)
# rpm only installs wheel files
cd src/matplotlib
make prep
module load opt-python
python3.6 -m pip install *.whl
cd ../..
module unload opt-python

cd src/scipy
make prep
module load opt-python
python3.6 -m pip install *.whl
cd ../..
compile scipy
module unload opt-python


# Leave with opt-python loaded
module load opt-python



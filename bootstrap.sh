#!/bin/bash
#
# Build and install prerequisites for compiling lmlab dependencies
#
. /opt/rocks/share/devel/src/roll/etc/bootstrap-functions.sh

# No opt-python for yum
module unload opt-python
yum install src/RPMS/screen-4.1.0-0.25.20120314git3c2946.el7.x86_64.rpm

# yumdownloader --resolve --enablerepo epel cmake3
rpm -i src/RPMS/cmake3-3.17.1-2.el7.x86_64.rpm     
rpm -i src/RPMS/cmake3-data-3.17.1-2.el7.noarch.rpm     

### do this only once for roll distro to keep known RPMS in the roll src
#cd src/RPMS
# yumdownloader --resolve --enablerepo base screen.x86_64

# add dynamic libs
echo "/etc/alternatives/jre/lib/amd64" > /etc/ld.so.conf.d/lifemapper-lab.conf
echo "/etc/alternatives/jre/lib/amd64/server" >> /etc/ld.so.conf.d/lifemapper-lab.conf
echo "/opt/lifemapper/lib" >> /etc/ld.so.conf.d/lifemapper-lab.conf
echo "/opt/python/lib/" >> /etc/ld.so.conf.d/lifemapper-lab.conf
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

# cherrypy 17.4.2 requires six>=1.11.0, cheroot>=6.2.4, portend>=2.1.1, 
#                    and for exec, not build:
#                          more-itertools=5.0.0 
#                          contextlib2==0.6.0.post1
#                          zc.lockfile=2.0
#                          backports.functools_lru_cache=1.6.1
#                          jaraco.functools=2.0
# cheroot requires six and setuptools
# portend requires tempora requires six, pytz

# needed for cheroot build (on devapp, not in LM install?)
cd src/six
make prep
cd ../..
module load opt-python
compile six
module unload opt-python
install opt-lifemapper-six
/sbin/ldconfig

cd src/cheroot
make prep
cd ../..
module load opt-python
compile cheroot
module unload opt-python
install opt-lifemapper-cheroot
/sbin/ldconfig

cd src/pytz
make prep
cd ../..
module load opt-python
compile pytz
module unload opt-python
install opt-lifemapper-pytz
/sbin/ldconfig

cd src/tempora
make prep
cd ../..
module load opt-python
compile tempora
module unload opt-python
install opt-lifemapper-tempora
/sbin/ldconfig

cd src/portend
make prep
cd ../..
module load opt-python
compile portend
module unload opt-python
install opt-lifemapper-portend
/sbin/ldconfig

# Leave with opt-python loaded
module load opt-python



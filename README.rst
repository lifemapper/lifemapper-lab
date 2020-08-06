
.. highlight:: rest

Lifemapper Lab roll
======================
.. contents::  

Introduction
------------
This roll installs Lifemapper tools for S^n services.
All prerequisite software listed below are a part of the roll and 
will be installed and configured during roll installation. 
The roll has been tested with Rocks 7.

Prerequisites
~~~~~~~~~~~~~

This section lists all the prerequisites for lifemapper-lab code dependencies.
The dependencies are either build from source or installed from RPMs 
during the roll build.
 
    
Downloads
~~~~~~~~~

Individual package dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Required Rolls
~~~~~~~~~~~~~~


Building a roll
---------------

Checkout roll distribution from git repo :: 

   # git clone https://github.com/lifemapper/lifemapper-lab.git 
   # cd lifemapper-lab/

To build a roll, first execute a script that downloads and installs some packages 
and RPMS that are prerequisites for other packages during the roll build stage: ::

   # ./bootstrap.sh  

For each dependency to be built as an RPM ::  

   # cd src/lmpy
   # make prep 
   # make rpm

When all individual packages are building without errors build a roll via 
executing the command at the top level of the roll source tree ::

   # make roll

The resulting ISO file lifemapper-lab-*.iso is the roll that can be added to the
frontend.

Debugging a roll
----------------


Recreate roll ISO
-----------------

When updating only a few packages in the roll, there is no need to re-create 
all packages anew. After re-making updated RPMs  from the top level of roll source tree ::   

   # make reroll

The new rpms will be inlcuded in the new ISO. 

Adding a roll
-------------
The roll (ISO file) can be added (1) during the initial installation of the cluster (frontend)
or (2) to the existing frontend.


Adding a roll to a new server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



Adding a roll to a live frontend
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Where installed roll components are
-----------------------------------

#. **/state/partition1/lmscratch/** -  
   + /state/partition1/lmscratch/sessions - cherrypy sessions.
   + /state/partition1/lmscratch/tmpUpload - landing spot for uploaded files
   + /state/partition1/lmscratch/log - script and daemon logs.
   + /state/partition1/lmscratch/run - PID files.
   + /state/partition1/lmscratch/worker - Workqueue workers and Makeflow data?

#. **/var/www/tmp/** - for mapserver temp files

#. **/var/www/html/roll-documentation/lifemapper-server** - roll documentation, bare  minimum as a place holder.

Updating parts of a roll
------------------------

.. _Updating : docs/Updating.rst

If you are re-installing the lifemapper-lmserver rpm (Lifemapper source code), 
and/or the rocks-lifemapper rpm, see **Update code and scripts** at `Updating`_  
to update the configuration, database, and restart services.   


Removing a roll
---------------

When debugging a roll may need to remove the roll and all installed RPMs.
Before removing the roll stop postgres and pgbouncer services with service 
or systemctl command ::  
  
   # /etc/init.d/pgbouncer stop
   # /etc/init.d/postgresql-9.1 stop 
   # bash cleanRoll.sh

These commands remove the installed roll from Rocks database and repo ::

   # rocks remove roll lifemapper-server
   # (cd /export/rocks/install; rocks create distro)  

Using a Roll
------------

See `Using Lifemapper`_

Notes
-----

#. **Compiling pylucene**: make rpm (deprecated)

   #. On 2Gb memory host: is barely succeeding or failing intermittently. 
      Need to shut down  any extra daemons (like postgres and pgbouncer) and limit the java heap size. 
      Currently, heap sie is limited by added  environment ``_JAVA_OPTIONS="-Xmx256m"`` in Makefile. 
      May need to investigate -XX:MaxPermSize=128m and -Xms128m options in addition to -Xmx. 
      Other solutions (excerpt from hs_err_pi*log from one of failed runs): ::   

        # There is insufficient memory for the Java Runtime Environment to continue.
        # Native memory allocation (malloc) failed to allocate 32744 bytes for ChunkPool::allocate
        # Possible reasons:
        #   The system is out of physical RAM or swap space
        #   In 32 bit mode, the process size limit was hit
        # Possible solutions:
        #   Reduce memory load on the system
        #   Increase physical memory or swap space
        #   Check if swap backing store is full
        #   Use 64 bit Java on a 64 bit OS
        #   Decrease Java heap size (-Xmx/-Xms)
        #   Decrease number of Java threads
        #   Decrease Java thread stack sizes (-Xss)
        #   Set larger code cache with -XX:ReservedCodeCacheSize=

      If possible use 4Gb memory host. 

   #. On 4gb memory host: compile succeeds. 

#. **Free memory loss**: during building a roll some java-based packages are 
   not releasing allocated memory properly which results in available memory 
   loss. After building a roll check host memory with ``free -m`` and run::
   
      sync && echo 1 > /proc/sys/vm/drop_caches
 

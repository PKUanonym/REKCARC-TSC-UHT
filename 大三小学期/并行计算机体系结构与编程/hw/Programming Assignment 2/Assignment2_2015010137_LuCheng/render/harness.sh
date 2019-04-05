#!/bin/bash

cd $PBS_O_WORKDIR
PATH=$PATH:$PBS_O_PATH
. ~/.bashrc
. ~/.bash_profile
HOST=`hostname`

echo "Hostname is " $HOST

module load gcc-4.9.2

make check

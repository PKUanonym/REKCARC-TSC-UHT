#!/bin/bash

qsub latedays.qsub -l nodes=1:ppn=24 -q tesla


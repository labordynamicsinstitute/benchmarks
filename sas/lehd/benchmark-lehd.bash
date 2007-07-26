#!/bin/bash
# $Id$
# $HeadURL$
# 
# SETUP
# copy this script to a subdirectory, edit the workdir variable to your needs,
# and run with 
#  mkdir mytest-no1
#  cd mytest-no1
#  sed 's+workdir=/tmp+workdir=/whatever+' \
#    ../benchmark-lehd.bash > benchmark-lehd.bash
#  chmod u+rx *bash
#  ./benchmark-lehd.bash
#
# set up parameters. 
# THREADS: This should ideally load the system. I.e., set it to the number
# of CPUs on the system, or higher.
threads=32
# LOOPS: this is the number of times you run through all THREADS threads
# if you think that your system performance is stable, =2 is sufficient,
# otherwise, run it again.
loops=2
# WORKDIR: defines where SAS writes (most) of its files. See additional
# notes in the SAS program
workdir=/tmp
# You Should leave these as is. The SAS program should be one directory up
# logs should be written to the current dir (mytest-no1)
progdir=$(dirname $0)/..
logdir=$(dirname $0)

loop=1
while [[ $loop -le  $loops ]]
do
  echo "--------------------------------------------------"
  echo " "
  thread=1
  pids=
  while [[ $thread -le $threads ]]
  do
  sas -work $workdir -log ${logdir}/benchmark-lehd.loop${loop}.thread${thread}.log ${progdir}/benchmark-lehd.sas &
    pid=$!
    pids="$pids $pid"
    echo " Loop: $loop/$loops    Thread: $thread/$threads    PID: $pid  "
    let thread+=1
  done

  printf "\n%-50s" " Waiting for PIDS $pids"
  wait $pids
  printf "%10s\n\n" "[done]"
  let loop+=1
done
  

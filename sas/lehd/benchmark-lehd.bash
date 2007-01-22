#!/bin/bash
# $Id$
# $HeadURL$
# 
# SETUP
# copy this script to a subdirectory, edit the workdir to your needs,
# and run with 
#  ./bechmark-lehd.bash
#
# set up parameters
threads=2
loops=2
workdir=/tmp
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
  

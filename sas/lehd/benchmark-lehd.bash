#!/bin/bash
# $Date$ $Rev$ $Author$
# $HeadURL$

# set up parameters
threads=2
loops=2
workdir=/tmp
progdir=$(dirname $0)

loop=1
while [[ $loop -le  $loops ]]
do
  echo "--------------------------------------------------"
  echo " "
  thread=1
  pids=
  while [[ $thread -le $threads ]]
  do
  sas -work $workdir -log ${progdir}/benchmark-lehd.loop${loop}.thread${thread}.log ${progdir}/benchmark-lehd.sas &
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
  

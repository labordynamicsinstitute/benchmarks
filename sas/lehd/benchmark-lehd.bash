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
#  cp ../benchmark-lehd.config.sas
#  # (edit to your liking)
#  chmod u+rx *bash
#  ./benchmark-lehd.bash
#
# set up parameters. 

. $0.config

# sanity check: is this really a directory
if [[ ! -d $workdir ]]
then
   echo "Workdir = $workdir is not a directory"
   exit 2
fi
# a second parameter, to pass through to SAS
if [[ -z $2 ]]
then
   size=small
else
   size=$2
fi

# You Should leave these as is. The SAS program should be one directory up
# logs should be written to the current dir (mytest-no1)
progdir=$(dirname $0)/..
progsuffix=
logdir=$(dirname $0)
delay=0

# print out config
echo " Running benchmark test with following parameters:"
echo "  Workdir   =$workdir"
echo "  Progdir   =$progdir"
echo "  Progsuffix=$progsuffix"
echo "  Logdir    =$logdir"
echo "  Delay     =$delay (in seconds, between launching of jobs)"
echo " The following parameter will be passed through to the SAS program:"
echo "  (size=) $size"

loop=0
thread=1
  # burn-in phase: one run through to get the disks spinning
  sas -work $workdir \
      -log ${logdir}/burn-in.loop${loop}.thread${thread}.log \
      -sysparm $size\
      ${progdir}/benchmark-lehd${progsuffix}.sas &
    pid=$!
    echo " Burn-in: 1/1     Thread: $thread/$thread    PID: $pid  "
  printf "\n%-50s" " Waiting for PIDS $pid"
  wait $pids
  printf "%10s\n\n" "[done]"
loop=1
while [[ $loop -le  $loops ]]
do
  echo "--------------------------------------------------"
  echo " "
  thread=1
  pids=
  while [[ $thread -le $threads ]]
  do
  sas -work $workdir \
      -log ${logdir}/benchmark-lehd.loop${loop}.thread${thread}.log \
      -sysparm $size\
      ${progdir}/benchmark-lehd${progsuffix}.sas &
    pid=$!
    pids="$pids $pid"
    echo " Loop: $loop/$loops    Thread: $thread/$threads    PID: $pid  "
    let thread+=1
    sleep $delay
  done

  printf "\n%-50s" " Waiting for PIDS $pids"
  wait $pids
  printf "%10s\n\n" "[done]"
  let loop+=1
done
  
../compute.sh

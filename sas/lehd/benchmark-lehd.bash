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
threads=2
# LOOPS: this is the number of times you run through all THREADS threads
# if you think that your system performance is stable, =2 is sufficient,
# otherwise, run it again.
loops=3
# WORKDIR: defines where SAS writes (most) of its files. See additional
# notes in the SAS program
[[ -z $1 ]] && workdir=/tmp || workdir=$1
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
logdir=$(dirname $0)

# print out config
echo " Running benchmark test with following parameters:"
echo "  Workdir=$workdir"
echo "  Progdir=$progdir"
echo "  Logdir =$logdir"
echo " The following parameter will be passed through to the SAS program:"
echo "  (size=) $size"

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
      ${progdir}/benchmark-lehd.sas &
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
  

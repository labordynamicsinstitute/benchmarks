#!/bin/bash
grep -E 'threads=|loops=' *bash
count=$(ls *log | wc -l)
printf " %20s" " Total runs: "
echo $count
printf " %20s" " Avg: "
(for arg in $(ls *log); do grep "real time" $arg | tail -1 | awk ' { print $3 } '; done) | awk -v count=$count ' { sum+=$1 } END { print sum/count } '
printf " %20s" " Min: "
(for arg in $(ls *log); do grep "real time" $arg | tail -1 | awk ' { print $3 } '; done) | sort -n | head -n 1
printf " %20s" " Max: "
(for arg in $(ls *log); do grep "real time" $arg | tail -1 | awk ' { print $3 } '; done) | sort -n | tail -n 1


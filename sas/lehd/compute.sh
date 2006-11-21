#!/bin/bash
count=$(ls *log | wc -l)
(for arg in $(ls *log); do grep "real time" $arg | tail -1 | awk ' { print $3 } '; done) | awk -v count=$count ' { sum+=$1 } END { print sum/count } '


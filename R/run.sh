#!/bin/bash

if [[ -z $1 ]]
then
cat < EOF
Usage: $0 tag

where tag is some name.
EOF
exit 1
fi

R=R
tag=gnu
hostname > R-newbenchmark.${tag}.$(date +%F).Rout
$R < new-benchmark.R >> R-newbenchmark.${tag}.$(date +%F).Rout
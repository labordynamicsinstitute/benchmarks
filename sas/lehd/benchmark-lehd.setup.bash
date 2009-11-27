#!/bin/bash
# $Id$
# $URL$

basename=benchmark-lehd

if [[ -z $1 ]]
then
cat << EOF

   $0 dirname

   will set up a test using the $basename suite in
   directory (dirname).

   If (dirname) exists, the script will abort.
EOF
exit 2
fi

dirname=$1

if [[ -d $dirname ]]
then
  echo "directory $dirname exists - aborting"
  exit 1
else
  mkdir $dirname
  cd $dirname
  ln -s ../$basename.bash .
  cp ../${basename}.bash.config .
  grep -E "threads=|loops=" ${basename}.bash.config
  cp ../${basename}.config.sas .
  echo "To run the benchmark, edit ${basename}.bash.config"
  echo "and ${basename}.config.sas to your liking,"
  echo "then do a test run as"
  echo " ${basename}.bash (yourwork)"
  echo "where (yourwork) is where you want the SAS work"
  echo "directory to point to. Check the logs, and if"
  echo "all is fine, then run the test:"
  echo " ${basename}.bash (yourwork) large"
fi

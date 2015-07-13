#!/bin/bash

if [[ $1 == "add" && $2 == "-A" ]]
then
#add directory
var=$(pwd)
  echo "directory,$var,,\"$3\"" >> queue.csv
# elif [[ $1 == "add" && $2 == "-f" ]]
# then
#   #add file
elif [[ $1 == "add" ]]
then
#add directory
var=$(pwd)
  echo "file,$var,$2,\"$3\"" >> queue.csv
elif [[ $1 == "status" && $2 == "" && $3 == "" ]]
then
  queue=$(<queue.csv)
  echo $queue

elif [[ $1 == "-rm" && $2 && $3 == "" ]]
  then
  if grep -Fxq $2 queue.csv
    then
    echo `sed  /$2/d queue.csv` > queue.csv
     perl -p -i -e 's/\s/\n/g' queue.csv
  else
    echo "File not found"
  fi
else
  echo "Wrong syntax, idiot."

fi

# realpath git_off.sh

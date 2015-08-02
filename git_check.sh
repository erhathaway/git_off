#!/bin/bash

BASEDIR=$(dirname $0)
current_dir=$(pwd)

if [ $BASEDIR = '.' ]
  then
  BASEDIR="$current_dir"
fi

GITPUSH=$BASEDIR/git_push.sh
LOG=$BASEDIR/log.csv
QUEUE=$BASEDIR/queue.csv

# check for internet connectivity
wget -q --spider http://github.com

if [ $? -eq 0 ]; then
    echo "Online"
    INTERNET=1
else
    echo "Offline"
    INTERNET=0
fi

#check to make sure there are items in the queue
NUMOFLINES=$(cat $QUEUE | wc -l )

if [[ $NUMOFLINES -gt 0 && $INTERNET -eq 1 ]]
  then
  # get time
  TIME=$(date +"%m-%d-%Y-h")

  PATTERN=$TIME
  FILE=$(cat $LOG)

  # check to make sure nothing was commited today
  if echo "$FILE" | grep -q "$PATTERN";
   then
    "already commited"
   else
    ($GITPUSH)
  fi
fi

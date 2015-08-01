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


NUMOFLINES=$(cat $QUEUE | wc -l )

if [ $NUMOFLINES -gt 0 ]
  then
  TIME=$(date +"%m-%d-%Y-h")

  PATTERN=$TIME
  FILE=$(cat $LOG)

  if echo "$FILE" | grep -q "$PATTERN";
   then
    "already commited"
   else
    ($GITPUSH)
  fi
fi

#!/bin/bash

BASEDIR=$(dirname $0)
current_dir=$(pwd)

if [ $BASEDIR = '.' ]
  then
  BASEDIR="$current_dir"
fi

GITPUSH=$BASEDIR/git_push.sh
LOG=$BASEDIR/log.csv

TIME=$(date +"%m-%d-%Y-h")

PATTERN=$TIME
FILE=$(cat $LOG)

if echo "$FILE" | grep -q "$PATTERN";
 then
  "already commited"
 else
  ($GITPUSH)
fi

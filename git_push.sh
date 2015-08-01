#!/bin/bash

BASEDIR=$(dirname $0)
current_dir=$(pwd)

if [ $BASEDIR = '.' ]
  then
  BASEDIR="$current_dir"
fi

QUEUE=$BASEDIR/queue.csv
ERRORQUEUE=$BASEDIR/error_queue.csv
LOG=$BASEDIR/log.csv

#Retrive item from queue
LINE=$(sed -n '1p' $QUEUE) #queue.csv)
# sed -i '1d' $QUEUE

#Parse item into components
set -- "$LINE"
IFS=","; declare -a Array=($*)
#Set variables. Note: Itemtype is either a directory or file
ITEMTYPE="${Array[0]}"
DIRECTORY="${Array[1]}"
NAME="${Array[2]}"
COMMENT="${Array[3]}"

#git status of remote
GITSTATUS=$(cd $DIRECTORY && git pull)

#make sure there are no merge conflicts
if echo "$GITSTATUS" | grep -q "merge issue";
  then
  PROCEED=0
else
  PROCEED=1
fi

#make the commits if possible
if [ "$ITEMTYPE" == "directory" ] && [ "$PROCEED" == 1 ]; then
  COMMIT=$(cd $DIRECTORY && git add -A && git commit -m $COMMENT 2>&1)
elif [ "$ITEMTYPE" == "file" ] && [ "$PROCEED" == 1 ]; then
  COMMIT=$(cd $DIRECTORY && git add $NAME && git commit -m $COMMENT 2>&1)
fi

# check the commit status
COMMITPATTERN1="nothing to commit"

if echo "$COMMIT" | grep -q -e "$COMMITPATTERN1";
 then
   PROCEED=0
 else
   PROCEED=1
fi

#if no errors, push to remote
if [ "$PROCEED" == 1 ]; then
  PUSH=$(cd $DIRECTORY && git push --progress 2>&1)

  #check push status
  PUSHPATTERN1="Writing objects: 100%"
  # PATTERN2="Total" #other patterns that may be helpful
  # PATTERN3="done."

  if echo "$PUSH" | grep -q -e "$PUSHPATTERN1";
   then
     PROCEED=1
   else
     PROCEED=0
  fi
fi


#get time
TIME=$(date +"%m-%d-%Y %r")

# log status
if [ "$PROCEED" == 1 ]; then
  echo "$TIME, SUCCESS, $ITEMTYPE, $DIRECTORY, $NAME, $COMMENT" >> $LOG

else
  echo "$ITEMTYPE,$DIRECTORY,$NAME,$COMMENT" >> $ERRORQUEUE
  echo "$TIME, ERROR, $ITEMTYPE, $DIRECTORY, $NAME, $COMMENT" >> $LOG
fi

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

#make the commits or add to error queue
if [ "$ITEMTYPE" == "directory" ] && [ "$PROCEED" == 1 ]; then
  cd $DIRECTORY && git add -A && git commit -m $COMMENT
elif [ "$ITEMTYPE" == "file" ] && [ "$PROCEED" == 1 ]; then
  cd $DIRECTORY && git add $NAME && git commit -m $COMMENT
else
  echo "$ITEMTYPE,$DIRECTORY,$NAME,$COMMENT" >> $ERRORQUEUE
fi


#check push  status
STATUS=""
echo 'hello'
PUSH=$(cd $DIRECTORY && git push echo > $STATUS)

echo 'hi'
echo $STATUS

# Writing objects: 100% (104/104), 8.44 KiB | 0 bytes/s, done.
# Total 104 (delta 70), reused 0 (delta 0)
# To git@github.com:erhathaway/git_off.git

#get time
TIME=$(date +"%m-%d-%Y %r")

#if no errors, push to remote
if [ "$PROCEED" == 1 ]; then
  # cd $DIRECTORY && git push

  echo "$TIME, SUCCESS, $ITEMTYPE, $DIRECTORY, $NAME, $COMMENT" >> $LOG
else
  echo "$TIME, ERROR, $ITEMTYPE, $DIRECTORY, $NAME, $COMMENT" >> $LOG
fi

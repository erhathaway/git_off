#!/bin/bash

BASEDIR=$(dirname $0)
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
echo $ITEMTYPE
echo $DIRECTORY
echo $NAME
echo $COMMENT

#git status of remote
GITSTATUS=$(cd $DIRECTORY && git pull)

#make sure there are no merge conflicts
if echo "$GITSTATUS" | grep -q "merge issue";
  then
  PROCEED=0
else
  PROCEED=1
  # echo "test"
fi

#make the commits or add to error queue
if [ "$ITEMTYPE" == "directory" ] && [ "$PROCEED" == 1 ]; then
  cd $DIRECTORY && git add -A && git commit -m $COMMENT
  # echo "test"
elif [ "$ITEMTYPE" == "file" ] && [ "$PROCEED" == 1 ]; then
  cd $DIRECTORY && git add $NAME && git commit -m $COMMENT
  # echo "test"
else
  echo "$ITEMTYPE,$DIRECTORY,$NAME,$COMMENT" >> $ERRORQUEUE
fi

#if no errors, push to remote
if [ "$PROCEED" == 1 ]; then
  # cd $DIRECTORY && git push
  echo "$(date), SUCCESS, $ITEMTYPE, $DIRECTORY, $NAME, $COMMENT" >> $LOG
else
  echo "$(date), ERROR, $ITEMTYPE, $DIRECTORY, $NAME, $COMMENT" >> $LOG
fi

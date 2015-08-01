#!/bin/bash

BASEDIR=$(dirname $0)
QUEUE=$BASEDIR/queue.csv
NEWITEM=$BASEDIR/new_item.csv
LOG=$BASEDIR/log.csv

# add directory to queue:
if [[ $1 == "add" && $2 == "-A" ]] || [[ $1 == "add" && $2 == "." ]]
  then
  var=$(pwd)
  echo "directory,$var," > $NEWITEM

# add file to queue:
elif [[ $1 == "add" ]]
  then
  var=$(pwd)
  echo "file,$var,$2" > $NEWITEM

# add commit message
elif [[ $1 == "commit" && $2 == "-m" ]]
  then
    #get temp item that should be added to queue
    ITEM=`cat $NEWITEM`
    #check to make sure there actually is a temp item
    SIZE=${#ITEM}
    if [ $SIZE -gt 0 ]
      then
      echo "$ITEM,$3" >> $QUEUE
      #clear the temp item
      echo ""> $NEWITEM
    else
      echo "Please add an item first"
    fi

#display last line added to queue
elif [[ $1 == "-ll" ]]
  then
    echo $(tail -2 queue.csv | head -1)

# display queue status:
elif [[ $1 == "status" ]]
  then
  ((var=1))
  echo $'\tID \tItem Type  \tItem
  ---------------------------------------------------------------------'
  while read line
  do

    #Parse item into components
    set -- "$line"
    IFS=","; declare -a Array=($*)

    #Set variables. Note: Itemtype is either a directory or file
    ITEMTYPE="${Array[0]}"
    DIRECTORY="${Array[1]}"
    NAME="${Array[2]}"
    COMMENT="${Array[3]}"
    if [[ $ITEMTYPE == "directory" ]]
      then
        echo $'\t' $var $'\t' "directory: " $DIRECTORY $'\t\t' $COMMENT
    else
        echo $'\t' $var $'\t' "file:      " $DIRECTORY/$NAME$'\t\t'  $COMMENT
    fi
    ((var=var+1))
  done <$QUEUE

#remove item from queue by queue ID
elif [[ $1 == "-rm" && $2 ]]
  then
  sed -n "$2p" $QUEUE >> $LOG
  sed -i".bak" "$2d" $QUEUE

# display available commands
else
  echo $'Syntax Error\n
Available commands\n
  add -A        add directory
  add .         add directory
  add filename  add file

  status        display current queue

  -rm queue_id  remove an item from the queue
  -ll           display last item added to queue'

fi

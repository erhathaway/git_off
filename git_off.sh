#!/bin/bash

BASEDIR=$(dirname $0)
current_dir=$(pwd)

if [ $BASEDIR = '.' ]
  then
  BASEDIR="$current_dir"
fi

QUEUE=$BASEDIR/queue.csv
NEWITEM=$BASEDIR/new_item.csv
LOG=$BASEDIR/log.csv
ERRORQUEUE=$BASEDIR/error_queue.csv

# add directory to queue:
if [[ $1 == "add" && $2 == "-A" ]] || [[ $1 == "add" && $2 == "." ]]
  then
  var=$(pwd)
  echo "directory,$var," > $NEWITEM

# add file to queue:
elif [[ $1 == "add" ]]
  then
  var=$(pwd)
  FILENAMESIZE=${#2}
  # check to make sure an input was provided
  if [ $FILENAMESIZE -gt 0 ]
    then
      # check if file exists
      if [ -e "$var/$2" ]
        then
        echo "file,$var,$2" > $NEWITEM
      else
        echo "Could not find file"
      fi
  else
    echo "Please specify a file to add to the queue"
  fi

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
elif [[ $1 == "ll" ]]
  then
    LASTLINE=$(tail -1 $QUEUE | head -1)
    IFS=',' read -a LLARRAY <<< "$LASTLINE"
    # arr=$(echo $LASTLINE | tr "," "\n")
    NUMOFLINES=$(wc -l < "$QUEUE")

    ITEMTYPE="${LLARRAY[0]}"
    DIRECTORY="${LLARRAY[1]}"
    NAME="${LLARRAY[2]}"
    COMMENT="${LLARRAY[3]}"

    echo $'\tID \tItem Type  \tItem
    ---------------------------------------------------------------------'
    if [[ $ITEMTYPE == "directory" ]]
      then
        echo $'\t' $NUMOFLINES $'\t' "directory: " $DIRECTORY $'\t\t' $COMMENT
    else
        echo $'\t' $NUMOFLINES $'\t' "file:      " $DIRECTORY/$NAME$'\t\t'  $COMMENT
    fi

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
  done < "$QUEUE"

# display log
elif [[ $1 == "log" ]]
  then
  if [[ $2 == "-e" && $3 == "--clear" ]]
    then
      echo > $ERRORQUEUE
  elif [[ $2 == "-e" ]]
    then
      cat "$ERRORQUEUE"
  elif [[ $2 == "--clear" ]]
    then
      echo > $LOG
  else
    cat "$LOG"
  fi

#remove item from queue by queue ID
elif [[ $1 == "rm" && $2 ]]
  then
  sed -n "$2p" $QUEUE >> $LOG
  sed -i".bak" "$2d" $QUEUE

# display available commands
else
  echo $'Syntax Error\n
Available commands\n
  add -A         add directory
  add .          add directory
  add filename   add file

  commit -m      commit message

  status         display current queue
  log            display log of successful commits
  log -e         display error queue log (aka unsuccessful commits)
  log --clear    clear log
  log -e --clear clear error queue log


  rm queue_id   remove an item from the queue
  ll            display last item added to queue'

fi

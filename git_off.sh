#!/bin/bash

# add directory to queue:
if [[ $1 == "add" && $2 == "-A" ]] || [[ $1 == "add" && $2 == "." ]]
  then
  var=$(pwd)
  echo "directory,$var,,\"$3\"" >> queue.csv

# add file to queue:
elif [[ $1 == "add" ]]
  then
  var=$(pwd)
  echo "file,$var,$2,\"$3\"" >> queue.csv

# display queue status:
elif [[ $1 == "status" ]]
  then
  # queue=$(<queue.csv)
  # echo $queue
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
        echo "directory: " $DIRECTORY "  --" $COMMENT
    else
        echo "file:      " $DIRECTORY/$NAME "  --" $COMMENT
    fi        
  done <queue.csv 
#remove file from queue
elif [[ $1 == "-rm" && $2 && $3 == "" ]]
  then
  if grep -Fxq $2 queue.csv
    then
    echo `sed  /$2/d queue.csv` > queue.csv
     perl -p -i -e 's/\s/\n/g' queue.csv
  else
    echo "File not found"
  fi

# display available commands
else
  echo $'Syntax Error\n 
Available commands\n
  add -A        adds a directory
  add .         adds a directory
  add filename  adds a file

  status        displays current queue

  -rm queue_id  removes an item from the queue'
fi


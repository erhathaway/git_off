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
  ((var=1))
  echo $'\tID \tItem Type  \tItem  
  --------------------------------------------------------------------------------------------------'
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
  done <queue.csv 

#remove item from queue by queue ID
elif [[ $1 == "-rm" && $2 && $3 == "" ]]
  then
  sed -n "$2p" queue.csv >> log.csv
  sed -i".bak" "$2d" queue.csv

# display available commands
else
  echo $'Syntax Error\n 
Available commands\n
  add -A        add directory
  add .         add directory
  add filename  add file

  status        display current queue

  -rm queue_id  remove an item from the queue'
fi


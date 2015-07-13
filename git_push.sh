#!/bin/bash

#Retrive item from queue
LINE=$(sed -n '1p' queue.csv)
sed -i '1d' queue.csv

#Parse item into components
set -- "$LINE" 
IFS=","; declare -a Array=($*) 
#Set variables. Note: Itemtype is either a directory or file
ITEMTYPE="${Array[0]}" 
DIRECTORY="${Array[1]}" 
NAME="${Array[2]}" 
COMMENT="${Array[3]}" 

# echo $ITEMTYPE
# echo $DIRECTORY
# echo $NAME
# echo $COMMENT
GITSTATUS=$(cd $DIRECTORY && git pull)

if echo "$GITSTATUS" | grep -q "merge issue";
  then
  PROCEED=0
else
  PROCEED=1
fi


echo $GITSTATUS
echo $PROCEED

if [ "$ITEMTYPE" = "directory" ] && [ "$PROCEED" = 1 ]; then
  cd $DIRECTORY && git add -A && git commit -m $COMMENT
elif [ "$ITEMTYPE" = "file" ] && [ "$PROCEED" = 1 ]; then
  cd $DIRECTORY && git add $NAME && git commit -m $COMMENT
fi

# cd $DIRECTORY && git push
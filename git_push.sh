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

echo $ITEMTYPE
echo $DIRECTORY
echo $NAME
echo $COMMENT

if [ "$ITEMTYPE" = "directory" ]; then
  cd $DIRECTORY && git add -A && git commit -m "$COMMENT"
elif [ "$ITEMTYPE" = "file" ]; then
  cd $DIRECTORY && git add "$NAME" && git commit -m "$COMMENT"
fi


# get file or directory off queue
# cd into directory
# if directory, git add -add
# elif file, git add file

# git commit -m message
# git push 
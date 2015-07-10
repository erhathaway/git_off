#!/bin/bash

#Retrive item from queue
LINE=$(sed -n '1p' queue.csv)
sed -i '1d' queue.csv

#Parse item into components
set -- "$LINE" 
IFS=","; declare -a Array=($*) 
#Set variables. Note: Itemtype is either a directory or file
ITEMTYPE="${Array[0]}" 
NAME="${Array[1]}" 
COMMENT="${Array[2]}" 



# get file or directory off queue
# cd into directory
# if directory, git add -add
# elif file, git add file

# git commit -m message
# git push 
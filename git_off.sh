#!/bin/bash

if [[ $1 == "add" && $2 == "-d" ]]
then
#add directory
  echo $3 >> empty.txt
# elif [[ $1 == "add" && $2 == "-f" ]]
# then
#   #add file
elif [[ $1 == "status" && $2 == "" && $3 == "" ]]
then
  empty=$(<empty.txt)
  echo $empty

elif [[ $1 == "-rm" && $2 && $3 == "" ]]
  then
  if grep -Fxq $2 empty.txt
    then
    echo `sed  /$2/d empty.txt` > empty.txt
     perl -p -i -e 's/\s/\n/g' empty.txt
  else
    echo "File not found"
  fi
else
  echo "Wrong syntax, idiot."

fi

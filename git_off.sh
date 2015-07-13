#!/bin/bash

if [[ $1 == "add" && $2 == "-d" ]]
then
#add directory
  echo $3 >> empty.csv
# elif [[ $1 == "add" && $2 == "-f" ]]
# then
#   #add file
elif [[ $1 == "status" && $2 == "" && $3 == "" ]]
then
  empty=$(<empty.csv)
  echo $empty

elif [[ $1 == "-rm" && $2 && $3 == "" ]]
  then
  if grep -Fxq $2 empty.csv
    then
    echo `sed  /$2/d empty.csv` > empty.csv
     perl -p -i -e 's/\s/\n/g' empty.csv
  else
    echo "File not found"
  fi
else
  echo "Wrong syntax, idiot."

fi


# realpath git_off.sh

var=$(pwd)
echo $var

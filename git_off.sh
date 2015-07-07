#!/bin/bash
if [[ $1 == "add" && $2 == "-d" ]]
then
  echo $3 >> empty.txt

elif [[ $1 == "status" && $2 == "" && $3 == "" ]]
then
  empty=$(<empty.txt)
  echo $empty

# elif [[ $1 == "-rm" && 2 == "" && $3 == "" ]]
# then

else
  echo "Wrong syntax, idiot."
fi
# http://stackoverflow.com/questions/4749330/how-to-test-if-string-exists-in-file-with-bash-shell

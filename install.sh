#!/bin/bash

#set location variables
LOCATION=$HOME/.git_off
USERFILE="git_off.sh"
CRONFILE="git_push.sh"
QUEUE="queue.csv"

#make files executable
chmod +x $USERFILE
chmod +x $CRONFILE

#if git_off directory doesn't exist
if [ ! -d "$LOCATION" ]; then
  mkdir $LOCATION
fi

#copy files into directory
cp -f $USERFILE $LOCATION/
cp -f $CRONFILE $LOCATION/
touch $LOCATION/$QUEUE

#check to make sure chron is running
CRONPID=$(pgrep cron)

if echo $CRONPID;
  then
  echo 'cron running with PID:' $CRONPID
else
  echo 'ERROR: cron is not running'
fi

#create tasks
PATTERN="$CRONFILE"
FILE=$(crontab -l)

if echo "$FILE" | grep -q "$PATTERN";
 then
  echo "already a cron job!"
 else
  line="* * * * * $LOCATION/$CRONFILE"
  (crontab -l; echo "$line" ) | crontab -
fi

#acquire shell session path
SHELLSESSION=$(echo $SHELL)

#check which type of shell is being used
if echo "$SHELLSESSION" | grep -q "bash";
  then
    echo "using bash"
    CONFIG="bashrc"
elif echo "$SHELLSESSION" | grep -q "zsh";
  then
    echo "using zsh"
    CONFIG="zshrc"
fi

#Add alias to shell config file
ALIAS='alias git_off='"$LOCATION"/"$USERFILE"
CONFIGFILE=$(cat ~/.$CONFIG)

if echo "$CONFIGFILE" | grep -q "$ALIAS";
  then
  echo "alias already exists!"
else
  echo "$ALIAS" >> ~/.$CONFIG
  source ~/.$CONFIG
fi





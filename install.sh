#!/bin/bash

#set location variables
LOCATION=$HOME/.git_off
USERFILE="git_off.sh"
CRONFILE="git_check.sh"
PUSHFILE="git_push.sh"
QUEUE="queue.csv"
SSH=$SSH_AUTH_SOCK

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
cp -f $PUSHFILE $LOCATION/
touch $LOCATION/$QUEUE

#check to make sure chron is running
CRONPID=$(pgrep cron)

if [ ${#CRONPID} -gt 0 ];
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
 line="SSH_AUTH_SOCK=$SSH
 */30 * * * * $LOCATION/$CRONFILE"

  # line="*/30 * * * * . $HOME/.profile; $LOCATION/$CRONFILE"
  # line="*/1 * * * * bash -l -c $LOCATION/$CRONFILE"
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

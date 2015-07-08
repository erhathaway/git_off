#!/bin/bash

#set location variables
LOCATION=$HOME/.git_off
USERFILE="git_off.sh"
CRONFILE="git_push.sh"

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

#create tasks
PATTERN="$CRONFILE"
FILE=$(crontab -l)

if echo "$FILE" | grep -q "$PATTERN";
 then
  echo "already a cron job!"
 else
  line="0-59 * * * * $LOCATION/$CRONFILE"
  (crontab -l; echo "$line" ) | crontab -
fi


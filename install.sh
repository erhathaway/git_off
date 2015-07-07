#!/bin/bash

LOCATION=$HOME/.git_off
USERFILE="git_off.sh"
CRONFILE="git_push.sh"

chmod +x $USERFILE
chmod +x $CRONFILE

if [ ! -d "$LOCATION" ]; then
  mkdir $LOCATION
fi

if [ ! -f "$LOCATION/$USERFILE" ]; then
  cp $USERFILE $LOCATION/
fi

if [ ! -f "$LOCATION/$CRONFILE" ]; then
  cp $CRONFILE $LOCATION
fi

CRONTASKS=`crontab -l`
CRONJOB =`grep $CRONFILE $CRONTASKS`

if [ ! -z "$CRONJOB" ]; then
  echo 'already a cron job!'
else
#   #add cron file to cron
  line="* * * * * $LOCATION/$CRONFILE"
  (crontab -l; echo "$line" ) | crontab -
fi


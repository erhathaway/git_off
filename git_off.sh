#!/bin/bash


line="* * * * * /usr/bin/google-chrome"
# (crontab -u userhere -l; echo "$line" ) | crontab -u userhere -
(crontab -l; echo "$line" ) | crontab -
echo "$line"
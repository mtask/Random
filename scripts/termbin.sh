#!/bin/bash

##Send text to pastebin(termbin.com in this case) from terminal
##This script is just to do it more shortly without need to type full syntax

##Usage:
#sudo chmod 755 termbin.sh
#./termbin.sh <file_or_string>

##Optional:
#sudo mv termbin.sh /usr/bin/termbin

if [[ $# = "0" ]]; then
   echo "No file or string to paste"
   exit 0

elif [[ $# = "1" ]]; then
   # check if file or string
   if [[ -f "$1" ]]; then
      cat "$1" | nc termbin.com 9999 2> /dev/null
   else
      echo $1 | nc termbin.com 9999 
   fi
   # Returns link to pasted text
else
   echo "Too many arguments"
fi  


#!/bin/bash

# Simple timedisplay service example
# Ncat comes with nmap package

if [[ $# = "0" ]]; then
   echo "No port given!"
   exit 0
fi

ncat -l "$1" --keep-open --send-only --exec "/bin/date"
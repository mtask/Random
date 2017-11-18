#!/bin/bash

# Author mtask @github.com
# Small network mapper + sport scanner script
# Usage:
# ./lanmap.sh <ip range> <port range>
# Example:
# ./lanmap.sh 10.0.0.1-255 100-200


if [[ $# != "2" ]]; then
   echo "Invalid arguments!"
   exit 0
fi

stripped=$(echo "$1" | awk -F "." '{print $4}')
BASE=$(echo "$1" | awk -F "." '{print $1"."$2"."$3"."}')
START=$(echo "$stripped" | awk -F "-" '{print $1}')
END=$(echo "$stripped" | awk -F "-" '{print $2}')
PORTS="$2"


for ip in $(seq "$START" "$END"); do 
    if [[ $(ping -c 1 -W 1 "$BASE""$ip" | grep icmp* | wc -l) = 1 ]]
    then
        echo -e "$BASE" "$ip" "is up."
        echo "Scanning ports:"
        nc -n -W 1 -zv "$BASE""$ip" "$PORTS" 2>&1 | grep open
    fi
        
done

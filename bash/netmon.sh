#!/bin/bash

#netmon.sh: Log internet connection status while script is running.
#Log  is written in home directory of the user
#Usage:
# #chmod 755 netmon.sh
# $./netmon.sh
#or
# $bash netmon.sh
#
# Check gateway when internet connection down.
# $./netmon.sh -g

file="~/netmon_"$(date +%D.log | tr "/" "_")

help_menu(){
clear
echo "Example usage: ./netmon.sh"
echo "-g check connection to gateway if internet connection down"
exit 0
}


gateway_state(){
gw=$(ip route | awk '/default/ { print $3 }')

if [ $(ping -c 1 $gw | grep icmp* | wc -l) = 0 ];
    then
        while [ $(ping -c 1 -w 2 $gw | grep icmp* | wc -l) = 0 ]
        do
            echo "No connection to gateway"
            sleep 1
            clear
        done
fi
}


if [ $# = 1 ];
then
    if [ $1 =  "-h" ];
    then
        help_menu
    elif [ $1 = "-g" ];
    then
        gw=$2
    fi
fi

#Checks that user has access to ping cmd
permissions="ping: icmp open socket: Operation not permitted"
test_permission=$((ping -c 1 -w 1 127.0.0.1)2>&1)

if [ "$test_permission" = "$permissions" ]; then
   echo -e "[!] No permission to use ping\nexiting.." 
   exit
fi
echo $(date +%H-%M-%S): "[!] Test started" >> $file
while true;
do
    if [ $(ping -c 1 -w 2 google.com | grep icmp* | wc -l) = 1 ]
    then
        clear
        echo "Internet connection is alive"
        sleep 1
        clear
    else
        echo -e "\n"$(date +%H.%M.%S)": Internet connection down" >> $file
        if [ $(ping -c 1 -w 2 8.8.8.8 | grep icmp* | wc -l) = 1 ]
        then
            echo -e "\n"$(date +%H.%M.%S)": Issue with DNS-server" >> $file 
            echo "Possible issues with dns-server"
        else
            if [ $# -gt 0 ] && [ $1 = "-g" ]
            then
               gateway_state
            fi
        fi
        
        while [ $(ping -c 1 -w 2 8.8.8.8 | grep icmp* | wc -l) != 1 ]
        do
            clear
            echo "Internet connection dead"
            sleep 1
            clear
        done
        echo $(date +%H.%M.%S)": Connection back alive" >> $file
    fi
done 



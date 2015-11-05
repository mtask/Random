#!/system/bin/sh

#Get  full package name of application(s)
#sh package_name.sh
#sh package_name.sh [search_word]
#To run through adb: "adb shell" needs to be added in front of pm commands

if [ $# = 0 ]
then
    echo "No package specified"
    echo "Listing all packages..."
    sleep 2
    pm list packages | awk -F ":" '{print $2}'

elif [ $# > 0 ]
then
    if [ $1 = "-h" ] || [ $1 = "--help" ]
    then
        clear
        echo "Search for specific package by app name"
        echo "sh package_name.sh <app name>"
        echo "Get all packages"
        echo "sh package_name.sh"
    
    else
        package=$1
        pm list packages | grep $package | awk -F ":" '{print $2}'
    fi
fi
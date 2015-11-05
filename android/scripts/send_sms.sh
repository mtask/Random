#!/system/bin/sh

#Send text message from terminal
#sh send_sms.sh 0101010101 "Hello world"
#To run through adb: "adb shell" needs to be added in front of am and input commands


if [ $# = 2 ]
then
     number=$1
     msg=$2
     am start -a android.intent.action.SENDTO -d sms:$number --es sms_body $msg --ez exit_on_sent true
     sleep 1
     input keyevent 22 && input keyevent 66
else
    echo "Usage:"
    echo "sh send_sms.sh [number] [\"Message to sent\""]
fi
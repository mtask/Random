#!/bin/bash

# Test mail server with netcat
# ./testsmtp.sh smtp.server.com from@domain.com to@domain.com

mailsend()
{
  nc -C $smtpsrv 25 <<EOF
ehlo $(hostname -f)
MAIL FROM: <$from>
RCPT TO: <$to>
DATA
From: <$from>
To: <$to>
Subject: Testing one two three
"This is only a test. Please do not panic. If this works, then all is well, else all is not well."
"In closing, Lorem ipsum dolor sit amet, consectetur adipiscing elit."
.
quit
EOF
}

smtpsrv="$1"
from="$2"
to="$3"
mailsend

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
Subject: Testing testing
Testing, testing..
.
quit
EOF
}

smtpsrv="$1"
from="$2"
to="$3"
mailsend

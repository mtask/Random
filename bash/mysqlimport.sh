#!/bin/bash

if [[ $1 = "-h" ]] || [[ $1 = "--help" ]]; then
    clear; echo script.sh file.sql.gz suffix database
    exit 0
elif [[ $# -lt "2" ]]; then
    echo "[!] Invalid arguments"
    exit 0
fi
GZ_FILE="$1"
SQL_FILE="${GZ_FILE%.*gz}"
DBSUFFIX="$2"
DB="$3"
 
echo -e "Checking if $GZ_FILE exists\n"
if [[ -f "$GZ_FILE" ]]
then
    echo -e "\n---------------$(date +'%x %r')-----------------------------\n"
    gzip -f -d "$GZ_FILE" || exit 1
    echo -e "[!] Starting to import $SQL_FILE"
    mysql --defaults-group-suffix="$DBSUFFIX" --default-character-set=utf8 -e "source $SQL_FILE" "$DB"  || exit 1
    echo -e "[!] Database import finished"
fi
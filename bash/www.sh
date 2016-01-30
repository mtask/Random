#!/bin/bash

# Quick webserver
# Just pass path to .html file as argument

site="$1"

while true; do nc -l -p 80 -q 1 < $site ; done
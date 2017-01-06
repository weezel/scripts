#!/bin/sh
# Parse bad having users from nginx logs.
# With a bit of shell magic, one can use this script to ban badly having
# gits.

if [ -z "${1}" ]; then
        echo "File missing"
        exit 1
fi

awk '$7 == "/wp-login.php" {print $1}' "${1}" \
        |sort \
        |uniq -c \
        |sort -nrk 1 \
        |awk '$1 > 10'


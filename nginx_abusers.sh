#!/bin/ksh

function usage {
	echo "usage: $0 nginx-log-filename"
	exit 1
}

if [ $# -ne 1 ]; then
	usage
fi

awk '$9 ~ "^40" {ips[$1]++} END {for (i in ips) {print ips[i], i}}' \
	"${1}" \
	|sort -nrk 1

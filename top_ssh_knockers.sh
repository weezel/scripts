#!/bin/sh
# How many times someone knocked your SSH door?

# Openbsd
LOG_FILE="/var/log/authlog"

if [ $(uname -s) = "Linux" ]; then
	# Ubuntu
	LOG_FILE="/var/log/auth.log"

	# Centos
	if [ -r /etc/centos-release ]; then
		LOG_FILE="/var/log/secure"
	fi
fi

awk '$5 ~ "sshd" && $0 ~ "Failed password for invalid user root" {print $(NF-3)}' "${LOG_FILE}" \
        |sort \
        |uniq -c  \
        |awk '$1 > 100 {gsub("([0-9]{1,3})$", "0/24", $2); print $0}' \
        |awk '{ip[$2] += $1} END {for (i in ip) {print ip[i], i}}' \
        |sort -nrk1


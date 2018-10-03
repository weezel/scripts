#!/bin/ksh

WLAN_DEV=$(ifconfig -a |grep -B4 "groups: wlan" |head -n1 |cut -d ':' -f1)
JOINED_WLAN=$(ifconfig ${WLAN_DEV} |awk '/ieee80211:/ {print $3}')
HOME_WLAN=$(cat $HOME/.wlan_ap)
FILES_FROM_PATH="$HOME/.sync_from"

if [ "${JOINED_WLAN}" != "${HOME_WLAN}" ]; then
	exit 1
fi

rsync -aq --files-from="${FILES_FROM_PATH}" --no-relative \
	/ severi.lan:personal

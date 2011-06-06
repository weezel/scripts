#!/bin/sh

CHOICE=3 # Default to Wireless
WIRELESS_DEV=`ifconfig -a|grep -B 3 wlan|head -1|awk '{print $1}'|sed s/\://`
KNOWN_NETWORKS="{"wlaku"; "utapac"; "Wireless"; }"

echo "Reset wireless device ${WIRELESS_DEV}.."
ifconfig ${WIRELESS_DEV} -bssid -chan media autoselect nwid -nwkey -wpa -wpapsk

case $1 in
	1) CHOICE=1;;
	2) CHOICE=2;;
	3) CHOICE=3;;
	0) CHOICE=0;;
	*) echo "\nChoose a network: "
	echo "1) wlaku"
	echo "2) utapac"
	echo "3) Wireless"
	echo "0) Join existing WPA/WPA2 network.."
	echo "q) quit"
	echo ""
	echo "choice > "
	read CHOICE ;;
esac

case $CHOICE in
    1) echo "Trying to join wlaku.." &&
       ifconfig ${WIRELESS_DEV} nwid wlaku wpakey "secret" ;;
    2) echo "Trying to join utapac.." &&
       ifconfig ${WIRELESS_DEV} nwid utapac ;;
    3) echo "Trying to join Wireless.."
       ifconfig ${WIRELESS_DEV} nwid Wireless wpa wpakey "secret" ;;
    0) echo "Scanning networks.." &&
       ifconfig ${WIRELESS_DEV} scan |grep nwid|less &&
       echo "Name of the network > " &&
       read CHOICE &&
       echo "Password > "
       read PASSWORD &&
       ifconfig ${WIRELESS_DEV} nwid ${CHOICE} wpa wpakey "${PASSWORD}" ;;
    q) echo "Exiting.." &&
       exit 1 ;;
    *) echo "Exiting.." &&
       exit 1 ;;
esac

echo "Trying to get lease from the dhcpd.."
dhclient ${WIRELESS_DEV}


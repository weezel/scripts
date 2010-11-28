#!/bin/sh

WIRELESS_DEV=`ifconfig -a|grep -B 3 wlan|head -1|awk '{print $1}'|sed s/\://`

echo "Formatting ${WIRELESS_DEV}.."
ifconfig ${WIRELESS_DEV} -bssid -chan media autoselect nwid -nwkey -wpa -wpapsk

echo "\nChoose a network: "

echo "1) wlaku"
echo "2) utapac"
echo "3) Wireless"
echo "0) Join existing WPA/WPA2 network.."
echo "q) quit"

echo "choice > "
read CHOICE

case $CHOICE in
    1) echo "Trying to join wlaku.." &&
       ifconfig ${WIRELESS_DEV} nwid wlaku wpa wpapsk `wpa-psk wlaku pass` ;;
    2) echo "Trying to join utapac.." &&
       ifconfig ${WIRELESS_DEV} nwid utapac ;;
    3) echo "Trying to join Wireless.."
       ifconfig ${WIRELESS_DEV} nwid Wireless wpa wpakey "pass";;
    0) echo "Scanning networks.." &&
       ifconfig iwn0 scan |grep nwid|less &&
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

echo "Trying to get a lease from the dhcpd.."
dhclient ${WIRELESS_DEV}


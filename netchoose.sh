#!/bin/sh

# TODO:
#   - Automatic login to known network
#   - Use any given interface?
#   - Delete route should be function
#
#   ... after writing those lines I figured out that I'll completely
#       rewrite this.

CHOICE=1
WIRELESS_DEV=`ifconfig -a|grep -B 3 wlan|head -1|awk '{print $1}'|sed s/\://`
WIRED_DEV=re0

echo "Formatting ${WIRELESS_DEV}.."
ifconfig ${WIRELESS_DEV} -bssid -chan media autoselect nwid -nwkey -wpa
echo "Flushing routes.."
OLDCRAP=`route -n show -inet|grep -E "192.168.|10.0.0."|awk '{print $1}'`
route -n flush -iface ${WIRELESS_DEV}
route -n flush -iface ${WIRED_DEV}
for i in ${OLDCRAP[@]}; do
	route -n delete "${i}"
done

case $1 in
	1) CHOICE=1;;
	2) CHOICE=2;;
	3) CHOICE=3;;
	4) CHOICE=4;;
	5) CHOICE=5;;
	9) CHOICE=9;;
	0) CHOICE=0;;
	*) echo "\nChoose a network: "
	echo "1) wlaku"
	echo "2) utapac"
	echo "3) backup"
	echo "4) simppanet"
	echo "5) nakki"
	echo "9) re0"
	echo "0) Join existing WPA/WPA2 network.."
	echo "q) quit"
	echo ""
	echo "choice > "
	read CHOICE ;;
esac

case $CHOICE in
	1) echo "Trying to join wlaku.." &&
	   ifconfig ${WIRELESS_DEV} nwid wlaku wpa wpa wpakey '';;
	2) echo "Trying to join utapac.."
	   ifconfig ${WIRELESS_DEV} nwid utapac
	   sleep 1
	   python $HOME/bin/utalogin.py;;
	3) echo "Trying to join backup.."
	   ifconfig ${WIRELESS_DEV} nwid backup wpa wpakey '';;
	4) echo "Trying to join simppanet.."
	   ifconfig ${WIRELESS_DEV} nwid simppanet wpa wpakey '';;
	5) echo "Trying to join nakki.."
	   ifconfig ${WIRELESS_DEV} nwid nakki wpa wpakey '';;
	9) echo "Will use re0.."
	   ifconfig ${WIRELESS_DEV} down
	   WIRELESS_DEV=re0
	   ifconfig re0 up;;
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
pkill -TERM dhclient
dhclient ${WIRELESS_DEV}


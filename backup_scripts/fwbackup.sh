#!/bin/ksh

basedir="/home/weezel/backup/"
keepmins="1400" # ~ 23.5 h

if [[ $(id -u) -ne 0 ]]; then
	exit 1
fi

curdate=$(date +%d-%m-%Y)

tar -pzcf ${basedir}fw_etc_${curdate}.tgz /etc
tar -pzcf ${basedir}unbound_${curdate}.tgz /var/unbound

chmod -R 660 ${basedir}
chmod 760 ${basedir}
find ${basedir} -type f -cmin +${keepmins} -print0 |xargs -0 rm -f


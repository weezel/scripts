#!/bin/ksh

# On the backup server side, add something like this to cron:
# 30      6       *       *       *       \
#	/usr/local/bin/rsync -qa --delete \
#	fw:/home/username/backup/ /home/username/backup/fw/ >/dev/null 2>&1


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
find ${basedir} -type f -amin +${keepmins} -print0 |xargs -0 rm -f


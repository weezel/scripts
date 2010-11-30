#!/bin/sh

OUTDATED=`/usr/ports/infrastructure/build/./out-of-date |awk '{print $1}'`

echo "Please be patient, following process will take time.."

for pkg in ${OUTDATED[@]}; do
	echo "Do you want to update [y/n]: ${pkg}"
	read CHOICE
	if [$CHOICE = 'y' ]; then
		echo "Will do make update for ${pkg}"
		make update ${pkg}
	else
		continue
	fi
done


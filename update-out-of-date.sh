#!/bin/sh

echo "Please be patient, following process will take time.."

OUTDATED=`/usr/ports/infrastructure/build/./out-of-date |awk '{print $1}'`

for pkg in ${OUTDATED}; do
	echo "Do you want to update [y/n]: ${pkg}"
	read CHOICE
	if [ $CHOICE = 'y' ]; then
		echo "Will do make update for ${pkg}"
		cd /usr/ports/${pkg} && sudo make update
	else
		continue
	fi
done


#!/bin/sh

# The only thing that has to be changed
PREFERRED_CONNECTION="HDMI1"

### YOU ARE DONE, GO AWAY ###

CONNECTED_CNT=$(xrandr |grep -c " connected")

# One screen connected
if [ ${CONNECTED_CNT} -le 1 ]; then
	DEF_SCREEN="$(xrandr|grep '\sconnected'|awk '{print $3}')"
	WIDTH=`echo "${DEF_SCREEN}" |cut -f 1 -d '+' |cut -f 1 -d 'x'`
	HEIGHT=`echo "${DEF_SCREEN}" |cut -f 1 -d '+' |cut -f 2 -d 'x'`
# Multiple screens found
else
	DEF_SCREEN=$(xrandr |awk "/${PREFERRED_CONNECTION}/"'{print $3}')

	# Is preferred screen set?
	if [ -z ${PREFERRED_CONNECTION} ]; then
		# How many screens connected
		CONNECTED_SCREENS=`xrandr |awk '/ connected/ {print $1}'`

		echo "Found screens:"
		for i in ${CONNECTED_SCREENS[@]}; do echo ${i}; done

		echo ""
		echo "Value for PREFERRED_CONNECTION is not set. Pick one from the above and set the value in pivot_toggle.sh"
		exit 1
	else
		DEF_SCREEN=`xrandr |awk "/${PREFERRED_CONNECTION}/"'{print $3}'`
		WIDTH=`xrandr | grep "${DEF_SCREEN}" |awk '{print $3}' |cut -f 1 -d '+' |cut -f 1 -d 'x'`
		HEIGHT=`xrandr |grep "${DEF_SCREEN}" |awk '{print $3}' |cut -f 1 -d '+' |cut -f 2 -d 'x'`
	fi
fi

# Toggle portrait
if [ ${WIDTH} -gt ${HEIGHT} ]; then
	xrandr --output `xrandr |grep "${DEF_SCREEN}" |awk '{print $1}'` --rotate left
else
	xrandr --output `xrandr |grep "${DEF_SCREEN}" |awk '{print $1}'` --rotate normal
fi

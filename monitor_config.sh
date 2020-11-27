#!/usr/bin/env bash

set -euxo pipefail

# $ cat ~/.screenconfig
# _laptop="eDP1"
# _primary="DP2-2"
# _secondary="DP2-1"

. ~/.screenconfig

_monitorcount=$(xrandr |grep -c " connected")
case "${_monitorcount}" in
1)
	xrandr --output ${_laptop} --dpi 120 --auto --primary
	;;
2)
	xrandr --output ${_laptop} --off \
		--output ${_primary} --dpi 120 --auto --primary
	xinput --set-prop "Synaptics TM3075-002" "Device Accel Profile" 1
	xset mouse 100 5
	synclient HorizTwoFingerScroll=1
	synclient HorizScrollDelta=15
	synclient PalmDetect=1
	synclient PalmMinWidth=15
	synclient PalmMinZ=30
	synclient TapButton1=0
	synclient TapButton2=0
	synclient TapButton3=0
	# Keyboard related
	xset b off
	xset r rate 300 30
	setxkbmap -layout us,fi -option grp:caps_toggle
	;;
3)
	xrandr --output ${_laptop} --off \
		--output ${_primary} --auto --primary \
		--output ${_secondary} --auto --rotate right \
		--right-of ${_primary}
	;;
esac


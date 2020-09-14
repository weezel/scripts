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
		--output ${_primary} --auto --primary
	;;
3)
	xrandr --output ${_laptop} --off \
		--output ${_primary} --auto --primary \
		--output ${_secondary} --auto --rotate right \
		--right-of ${_primary}
	;;
esac


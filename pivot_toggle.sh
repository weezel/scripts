#!/bin/sh

WIDTH=`xrandr |grep HDMI |awk '{print $3}' |cut -f 1 -d '+' |cut -f 1 -d 'x'`
HEIGHT=`xrandr |grep HDMI |awk '{print $3}' |cut -f 1 -d '+' |cut -f 2 -d 'x'`

if [ ${WIDTH} -gt ${HEIGHT} ]; then
	xrandr --output `xrandr |grep HDMI|awk '{print $1}'` --rotate left
else
	xrandr --output `xrandr |grep HDMI|awk '{print $1}'` --rotate normal
fi

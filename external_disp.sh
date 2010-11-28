#!/bin/sh

ORIENTATION=""
#PRIMARY_DISP="LVDS1"
#EXTERNAL_DISP="VGA1"

echo "Connected displays:"
xrandr|grep -E "\bconnected\b"|awk '{print $1}'

case $2 in
o)
	xrandr --output $1 --off
	exit
;;
esac

case $3 in
l)
	ORIENTATION="--left-of"
;;
r)

	ORIENTATION="--right-of"
;;
a)

	ORIENTATION="--above"
;;
b)

	ORIENTATION="--below"
;;
s)

	ORIENTATION="--same-as"
;;
*)
	echo ""
	echo "Usage:"
	echo "external_disp.sh PRIMARY_DISP EXTERNAL_DISP ORIENTATION"
	echo ""
	echo "Or to switch off external monitor: "
	echo "external_disp.sh EXTERNAL_DISPLAY o"
	echo ""
	echo "Display orientation"
	echo "(l)eft"
	echo "(r)ight"
	echo "(a)bove"
	echo "(b)elow"
	exit
;;
esac

# finally set the screens
#xrandr --output $PRIMARY_DISP --primary --auto --output $EXTERNAL_DISP --auto --output $EXTERNAL_DISP $ORIENTATION $PRIMARY_DISP
xrandr --output $1 --auto --output $2 --primary --auto --output $2 $ORIENTATION $1


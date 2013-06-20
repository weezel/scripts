#!/bin/sh

PRIMARY_DISP="LVDS1"
EXTERNAL_DISP=$(xrandr -q |grep " connected" |grep -v ${PRIMARY_DISP} | awk '{print $1}')
set -A DISP_OPTIONS '(d)ouble_monitors' '(m)onitor' '(p)rojector' '(t)elevision' '(r)eset'

printf "Connected ports: %s, %s\n\n" "${PRIMARY_DISP}" "${EXTERNAL_DISP}"

echo "Which external display to use?"
for o in ${DISP_OPTIONS[@]}; do
	echo ${o}
done

printf "> "
read CHOICE

case ${CHOICE} in
d)
	xrandr --output ${PRIMARY_DISP} --auto \
		--output ${EXTERNAL_DISP} --auto --right-of ${PRIMARY_DISP}
;;
m)
	xrandr --output ${PRIMARY_DISP} --off \
		--output ${EXTERNAL_DISP} --auto
;;
p)
	xrandr --output ${PRIMARY_DISP} --auto \
		--output ${EXTERNAL_DISP} --mode 1280x720 --rate 60.0
		#--set audio force-dvi --above ${PRIMARY_DISP}
;;
t)
	xrandr --output ${PRIMARY_DISP} --auto \
		--output ${EXTERNAL_DISP} --mode 1280x720 --rate 60.0 \
		--set audio force-dvi --above ${PRIMARY_DISP}
;;
r)
	xrandr --output ${PRIMARY_DISP} --auto \
		--output ${EXTERNAL_DISP} --off
;;
*)
	echo "'${CHOICE}' is not an option."
	return 1
;;
esac

return 0

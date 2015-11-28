#!/bin/sh

PRIMARY_DISP="eDP1"
EXTERNAL_DISP=$(xrandr -q |awk '$2 ~ "^connected$" {print $1}' | \
		grep -v "${PRIMARY_DISP}")
set -A DISP_OPTIONS '(m)irrored' '(p)rimary_monitor_only' \
		    '(s)triped_mode' '(r)eset'

printf "PRIMARY display : %8s\n" "${PRIMARY_DISP}"
printf "EXTERNAL display: %8s\n\n" "${EXTERNAL_DISP}"

echo "Which display mode to use?"
for o in ${DISP_OPTIONS[@]}; do
	echo ${o}
done

printf "> "
read CHOICE

case ${CHOICE} in
m)
	xrandr --output ${PRIMARY_DISP} --auto \
		--output ${EXTERNAL_DISP} --auto --same-as "${PRIMARY_DISP}"
;;
p)
	xrandr --output ${PRIMARY_DISP} --off \
		--output ${EXTERNAL_DISP} --auto
;;
s)
	xrandr --output ${PRIMARY_DISP} --auto \
		--output ${EXTERNAL_DISP} --auto --right-of "${PRIMARY_DISP}"
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

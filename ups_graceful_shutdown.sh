#!/bin/ksh

# /etc/sensorsd.conf bits:
# # Shutdown the systems when we're running out of power
#hw.sensors.upd0.percent0:low=50:command=USERNAME=foo REMOTE_IP=bar REMOTE_USER=baz /home/weezel/scripts/ups_graceful_shutdown.sh

username="${USERNAME}"
remote_ip="${REMOTE_IP}"
remote_user="${REMOTE_USER}"

# XXX Remember to test that SSH authentication works!

# Is AC present?
ac_present=$(sysctl -n hw.sensors.upd0.indicator5 |grep -Ec "^On")
# Capacity left in percents
capa_perc=$(sysctl -n hw.sensors.upd0.percent0 |grep -o "^[0-9].*\." |tr -d .)

if [ "${ac_present}" -eq 0 ] && [ "${capa_perc}" -lt 30 ]; then
        logger "CRITICAL: Running out of power, shutting down"
        ssh -i "/home/${username}/.ssh/id_ed25519" \
		"${remote_user}@${remote_ip}" doas halt -p &
        halt -p
fi

#!/bin/ksh

# To be used with logfmon or similar monitoring software.
# Poor man's version can be run on via cron.

hosts=$(awk '/perl |bash|.sh|.php([0-9])?|wget |curl / {print $1}' /var/www/logs/access.log \
	|sort \
	|uniq)
hosts_list=${hosts} | xargs

pfctl -t blacklist -T add ${hosts_list}
for h in ${hosts}; do
	printf "%s --> "  ${h}
	pfctl -k ${h}
done

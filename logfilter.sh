#!/bin/ksh

#sed -e 's/^.*fw //' -e 's/\[[0-9]*\]//' /var/log/daemon \
sed -e 's/^.*fw //' -e 's/\[[0-9]*\]//' /home/fw/a/daemon.0
        |egrep -v -f $HOME/logfilter.grep \
        |sort \
        |uniq -c \
        |sort -rnk 1


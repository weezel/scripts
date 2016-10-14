#!/bin/sh

if [ $# -ne 1 ]; then
	echo "usage: $0 hostnamefile"
	exit 1
fi

tmux new-session -s maintenance -d

for hname in $(grep -v "^#" "${1}"); do
        tmux send-keys "ssh $hname" C-m
        tmux split-window
        tmux select-layout even-vertical
done

tmux kill-pane
tmux select-layout even-vertical
tmux attach-session -t maintenance
tmux set synchronize-panes on


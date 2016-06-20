#!/bin/bash

tmux new-session -s maintenance -d

for hname in $(cat machinehostlist.txt); do
        tmux send-keys "ssh $hname" C-m
        tmux split-window
        tmux select-layout even-vertical
done

tmux kill-pane
tmux select-layout even-vertical
tmux attach-session -t maintenance
tmux set synchronize-panes on


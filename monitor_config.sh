#!/usr/bin/env bash

set -euxo pipefail

# Read monitor related configurations from the file.
# This makes it possible to run certain commands when
# certain screen setup is attached.

readonly monitorcount=$(xrandr |grep -c " connected")
case "${monitorcount}" in
1)
	. "${HOME}/.screenconfig_1"
	;;
2)
	. "${HOME}/.screenconfig_2"
	;;
esac


#!/bin/sh

BASE_DIR="${HOME}/screenlayout"

function usage
{
	echo "usage: $0 [save|restore]"
	exit 1
}

function store
{
	for i in $(jot 10 1); do
		i3-save-tree --workspace="${i}" 2>/dev/null \
			| sed 's/\/\/ \"title/\"title/g' \
			> "${BASE_DIR}/${i}" &
	done
}

function restore
{

	for i in $(jot 10 1); do
		i3-msg "workspace ${i}; append_layout ${BASE_DIR}/${i}"
		#rm -f "${BASE_DIR}/${i}"
	done
}

[ $# -ne 1 ] && usage

[ -d "${BASE_DIR}" ] || mkdir -p "${BASE_DIR}"

case "${1}" in
store)
	store
	;;
restore)
	restore
	;;
*)
	usage
	;;
esac


#!/bin/sh

url="http://ftp.eu.openbsd.org/pub/OpenBSD/snapshots/"
arch="$(uname -p)"
dirname="$(date +%d-%m-%Y)"

echo -n "" >filelist.txt

if [ -d ${dirname} ]; then
	printf "Directory '%s' exist, remove it (y/n)?\n" ${dirname}
	read q

	case $q in
	y|yes)	rm -rf "${dirname}" ;;
	*)	printf "No changes..\n" && exit 0;;
	esac
fi

mkdir "${dirname}"

fetchlist="$(lynx -source "${url}${arch}/index.txt" \
	|egrep -v '.iso$|.fs$|cdboot$|cdbr$|game[0-9]{2}.tgz$' \
	|awk '/^-/ {print $NF}')"

OFS=$IFS
IFS=$'\n'
printf "${fetchlist}\n" | while read -r item; do
	printf "%s%s/%s\n" "${url}" "${arch}" "${item}" >>filelist.txt
done
IFS=$OFS

# Multithreaded mode
cd "${dirname}"
xargs -P 6 -n1 ftp -C < ../filelist.txt

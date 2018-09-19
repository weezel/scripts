#!/bin/ksh

set -e

arch="$(uname -p)"
dirname="$(date +%d-%m-%Y)"

if [[ $1 = "local" ]]; then
	url="http://severi.lan/update/${dirname}"
	url_arch="${url}/"
else
	url="http://ftp.eu.openbsd.org/pub/OpenBSD/snapshots/"
	url_arch="${url}${arch}/"
fi


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

fetchlist="$(lynx -source "${url_arch}/index.txt" \
	|egrep -v '.?(iso|fs|cdboot|cdbr)$' \
	|awk '/^-/ {print $NF}')"

OFS=$IFS
IFS=$'\n'
printf "${fetchlist}\n" | while read -r item; do
	printf "%s/%s\n" "${url_arch}" "${item}" >>filelist.txt
done
IFS=$OFS

# Multithreaded mode
cd "${dirname}"
xargs -P 6 -n1 ftp -C < ../filelist.txt

echo "Copy bsd.rd to /bsdrd.new"
doas cp "$(pwd)/bsd.rd" /bsdrd.new

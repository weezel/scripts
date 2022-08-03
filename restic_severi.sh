#!/bin/ksh

readonly restic_bin=/usr/local/bin/restic
readonly restic_repo="/backup/severi"

$restic_bin -r $restic_repo \
	--password-file=/root/.backuppass \
	unlock

# Purge old entries
$restic_bin -r $restic_repo \
	forget \
	--password-file=/root/.backuppass \
	--keep-daily 7 \
	--keep-weekly 4 \
	--keep-monthly 3 \
	--prune

# Do backup
$restic_bin -r $restic_repo \
	backup -x \
	--exclude-file=/root/severi_excludes.txt \
	--password-file=/root/.backuppass \
	/etc \
	/home \
	/var


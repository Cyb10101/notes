#!/usr/bin/env bash

ramDisk='/mnt/ramdisk'
ramDiskBackup='/mnt/ramdisk_backup'
ramSize='2G'
ramUser='cyb10101'

isRamDiskMounted() {
	if grep -qs ${ramDisk} /proc/mounts; then
		return 0; # true
	else
		return 1; # false
	fi
}

start() {
	if ! isRamDiskMounted; then
		mkdir -p ${ramDisk} && \
			mkdir -p ${ramDiskBackup} && \
			mount -t tmpfs -o rw,size=${ramSize} tmpfs ${ramDisk} && \
			chown -Rf ${ramUser} ${ramDisk}
	fi
	if ! isRamDiskMounted; then
		echo '[ERROR] Can not create RAM Disk'
		exit 1;
	fi

	if [ -d ${ramDiskBackup} ]; then
		rsync -a ${ramDiskBackup}'/' ${ramDisk}'/'
		chown -Rf ${ramUser} ${ramDisk}
	fi
}

stop() {
	if isRamDiskMounted; then
		if [ -d ${ramDiskBackup} ]; then
			rsync -a ${ramDisk}'/' ${ramDiskBackup}'/'
			chown -Rf ${ramUser} ${ramDiskBackup}
		fi
		umount ${ramDisk}
	fi

	if isRamDiskMounted; then
		echo '[ERROR] Can not remove RAM Disk'
		exit 1;
	fi
}

status() {
	if isRamDiskMounted; then
		echo 'RAM Disk is mounted.';
	else
		echo 'RAM Disk is not mounted.';
	fi
}

case "$1" in
start)
    start
    ;;
stop)
    stop
    ;;
restart)
    stop && start
    ;;
force-reload)
    stop
    start
    ;;
status)
    status
    ;;
*)
    echo "Usage: $0 {start|stop|restart|force-reload|status}"
    exit 1
esac

exit 0

#!/usr/bin/env bash
# ~/Sync/notes/System/Linux/RamDisk/ramdisk.sh start 5G
# ~/Sync/notes/System/Linux/RamDisk/ramdisk.sh stop
ramDisk='/mnt/ramdisk'
ramDiskBackup='/mnt/ramdisk_backup'
ramUser='cyb10101'

isRamDiskMounted() {
    if mountpoint -q ${ramDisk}; then
        return 0; # true
    else
        return 1; # false
    fi
}

start() {
    ramSize='1G'
    if [[ ! -z "${1}" ]]; then
        ramSize="${1}"
    fi

    if ! isRamDiskMounted; then
        sudo mkdir -p ${ramDisk} && \
            sudo mkdir -p ${ramDiskBackup} && \
            sudo mount -t tmpfs -o rw,size=${ramSize} tmpfs ${ramDisk} && \
            sudo chown -Rf ${ramUser} ${ramDisk}
    fi
    if ! isRamDiskMounted; then
        echo '[ERROR] Can not create RAM Disk'
        exit 1;
    fi

    if [ -d ${ramDiskBackup} ]; then
        sudo rsync -a ${ramDiskBackup}'/' ${ramDisk}'/'
        sudo chown -Rf ${ramUser} ${ramDisk}
    fi

    xdg-open ${ramDisk} &
}

stop() {
    if isRamDiskMounted; then
        if [ -d ${ramDiskBackup} ]; then
            sudo rsync -a --delete ${ramDisk}'/' ${ramDiskBackup}'/'
            sudo chown -Rf ${ramUser} ${ramDiskBackup}
        fi
        sudo umount ${ramDisk}
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
    start "${2}"
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

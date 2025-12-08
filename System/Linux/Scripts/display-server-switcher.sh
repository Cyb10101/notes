#!/usr/bin/env bash

# Exit on error
#set -e

# Elevate script permission
# Maybe: --preserve-env or -E for
# Indicates to the security policy that the user wishes to preserve their existing environment variables.
# The securitypolicy may return an error if the user does not have permission to preserve the environment.
if [ ! -z "$DISPLAY" ]; then
    echo "X11 GUI session"
    [ "${EUID}" -eq 0 ] || DISPLAY=$DISPLAY exec pkexec "${0}" "$@"
else
    [ "${EUID}" -eq 0 ] || DISPLAY=$DISPLAY exec sudo "${0}" "$@"
fi

# exec sudo -E "$0" ${1+"$@"}

# Useful for script
scriptPath="$(cd "$(dirname "${0}")" >/dev/null 2>&1; pwd -P)"

textColor() {
    echo -e "\033[0;3${1}m${2}\033[0m"
}

canNotifySendAsRoot() {
    local display=":$(ls /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"
    local user=$(who | grep '('$display')' | awk '{print $1}' | head -n 1)
    local uid=$(id -u $user)
    if [ ! -z "$display" ] && [ ! -z "$user" ] && [ ! -z "$uid" ]; then
        echo 1;
    fi
}

notifySendAsRoot() {
    local display=":$(ls /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"
    local user=$(who | grep '('$display')' | awk '{print $1}' | head -n 1)
    local uid=$(id -u $user)
    sudo -u $user DISPLAY=$display DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus notify-send "$@"
}

notifyUser() {
    if [ ! -z "$(canNotifySendAsRoot)" ]; then
        notifySendAsRoot -u normal -t 300 -i gtk-dialog-info 'Display server switcher' "${1}"
    else
        echo "${1}"
    fi
}

# Script #######################################################################
checkWayland=$(crudini --get /etc/gdm3/custom.conf daemon WaylandEnable)
if [ "$?" -ne "0" ] || [ "${checkWayland}" == "true" ]; then
    notifyUser 'Wayland -> X11'
    sudo sed -i -r "s/^#?(\s+)?(WaylandEnable=false)$/\2/g" /etc/gdm3/custom.conf
else
    notifyUser 'X11 -> Wayland'
    sudo sed -i -r "s/^WaylandEnable=false$/#\0/g" /etc/gdm3/custom.conf
fi

echo ''
echo 'Current configuration:'
grep 'WaylandEnable' /etc/gdm3/custom.conf
echo ''

echo 'Reboot needed! Or log off'
sleep 5

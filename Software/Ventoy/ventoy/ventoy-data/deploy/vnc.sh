#!/bin/bash
PID=$(pgrep 'x11vnc')
if [ "$?" -ne "0" ]; then
    x11vnc -nopw -bg -localhost -quiet -forever
fi
/usr/share/novnc/utils/launch.sh

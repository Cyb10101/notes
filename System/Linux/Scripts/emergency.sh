#!/usr/bin/env bash
# Easy script for: If something happen, do something

# Elevate script permission
[ "${EUID}" -eq 0 ] || exec sudo "${0}" "$@"

# Useful for script
scriptPath="$(cd "$(dirname "${0}")" >/dev/null 2>&1; pwd -P)"

echo 'Emergency shutdown script running...'
while :; do
    if [[ $(ls -1 | wc -l) -gt 100 ]]; then
        echo 'EMERGENCY: Too much files!'
        #shutdown -h now 'Emergency script: Too much files!'
        exit 1
    fi

    echo -n '.'
    sleep 3
done

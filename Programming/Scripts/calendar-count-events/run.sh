#!/usr/bin/env bash
set -e # Exit on error

# Functions ####################################################################
scriptPath="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"; cd "$scriptPath" || exit 1
venvPath="$HOME/opt/count_calendar_events"

# Script #######################################################################
installOrUpgrade() {
  echo "Installing requirements ..."
  "${venvPath}/venv/bin/python" -m pip install -r requirements.txt
}

if [ ! -d "$venvPath" ]; then
  mkdir -p "$venvPath"
fi

if [ -d "${venvPath}/venv" ]; then
  source "${venvPath}/venv/bin/activate"
else
  python3 -m venv "${venvPath}/venv"
  source "${venvPath}/venv/bin/activate"
  installOrUpgrade
  echo ''
fi

exec "${venvPath}/venv/bin/python" count_calendar_events.py "${@:1}"

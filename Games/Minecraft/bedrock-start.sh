#!/usr/bin/env bash

# Hover url on download button to get version https://www.minecraft.net/de-de/download/server/bedrock
# @todo Automatic version would be nice > json, parse html, other
VERSION='1.21.62.01'

# Open Firefox, Strg + Shift + K, Run in Console: alert(window.navigator.userAgent);
USER_AGENT='User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:134.0) Gecko/20100101 Firefox/134.0'

# Functions ####################################################################
scriptPath="$(cd "$(dirname "${0}")" >/dev/null 2>&1; pwd -P)"

textColor() {
    echo -e "\033[0;3${1}m${2}\033[0m"
}

checkCurlInstalled() {
  if ! command -v curl &>/dev/null; then
    textColor 3 "# Install: Curl"
    sudo apt update
    sudo apt -y install curl
  fi
  if ! command -v curl &>/dev/null; then
    textColor 1 "Curl is not installed. Aborting!"
    exit 1;
  fi
}

# Script #######################################################################
run() {
  LD_LIBRARY_PATH=. exec ./bedrock_server
}

backup() {
  BACKUP_FILE="$(date +%Y-%m-%d_%H-%M-%S).tar.gz"
  if [ ! -d "backup" ]; then
    mkdir backup
  fi
  if [ ! -f "backup/$BACKUP_FILE" ]; then
    textColor 2 "Create backup 'backup/$BACKUP_FILE' ..."
    tar -zcf "backup/$BACKUP_FILE" \
      --exclude=backup \
      --exclude=bedrock-server.zip \
      ./
  fi
  if [ ! -f "backup/$BACKUP_FILE" ]; then
    textColor 1 'Error: Backup not created!'; exit 1
  fi
}

downloadServer() {
  if [ -f bedrock-server.zip ]; then
    rm bedrock-server.zip
  fi
  if [ ! -f bedrock-server.zip ]; then
    textColor 2 "Download server $VERSION ..."
    curl --progress-bar -o bedrock-server.zip -H "$USER_AGENT" -fL "https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-${VERSION}.zip"
    if [ ! -f bedrock-server.zip ]; then
      textColor 1 'Error: Server not downloaded!'; exit 1
    fi
  fi
}

installServer() {
  read -p 'Do you want install a new server? [y/N] ' -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    textColor 1 "Installation aborted!"
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
  fi

  downloadServer
  textColor 2 'Extract server ...'
  unzip -q -o bedrock-server.zip

  if [ -f bedrock-server.zip ]; then
    rm bedrock-server.zip
  fi
}

updateServer() {
  backup
  downloadServer
  textColor 2 'Extract server ...'
  unzip -q -o bedrock-server.zip -x 'worlds/*' 'allowlist.json' 'permissions.json' 'server.properties' 'whitelist.json'

  if [ -f bedrock-server.zip ]; then
    rm bedrock-server.zip
  fi
}

startFunction() {
  case ${1} in
    run)
      run
    ;;
    backup)
      backup
    ;;
    install)
      installServer
    ;;
    update)
      updateServer
    ;;
    *)
      echo "${0} run     = Start server"
      echo "${0} backup  = Create a backup"
      echo "${0} update  = Update server"
      echo "${0} install = Install server"
    ;;
  esac
}

cd "${scriptPath}"
checkCurlInstalled
startFunction "${@:1}"
exit $?

#!/usr/bin/env bash

# docker image prune -a
# docker ps --filter "status=exited" --format "table {{.ID}}\t{{.Image}}\t{{.Status}}"

# nextcloud
# vim docker-compose.yml
# grep 'version' /root/projects/nextcloud/.docker/nextcloud/config/config.php

# Useful for script
scriptPath="$(cd "$(dirname "${0}")" >/dev/null 2>&1; pwd -P)"

textColor() {
  echo -e "\033[0;3${1}m${2}\033[0m"
}

checkDialogInstalled() {
  if ! hash dialog 2>/dev/null; then
    echo "Dialog is not installed!";
    sudo apt install dialog
  fi
  if ! hash dialog 2>/dev/null; then
    echo "Dialog is not installed. Aborting!";
    exit 1;
  fi
}

# Script #######################################################################
getDirectories() {
  directories=(
    global
    mail
    nextcloud

    $(ls -d */ | sed 's/\/$//' | grep -E '^\.\/user_.*$' | sort)
    $(ls -d */ | sed 's/\/$//' | grep -Ev '^\.\/(global|mail|nextcloud|user_.*)$' | sort)
  )
  echo "${directories[@]}"
}

eachDirectory() {
  local command=${1}
  shift
  local directories=("$@")
  for directory in "${directories[@]}"; do
    if [ -d "${directory}" ]; then
      textColor 2 "# ${directory}"
      cd "${directory}"
      eval ${command}
      cd ..
    else
      textColor 1 "# Error: Directory '${directory}' not found!"
    fi
    done
}

startOrDockerCompose() {
  if [ -f "start.sh" ]; then
    ./start.sh "$@"
  else
    docker-compose "$@"
  fi
}

checkGitMaster() {
    if [[ $(git symbolic-ref --short -q HEAD) != 'master' ]]; then
        echo 'ERROR: Git is not on branch master!'
        return 1;
    fi
    return 0;
}

checkGit() {
    if [[ $(git diff --stat) != '' ]]; then
        echo; git status --short; echo
        printf "Git is dirty...\n";
        return 1;
    fi
    return 0;
}

menu() {
  selected=`dialog --clear --backtitle "Projects" --no-tags --menu "Menu" 0 0 0 \
    "projectStatus"           "Show docker status" \
    "projectPull"             "Pull docker images" \
    "projectStart"            "Start server (start: pull, build, up)" \
    "projectUp"               "Start server (up)" \
    "projectDown"             "Stop server" \
    "projectRestart"          "Restart server (restart)" \
    "projectRestartUpDown"    "Restart server (down + up)" \
    "projectGitDirty"         "Git: Show if git is dirty" \
    "projectWebsiteUrls"      "Get website urls" \
   3>&1 1>&2 2>&3`
  clear
  echo ""
  if [[ "${selected}" == "" ]]; then
    exit 0
  fi
  ${selected}
}

projectStatus() {
  directories=( $(getDirectories) )
  eachDirectory 'startOrDockerCompose ps' "${directories[@]}"
}

projectPull() {
  directories=( $(getDirectories) )
  eachDirectory 'startOrDockerCompose pull' "${directories[@]}"
}

projectStart() {
  directories=( $(getDirectories) )
  eachDirectory 'startOrDockerCompose start' "${directories[@]}"
}

projectUp() {
  directories=( $(getDirectories) )
  eachDirectory 'startOrDockerCompose up' "${directories[@]}"
}

projectDown() {
  directories=( $(getDirectories) )
  directories=( $(printf '%s\n' "${directories[@]}" | tac | tr '\n' ' '; echo) ) # Reverse array
  eachDirectory 'startOrDockerCompose down' "${directories[@]}"
}

projectRestart() {
  directories=( $(getDirectories) )
  eachDirectory 'startOrDockerCompose restart' "${directories[@]}"
}

projectRestartUpDown() {
  directories=( $(getDirectories) )
  eachDirectory 'startOrDockerCompose down && startOrDockerCompose up' "${directories[@]}"
}

projectGitDirty() {
  directories=( $(getDirectories) )
  eachDirectory 'checkGitMaster && checkGit' "${directories[@]}"
}

projectWebsiteUrls() {
  directories=( $(getDirectories) )
  eachDirectory 'projectWebsiteUrlsCommand' "${directories[@]}"
}
projectWebsiteUrlsCommand() {
  local developmentSuffix=''
  #if [ "$(isContextDevelopment)" == "1" ]; then
  #  developmentSuffix='.dev'
  #fi

  DOCKER_COMPOSE_FILE="compose${developmentSuffix}.yaml"
  if [ -e "compose${developmentSuffix}.yml" ]; then
    DOCKER_COMPOSE_FILE="compose${developmentSuffix}.yml"
  elif [ -e "docker-compose${developmentSuffix}.yaml" ]; then
    DOCKER_COMPOSE_FILE="docker-compose${developmentSuffix}.yaml"
  elif [ -e "docker-compose${developmentSuffix}.yml" ]; then
    DOCKER_COMPOSE_FILE="docker-compose${developmentSuffix}.yml"
  fi

  if [ -e "${DOCKER_COMPOSE_FILE}" ]; then
    local traefikHosts=$(yq -r '.services[].labels | select(. != null) | .[] | split("=") | select(.[0] | match("traefik\\.http\\.routers\\..*\\.rule")) | .[1]' "${DOCKER_COMPOSE_FILE}" | grep -Po '(?<=Host\(`)([^`]+)(?=`\))')
    if [[ ! -z "${traefikHosts[@]}" ]]; then
      IFS=' ' read -ra traefikHosts <<< "$(echo ${traefikHosts[@]})"
    else
      traefikHosts=()
    fi

    local virtualHosts=$(yq -r '.services[].environment | select(. != null) | .[] | split("=") | select(.[0] == "VIRTUAL_HOST") | .[1]' "${DOCKER_COMPOSE_FILE}")
    if [ ! -z "${virtualHosts}" ]; then
      IFS=',' read -ra virtualHosts <<< "${virtualHosts}"
    else
      virtualHosts=()
    fi

    local websites=("${traefikHosts[@]}" "${virtualHosts[@]}")
    IFS=" " read -ra websites <<< "$(echo "${websites[@]}" | tr ' ' '\n' | sort -u | grep -vE '^www\.' | tr '\n' ' ')"
    for website in "${websites[@]}"; do
      echo "  - https://${website}"
    done
  fi
}

checkDialogInstalled
menu

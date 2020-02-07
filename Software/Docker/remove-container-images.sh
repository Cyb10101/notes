#!/usr/bin/env bash

# Delete all exitet container
#docker rm $(docker ps -a -f status=exited -q)

colorRed='\033[0;31m'
colorGreen='\033[0;32m'
colorYellow='\033[0;33m'
colorReset='\033[0m'

if [[ $EUID -ne 0 ]]; then
  echo -e "${colorYellow}You should be a root user!${colorReset}"
fi

if [ ! -f /usr/bin/docker ]; then
  echo -e "${colorRed}Docker not found!${colorReset}"
  exit 1;
fi

# Delete all container
container=$(docker ps -a -q)
if [ ${#container[@]} != 0 ] && [ "${container[@]}" != "" ]; then
  docker rm ${container[@]}
fi

# Delete all images
images=$(docker images -q)
if [ ${#images[@]} != 0 ] && [ "${images[@]}" != "" ]; then
  if [ "${1}" == "-f" ]; then
    docker rmi -f ${images[@]}
  else
    docker rmi ${images[@]}
  fi
fi

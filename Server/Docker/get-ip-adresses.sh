#!/usr/bin/env bash

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

for container in $(docker ps -q); do
  ip=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${container})
  name=$(docker inspect --format='{{.Name}}' ${container})
  echo -e "${ip}\t\t${name}";
done

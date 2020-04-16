#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
APPLICATION_UID=${APPLICATION_UID:-1000}
APPLICATION_GID=${APPLICATION_GID:-1000}
APPLICATION_USER=${APPLICATION_USER:-application}
APPLICATION_GROUP=${APPLICATION_GROUP:-application}

# Fix special user permissions
#if [ "$(id -u)" != "1000" ]; then
#    grep -q '^APPLICATION_UID_OVERRIDE=' .env && sed -i 's/^APPLICATION_UID_OVERRIDE=.*/APPLICATION_UID_OVERRIDE='$(id -u)'/' .env || echo 'APPLICATION_UID_OVERRIDE='$(id -u) >> .env
#    grep -q '^APPLICATION_GID_OVERRIDE=' .env && sed -i 's/^APPLICATION_GID_OVERRIDE=.*/APPLICATION_GID_OVERRIDE='$(id -g)'/' .env || echo 'APPLICATION_GID_OVERRIDE='$(id -g) >> .env
#fi;

# Load environment file
if [ -f .env ]; then
  source .env
fi
if [ -f .env.local ]; then
  source .env.local
fi

# Select docker compose file
DOCKER_COMPOSE_FILE=docker-compose.yml

function startFunction {
    case ${1} in
        start)
            startFunction pull && \
            startFunction build && \
            startFunction up
        ;;
        up)
            docker-compose --project-directory "${SCRIPTPATH}" -f "${SCRIPTPATH}/${DOCKER_COMPOSE_FILE}" up -d
        ;;
        down)
            docker-compose --project-directory "${SCRIPTPATH}" -f "${SCRIPTPATH}/${DOCKER_COMPOSE_FILE}" down --remove-orphans
        ;;
        *)
            docker-compose --project-directory "${SCRIPTPATH}" -f "${SCRIPTPATH}/${DOCKER_COMPOSE_FILE}" "${@:1}"
        ;;
    esac
}

startFunction "${@:1}"
exit $?

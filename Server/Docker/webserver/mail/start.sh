#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Fix special user permissions
#if [ "$(id -u)" != "1000" ]; then
#    grep -q '^APPLICATION_UID_OVERRIDE=' .env && sed -i 's/^APPLICATION_UID_OVERRIDE=.*/APPLICATION_UID_OVERRIDE='$(id -u)'/' .env || echo 'APPLICATION_UID_OVERRIDE='$(id -u) >> .env
#    grep -q '^APPLICATION_GID_OVERRIDE=' .env && sed -i 's/^APPLICATION_GID_OVERRIDE=.*/APPLICATION_GID_OVERRIDE='$(id -g)'/' .env || echo 'APPLICATION_GID_OVERRIDE='$(id -g) >> .env
#fi;

# Load environment file
if [ -f .env ]; then
  source .env
fi

# Select docker compose file
DOCKER_COMPOSE_FILE=docker-compose.yml

dockerCompose() {
    docker-compose --project-directory "${SCRIPTPATH}" -f "${SCRIPTPATH}/${DOCKER_COMPOSE_FILE}" "${@:1}"
}

function startFunction {
    case ${1} in
        start)
            startFunction pull && \
            startFunction build && \
            startFunction up
        ;;
        up)
            dockerCompose up -d
        ;;
        down)
            dockerCompose down --remove-orphans
        ;;
        login)
            startFunction bash
        ;;
        bash)
            dockerCompose exec web bash
        ;;
        setup)
            dockerCompose exec mail /usr/local/bin/setup "${@:2}"
        ;;
        *)
            dockerCompose "${@:1}"
        ;;
    esac
}

startFunction "${@:1}"
exit $?

#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Select docker compose file
DOCKER_COMPOSE_FILE=docker-compose.yml

function startFunction {
    case ${1} in
        upgrade)
            git fetch && git checkout master && git pull
        ;;
        start)
            startFunction pull
            startFunction build
            startFunction up
        ;;
        up)
            docker-compose --project-directory "${SCRIPTPATH}" -f "${SCRIPTPATH}/${DOCKER_COMPOSE_FILE}" up -d
        ;;
        stopOther)
            containers=$(docker ps --filter network=global -q)
            if [[ "$containers" ]]; then
                docker stop $(printf "%s" "${containers}")
            fi
        ;;
        down)
            startFunction stopOther
            docker-compose --project-directory "${SCRIPTPATH}" -f "${SCRIPTPATH}/${DOCKER_COMPOSE_FILE}" down --remove-orphans
        ;;
        stop)
            startFunction stopOther
            docker-compose --project-directory "${SCRIPTPATH}" -f "${SCRIPTPATH}/${DOCKER_COMPOSE_FILE}" stop --remove-orphans
        ;;
        mysql)
            docker-compose --project-directory "${SCRIPTPATH}" -f "${SCRIPTPATH}/${DOCKER_COMPOSE_FILE}" exec global-db mysql -p
        ;;
        mariadb)
            startFunction mysql
        ;;
        *)
            docker-compose --project-directory "${SCRIPTPATH}" -f "${SCRIPTPATH}/${DOCKER_COMPOSE_FILE}" "${@:1}"
        ;;
    esac
}

docker network inspect global &>/dev/null || docker network create global
startFunction "${@:1}"
exit $?

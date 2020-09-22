#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Select docker compose file
DOCKER_COMPOSE_FILE=docker-compose.yml

dockerCompose() {
    docker-compose --project-directory "${SCRIPTPATH}" -f "${SCRIPTPATH}/${DOCKER_COMPOSE_FILE}" "${@:1}"
}

startFunction() {
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
            dockerCompose up -d
        ;;
        stopOther)
            containers=$(docker ps --filter network=global -q)
            if [[ "$containers" ]]; then
                docker stop $(printf "%s" "${containers}")
            fi
        ;;
        down)
            startFunction stopOther
            dockerCompose down --remove-orphans
        ;;
        stop)
            startFunction stopOther
            dockerCompose stop --remove-orphans
        ;;
        mysql)
            dockerCompose exec global-db mysql -p
        ;;
        mariadb)
            startFunction mysql
        ;;
        *)
            dockerCompose "${@:1}"
        ;;
    esac
}

docker network inspect global &>/dev/null || docker network create global
startFunction "${@:1}"
exit $?

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
ENV_DOCKER_CONTEXT=${ENV_DOCKER_CONTEXT:-}
DOCKER_COMPOSE_FILE=docker-compose.yml
if [ "${ENV_DOCKER_CONTEXT:0:11}" == "Development" ]; then
  DOCKER_COMPOSE_FILE=docker-compose.dev.yml
fi

dockerCompose() {
    docker-compose --project-directory "${SCRIPTPATH}" -f "${SCRIPTPATH}/${DOCKER_COMPOSE_FILE}" "${@:1}"
}

checkRoot() {
    if [[ $EUID -ne 0 ]]; then
        echo 'You must be a root user!' 2>&1
        exit 1
    fi
}

checkGitMaster() {
    if [[ $(git symbolic-ref --short -q HEAD) != 'master' ]]; then
        echo 'ERROR: Git is not on branch master!'
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
    fi
}

checkGit() {
    if [[ $(git diff --stat) != '' ]]; then
        echo
        git status --porcelain
        echo

        read -p 'Git is dirty... Continue? [y/N] ' -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
        fi
    fi
}

askDeploy() {
    read -p 'Deploy? [y/N] ' -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
    fi
}

runDeploy() {
    git pull origin master

    # Set user permissions
    chown -R ${APPLICATION_UID}:${APPLICATION_GID} .

    # Git: Deploy as user in container (SSH-Key for private repositories needed)
    #startFunction exec-web git pull origin master

    # Deploy as user in container
    startFunction start
    startFunction exec-web composer install
    #startFunction exec-web composer --working-dir=public install --ignore-platform-reqs
}

startFunction() {
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
        login-root)
            dockerCompose exec web bash
        ;;
        login)
            startFunction bash
        ;;
        bash)
            dockerCompose exec -u ${APPLICATION_USER} web bash
        ;;
        exec-web)
            dockerCompose exec -u ${APPLICATION_USER} web "${@:2}"
        ;;
        deploy)
            checkRoot
            checkGitMaster
            checkGit
            askDeploy
            runDeploy
        ;;
        *)
            dockerCompose "${@:1}"
        ;;
    esac
}

startFunction "${@:1}"
exit $?

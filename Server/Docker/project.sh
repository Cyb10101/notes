#!/usr/bin/env bash

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

checkGitMaster() {
    if [[ $(git symbolic-ref --short -q HEAD) != 'master' ]]; then
        echo 'ERROR: Git is not on branch master!'
        return 1;
    fi
    return 0;
}

checkGit() {
    if [[ $(git diff --stat) != '' ]]; then
        echo
        git status --porcelain
        echo
        printf "Git is dirty...\n";
        return 1;
    fi
    return 0;
}

printDirectory() {
    printf "\e[1;34m\n%-6s\e[m\n" "$(dirname ${1})";
}

menu() {
  selected=`dialog --clear --backtitle "Projects" --no-tags --menu "Menu" 0 0 0 \
    "dc-down"         "Docker: Shutdown all projects" \
    "git-dirty"       "Git: Show dirty git" \
    "dc-pull"         "Docker: Download all images from projects" \
    "dc-upgrade"      "Docker: Upgrade every docker container" \
    "dc-up"           "Docker: Start all projects" \
    "dc-pull-images"  "Docker: Download all docker images" \
    "git-pull"        "Git: Pull all git" \
    "sync"            "Sync: Syncronize project folder" \
   3>&1 1>&2 2>&3`
  clear
  echo ""
  if [[ "${selected}" == "" ]]; then
    exit 0
  fi
  ${0} ${selected}
}

syncProjects() {
  sshList=( $(cat ~/.ssh/config | grep Host | grep -v Hostname | grep cyb- | sed 's/Host //g' | sed 's/ /\n/g') )

  serverList=""
  for item in "${sshList[@]}"; do
     serverList="${serverList}\"${item}\" \"${item}\" ";
  done

  selectedServer=`dialog --clear --backtitle "Projects" --no-tags --menu "Sync to SSH Server" 0 0 0 \
  $(echo $serverList | tr -d '"') \
   3>&1 1>&2 2>&3`
  dialog --clear --backtitle "Projects syncronisation" --title "" --yesno "Really sync to Server: ${selectedServer}\n\nWARNING: All Docker should be down!" 0 0
  response=$?
  clear
  echo ""
  if [ ${response} == 0 ]; then
    echo "Stop Docker 'global'..."
    docker-compose -f ~/projects/global/docker-compose.yml down --remove-orphans
    if [ ! -f global.tar.xz ]; then
      echo "Create archiv 'global'..."
      sudo tar cfJ global.tar.xz global
      sudo chown ${USER}:${USER} global.tar.xz
    fi
    echo "Start Docker 'global'..."
    docker-compose -f ~/projects/global/docker-compose.yml up -d

    echo "Remove remote 'global'..."
    ssh ${selectedServer} docker-compose -f ~/projects/global/docker-compose.yml down --remove-orphans
    ssh ${selectedServer} gio trash ~/projects/global

    echo "Sync projects..."
    rsync -av --delete --exclude="global" \
      --exclude="docker_backup-tools/config/ssh" \
      ~/projects/./ ${selectedServer}:projects/

    echo "Extract archiv 'global'..."
    ssh ${selectedServer} tar xf ~/projects/global.tar.xz --directory ~/projects
    ssh ${selectedServer} gio trash ~/projects/global.tar.xz
    ssh ${selectedServer} docker-compose -f ~/projects/global/docker-compose.yml up -d
    if [ -f global.tar.xz ]; then
      rm global.tar.xz
    fi;
  fi
}

checkDialogInstalled
export -f checkGitMaster
export -f checkGit
export -f printDirectory

case "${1}" in
  dc-down)
    find ~/projects/ -path '*docker-global' -prune -o -path '*global' -prune -o -type f -name 'docker-compose.yml' -o -type f -name 'docker-compose.yaml' -exec bash -c '(printDirectory "{}"; docker-compose -f "{}" down --remove-orphans)' \;
  ;;
  dc-pull)
    find ~/projects/ -path '*docker-global' -prune -o -path '*global' -prune -o -type f -name 'docker-compose.yml' -o -type f -name 'docker-compose.yaml' -exec bash -c '(printDirectory "{}"; docker-compose -f "{}" pull)' \;
  ;;
  dc-upgrade)
    find ~/projects/ -path '*docker-global' -prune -o -path '*global' -prune -o -type f -name 'docker-compose.yml' -o -type f -name 'docker-compose.yaml' -exec bash -c '(printDirectory "{}"; docker-compose -f "{}" pull && docker-compose -f "{}" down --remove-orphans && docker-compose -f "{}" build && docker-compose -f "{}" up -d && docker-compose -f "{}" down --remove-orphans)' \;
  ;;
  dc-up)
    find ~/projects/ -path '*docker-global' -prune -o -path '*global' -prune -o -type f -name 'docker-compose.yml' -o -type f -name 'docker-compose.yaml' -exec bash -c '(printDirectory "{}"; docker-compose -f "{}" build; docker-compose -f "{}" up -d)' \;
  ;;
  dc-pull-images)
    docker pull cyb10101/php-dev:apache-5.6
    docker pull cyb10101/php-dev:apache-7.0
    docker pull cyb10101/php-dev:apache-7.1
    docker pull cyb10101/php-dev:apache-7.2
    docker pull cyb10101/php-dev:apache-7.3
    docker pull cyb10101/php-dev:apache-7.4
    docker pull cyb10101/php-dev:nginx-5.6
    docker pull cyb10101/php-dev:nginx-7.0
    docker pull cyb10101/php-dev:nginx-7.1
    docker pull cyb10101/php-dev:nginx-7.2
    docker pull cyb10101/php-dev:nginx-7.3
    docker pull cyb10101/php-dev:nginx-7.4
  ;;
  git-dirty)
    find ~/projects/ -maxdepth 2 -path '*docker-global' -prune -o -path '*global' -prune -o -type d -name '.git' -exec bash -c '(printDirectory "{}"; cd "$(dirname {})"; checkGitMaster && checkGit; (cd - > /dev/null 2>&1))' \;
  ;;
  git-pull)
    find ~/projects/ -maxdepth 2 -path '*docker-global' -prune -o -path '*global' -prune -o -type d -name '.git' -exec bash -c '(printDirectory "{}"; cd "$(dirname {})"; checkGitMaster && checkGit && git pull origin master; (cd - > /dev/null 2>&1))' \;
  ;;
  sync)
    syncProjects
  ;;
  *)
    menu
  ;;
esac

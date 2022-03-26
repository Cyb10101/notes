#!/usr/bin/env bash

# Muffet - Broken link checker
# https://github.com/raviqqe/muffet/releases/latest

# source ./muffet.sh
# muffetCheck 'example_www' 'https://example.de/'

getMuffet() {
  if [ ! -f muffet ]; then
    VERSION=$(curl -fsSL https://api.github.com/repos/raviqqe/muffet/releases/latest | jq -r '.tag_name' | sed -r 's/v//g'); echo "${VERSION}" && \
      curl -o /tmp/muffet.tar.gz -fsSL "https://github.com/raviqqe/muffet/releases/download/v${VERSION}/muffet_${VERSION}_Linux_x86_64.tar.gz" && \
      tar -xf /tmp/muffet.tar.gz muffet -C "$(pwd -P)"
  fi
}

muffetCheckSafer() {
  ./muffet --header="Authorization: Basic $(echo -n 'username:password' | base64)" \
    --exclude='^\/_error.*' \
    --max-connections 100 --timeout=60 --skip-tls-verification --json ${2} > ${1}.json
}

muffetCheck() {
  ./muffet --header="Authorization: Basic $(echo -n 'username:password' | base64)" \
    --exclude='^\/_error.*' \
    --max-connections 200 --timeout=30 --skip-tls-verification --json ${2} > ${1}.json
}

muffetFast() {
  ./muffet --header="Authorization: Basic $(echo -n 'username:password' | base64)" \
    --exclude='^\/_error.*' \
    --max-connections 300 --skip-tls-verification --json ${2} > ${1}.json
}

getMuffet

# Not working
#export -f muffetCheck
#export -f muffetFast

#!/usr/bin/env bash

# Muffet - Broken link checker
# https://github.com/raviqqe/muffet/releases/latest

# ./muffet.sh
# muffetCheck 'example_www' 'https://example.de/'

getMuffet() {
  if [ ! -f muffet ]; then
    VERSION=2.4.4 && \
      curl -o /tmp/muffet.tar.gz -fsSL "https://github.com/raviqqe/muffet/releases/download/v${VERSION}/muffet_${VERSION}_Linux_x86_64.tar.gz" && \
      tar -xf /tmp/muffet.tar.gz muffet -C "$(pwd -P)"
  fi
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
export -f muffetCheck
export -f muffetFast

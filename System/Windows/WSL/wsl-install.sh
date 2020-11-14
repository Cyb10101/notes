#!/usr/bin/env bash

touch /home/${USER}/.hushlogin

sudo sh -c 'echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'
sudo usermod -aG sudo ${USER}

sudo add-apt-repository multiverse
sudo apt update && sudo apt -y full-upgrade

sudo apt install -y zsh vim
sudo update-alternatives --set editor /usr/bin/vim.basic

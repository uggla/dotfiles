#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

CURDIR=$(pwd)
PART=$1

backup_regular_file_and_stow() {
  for i in $(stow -nvv "$1" 2>&1 | grep CONFLICT | awk '{print $NF}'); do
    mv "${HOME}/${i}" "${HOME}/${i}.bak"
  done

  echo "Running stow on $1:"
  stow -v "$1"
}

install_vim() {
  sudo yum install -y vim gvim
}

install_tools_via_packages() {
  sudo yum install -y bind-utils \
    curl \
    gnupg2 \
    neofetch \
    net-tools \
    ngrep \
    openssh-clients \
    openssl \
    pdsh \
    powerline \
    procps-ng \
    python \
    sudo \
    tmux-powerline \
    tree \
    xclip \
    xdg-utils \
    xorg-x11-utils
}

install_tools_via_git() {
  if [[ ! -d ${HOME}/screenkey ]]; then
    cd "${HOME}"
    git clone https://gitlab.com/wavexx/screenkey.git
    cd "${CURDIR}"
  else
    cd "${HOME}/screenkey"
    git pull
    cd "${CURDIR}"
  fi
}

install_tools_via_curl() {
  if [[ -f /usr/local/bin/bfg-1.13.0.jar ]]; then
    sudo curl \
      https://repo1.maven.org/maven2/com/madgag/bfg/1.13.0/bfg-1.13.0.jar \
      -o /usr/local/bin/bfg-1.13.0.jar
  fi
}

main() {
  sudo yum install -y make stow bats
  if [[ "${PART}" == "bash" ]]; then
    install_tools_via_packages
    install_tools_via_git
    install_tools_via_curl
    backup_regular_file_and_stow bash
  elif [[ "${PART}" == "vim" ]]; then
    install_vim
    backup_regular_file_and_stow vim
  fi
}

main

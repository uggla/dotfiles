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
  sudo dnf install -y vim gvim
}

install_tools_via_packages() {
  sudo dnf install -y bind-utils \
    curl \
    findutils \
    gnupg2 \
    java-1.8.0-openjdk \
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
  if [[ ! -f bin/bfg-1.13.0.jar ]]; then
    mkdir -p bin
    curl \
      https://repo1.maven.org/maven2/com/madgag/bfg/1.13.0/bfg-1.13.0.jar \
      -o bin/bfg-1.13.0.jar
  fi
}

install_languages_to_allow_completion() {
  sudo dnf install -y cmake gcc-c++ make python2-devel python3-devel golang node npm
  if [[ ! -f "${HOME}/rust" ]]; then
    export "$(grep "CARGO_HOME" "${CURDIR}/bash/.exports" | awk '{print $NF}')"
    export "$(grep "RUSTUP_HOME" "${CURDIR}/bash/.exports" | awk '{print $NF}')"
    export PATH=$PATH:${HOME}/rust/bin
    cd "${HOME}"
    curl https://sh.rustup.rs -sSf -o rust.sh
    sh rust.sh -y
    rustup component add clippy
    cargo install cargo-add
    rm rust.sh
    cd "${CURDIR}"
  fi
}

install_vim_plugins() {
  if [[ ! -f "${HOME}/.vim/plugged" ]]; then
    cd vim
    printf "\n" | vim -c ":PlugInstall" -c ":qa!"
    ./YCM.sh
    cd "${CURDIR}"
  fi
}

main() {
  sudo dnf install -y make stow bats ShellCheck
  if [[ "${PART}" == "bash" ]]; then
    install_tools_via_packages
    install_tools_via_git
    install_tools_via_curl
    backup_regular_file_and_stow bash
    # shellcheck source=/dev/null
    source "${HOME}/.bashrc"
  elif [[ "${PART}" == "vim" ]]; then
    install_vim
    backup_regular_file_and_stow vim
    install_languages_to_allow_completion
    install_vim_plugins
  elif [[ "${PART}" == "tmux" ]]; then
    backup_regular_file_and_stow tmux
  fi
}

main

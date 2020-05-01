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
    fzf \
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
    pygobject2 \
    pygtk2 \
    python \
    sudo \
    tmux-powerline \
    tree \
    xclip \
    xdg-utils \
    xorg-x11-utils
}

install_screenkey_via_git() {
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

install_tpm_via_git() {
  if [[ ! -d ${HOME}/.tmux/plugins/tpm ]]; then
    mkdir -p "${HOME}/.tmux/plugins"
    cd "${HOME}/.tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm
    cd "${CURDIR}"
  else
    cd "${HOME}/.tmux/plugins/tpm"
    git pull
    cd "${CURDIR}"
  fi
}

install_bfg_via_curl() {
  if [[ ! -f bin/bfg-1.13.0.jar ]]; then
    mkdir -p bin
    curl \
      https://repo1.maven.org/maven2/com/madgag/bfg/1.13.0/bfg-1.13.0.jar \
      -o bin/bfg-1.13.0.jar
  fi
}

install_languages_to_allow_completion() {
  sudo dnf install -y cmake gcc-c++ make python2-devel python3-devel golang node npm
  # shellcheck source=/dev/null
  source bash/.exports
  if [[ ! -d "${RUSTUP_HOME}" ]]; then
    cd "${HOME}"
    curl https://sh.rustup.rs -sSf -o rust.sh
    sh rust.sh -y
    rustup component add clippy rust-src rustfmt
    cargo install cargo-add
    rm rust.sh
    cd "${CURDIR}"
  fi
}

install_vim_plugins() {
  if [[ ! -d "${HOME}/.vim/plugged" ]]; then
    cd vim
    printf "\n" | vim -c ":PlugInstall" -c ":qa!"
    #./YCM.sh
    cd "${CURDIR}"
  fi
}

main() {
  sudo dnf install -y make stow bats ShellCheck
  if [[ "${PART}" == "bash" ]]; then
    install_tools_via_packages
    install_screenkey_via_git
    install_bfg_via_curl
    backup_regular_file_and_stow bash
    # shellcheck source=/dev/null
    source "${HOME}/.bashrc"
  elif [[ "${PART}" == "vim" ]]; then
    install_vim
    backup_regular_file_and_stow vim
    install_languages_to_allow_completion
    install_vim_plugins
  elif [[ "${PART}" == "tmux" ]]; then
    install_tpm_via_git
    backup_regular_file_and_stow tmux
  fi
}

main

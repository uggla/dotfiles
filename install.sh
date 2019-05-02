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
  if [[ -f /usr/local/bin/bfg-1.13.0.jar ]]; then
    sudo curl \
      https://repo1.maven.org/maven2/com/madgag/bfg/1.13.0/bfg-1.13.0.jar \
      -o /usr/local/bin/bfg-1.13.0.jar
  fi
}

main() {
  sudo yum install -y make stow bats ShellCheck
  if [[ "${PART}" == "bash" ]]; then
    install_tools_via_packages
    install_tools_via_git
    install_tools_via_curl
    backup_regular_file_and_stow bash
  elif [[ "${PART}" == "vim" ]]; then
    install_vim
    backup_regular_file_and_stow vim
    printf "\n" | vim -c ":PlugInstall" -c ":qa!"
  fi
}

main

#  26  02/05/19 21:46:35 sudo dnf install cmake gcc-c++ make python3-devel
#  27  02/05/19 21:47:26 ./YCM.sh
#  28  02/05/19 21:51:23 dnf search golang
#  29  02/05/19 21:53:33 sudo dnf install golang
#  30  02/05/19 21:55:02 ./YCM.sh
#  31  02/05/19 21:55:43 sudo dnf install node npm
#  32  02/05/19 21:56:06 ./YCM.sh
#  33  02/05/19 21:56:48 dnf install cargo runst
#  34  02/05/19 21:56:50 dnf install cargo runt
#  35  02/05/19 21:56:56 sudo dnf install cargo runt
#  36  02/05/19 21:57:02 sudo dnf install cargo rust
#  37  02/05/19 21:57:54 ./YCM.sh

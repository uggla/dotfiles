#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

backup_regular_file_and_stow() {
  for i in $(stow -nvv "$1" 2>&1 | grep CONFLICT | awk '{print $NF}'); do
    mv "${HOME}/${i}" "${HOME}/${i}.bak"
  done

  echo "Running stow on $1:"
  stow -v "$1"
}

main() {
  sudo yum install -y make stow bats
  backup_regular_file_and_stow bash
}

main

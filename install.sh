#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

sudo yum install -y make stow bats
for i in $(stow -nvv bash 2>&1 | grep CONFLICT | awk '{print $NF}'); do
  mv "${HOME}/${i}" "${HOME}/${i}.bak"
done

stow bash

#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

date +%s >RSTCACHE

docker build -t test_dotfiles_fedora_30 .
if docker ps -a | awk '{print $NF}' | grep test_dotfiles_fedora_30; then
  docker rm -f test_dotfiles_fedora_30
fi
docker run --name="test_dotfiles_fedora_30" -id test_dotfiles_fedora_30 bash
docker exec -ti test_dotfiles_fedora_30 bash -c "cd dotfiles && make all"
docker exec -ti test_dotfiles_fedora_31 bash -c $'cd dotfiles && for file in $(find . -type d -name tests); do bats \"$file\" || exit 1; done'

#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

date +%s >RSTCACHE

docker build -t test_dotfiles_fedora_29 .
if docker ps -a | awk '{print $NF}' | grep test_dotfiles_fedora_29; then
  docker rm -f test_dotfiles_fedora_29
fi
docker run --name="test_dotfiles_fedora_29" -id test_dotfiles_fedora_29 bash
docker exec -ti test_dotfiles_fedora_29 bash -c "cd dotfiles && make all"
docker exec -ti test_dotfiles_fedora_29 bash -c "find . -type d -name tests -exec bats {} \;"

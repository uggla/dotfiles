#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

date +%s >RSTCACHE

docker build -t test_dotfiles_fedora .
if docker ps -a | awk '{print $NF}' | grep test_dotfiles_fedora; then
  docker rm -f test_dotfiles_fedora
fi
docker run --name="test_dotfiles_fedora" -id test_dotfiles_fedora bash
docker exec -ti test_dotfiles_fedora bash -c "cd dotfiles && make all"
docker exec -ti test_dotfiles_fedora bash -c "find . -type d -name tests -exec bats {} \;"

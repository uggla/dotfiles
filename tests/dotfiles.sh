#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

date +%s >RSTCACHE

docker build -t dotfiles_tests .
if docker ps -a | awk '{print $NF}' | grep dotfiles_tests; then
  docker rm -f dotfiles_tests
fi
docker run --name="dotfiles_tests" -id dotfiles_tests bash
docker exec -ti dotfiles_tests bash -c "cd dotfiles && ls -al && make all"

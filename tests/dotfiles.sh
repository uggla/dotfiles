#!/usr/bin/env bats
set -euo pipefail
IFS=$'\n\t'

if ! docker ps | grep dotfiles_tests; then
  docker run -di --name dotfiles_tests fedora:29 bash
fi

docker exec -ti dotfiles_tests dnf install git -y

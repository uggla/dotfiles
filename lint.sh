#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# if this session isn't interactive, then we don't want to allocate a
# TTY, which would fail, but if it is interactive, we do want to attach
case $- in
  *i*) DOCKER_TERM="-t" ;;
  *) DOCKER_TERM="" ;;
esac

if [[ -f /usr/bin/shellcheck ]]; then
  SHELLCHECK="/usr/bin/shellcheck"
else
  SHELLCHECK="docker run --rm -i${DOCKER_TERM} \
              -v $(pwd):/mnt:ro \
              --workdir /mnt \
              koalaman/shellcheck"
fi

ERRORS=()

# find all executables and run `shellcheck`
for f in $(find . -type f -not -path '*.git*' | sort -u); do
  if file "$f" | grep --quiet shell; then
    {
      eval "${SHELLCHECK}" "$f" && echo "[OK]: successfully linted $f"
    } || {
      # add to errors
      ERRORS+=("$f")
    }
  fi
done

if [ ${#ERRORS[@]} -eq 0 ]; then
  echo "No errors, hooray"
else
  echo "These files failed shellcheck: ${ERRORS[*]}"
  exit 1
fi

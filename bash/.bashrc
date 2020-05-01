#!/usr/bin/env bash

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return ;;
esac
# Source global definitions
if [ -f /etc/bashrc ]; then
  # shellcheck source=/dev/null
  . /etc/bashrc
fi

# Backup .bash_history per session
function _exit() {
  CURRENT_DATE=$(date "+%Y%m%d-%H%M%S%N")
  cp -p "${HOME}/.bash_history" "${HOME}/.bash_history.${CURRENT_DATE}"
  true >"${HOME}/.bash_history"
  gzip "${HOME}/.bash_history.${CURRENT_DATE}"
}

trap _exit EXIT

# Powerline
if [[ -f "$(command -v powerline-daemon)" ]]; then
  powerline-daemon -q
  export POWERLINE_BASH_CONTINUATION=1
  export POWERLINE_BASH_SELECT=1
  # shellcheck source=/dev/null
  . /usr/share/powerline/bash/powerline.sh
fi

# Set vi mode
set -o vi

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

if [ -f "${HOME}/.config/exercism/exercism_completion.bash" ]; then
  # shellcheck source=/dev/null
  . "${HOME}/.config/exercism/exercism_completion.bash"
fi

# source kubectl bash completion
if hash kubectl 2>/dev/null; then
  # shellcheck source=/dev/null
  source <(kubectl completion bash)
fi

# source travis bash completion
if [[ -f "${HOME}/.travis/travis.sh" ]]; then
  # shellcheck source=/dev/null
  source "${HOME}/.travis/travis.sh"
fi

# Load fzf completion
if [[ -f "/etc/bash_completion.d/fzf" ]]; then
  # Use fd (https://github.com/sharkdp/fd) instead of the default find
  # command for listing path candidates.
  # - The first argument to the function ($1) is the base path to start traversal
  # - See the source code (completion.{bash,zsh}) for the details.
  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
  }

  # shellcheck source=/dev/null
  source /usr/share/fzf/shell/key-bindings.bash
fi

fi

for file in ~/.{bash_prompt,aliases,functions,path,dockerfunc,extra,exports,secrets}; do
  if [[ -r "$file" ]] && [[ -f "$file" ]]; then
    # shellcheck source=/dev/null
    source "$file"
  fi
done
unset file

# Show system info
if [[ $(pgrep -fxc bash) -eq 1 ]]; then
  neofetch --disable packages
fi

#!/usr/bin/env bats

shopt -s expand_aliases
source ../.aliases

@test "Test xclip is available for aliases" {
  run xclip -h
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "Usage: xclip" ]]
}

@test "Test sudo is available for aliases" {
  run sudo -h
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "usage: sudo -h" ]]
}

@test "Test dig is available for aliases" {
  run dig -v
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "DiG" ]]
}

@test "Test ifconfig is available for aliases" {
  run ifconfig
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "lo:" ]]
}

@test "Test ngrep is available for aliases" {
  run ngrep -V
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "ngrep:" ]]
}

@test "Test python is available for aliases" {
  run python --version
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "Python" ]]
}

@test "test xdg-screensaver is available for aliases" {
  run xdg-screensaver
  [[ "$status" -eq 1 ]]
  [[ "$output" =~ "xdg-screensaver" ]]
}

@test "Test vim is available for alias host and vi" {
  run vim --version
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "VIM - Vi IMproved" ]]
}

@test "Test bfg aliases" {
  result=$(bfg)
  [[ "$?" -eq 0 ]]
  [[ "$result" =~ "bfg" ]]
}

@test "Test screenkey is available for aliases" {
  run ${HOME}/screenkey/screenkey -h
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "usage: screenkey" ]]
}

@test "Test pdsh is available for aliases" {
  run pdsh -V
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "pdsh-" ]]
}

@test "Test gpg2 is available for aliases" {
  run gpg2 --version
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "gpg (GnuPG) 2" ]]
}

@test "Test ssh is available for aliases" {
  run ssh -V
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "OpenSSH" ]]
}

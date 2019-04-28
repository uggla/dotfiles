#!/usr/bin/env bats

@test "Test openssl is available for aliases" {
  run openssl version
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "OpenSSL" ]]
}

@test "Test curl is available for aliases" {
  run curl --version
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "curl" ]]
}

@test "Test xdg-open is available for aliases" {
  run xdg-open --version
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "xdg-open" ]]
}

@test "Test tree is available for aliases" {
  run tree --version
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "tree" ]]
}

@test "Test xprop is available for aliases" {
  if [[ -n ${DISPLAY} ]]; then
    run xprop -version
    [[ "$status" -eq 0 ]]
    [[ "$output" =~ "xprop" ]]
  else
    run xprop -version
    [[ "$status" -eq 1 ]]
    [[ "$output" =~ "xprop" ]]
  fi
}

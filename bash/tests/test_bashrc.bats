#!/usr/bin/env bats

@test "Test powerline is available for aliases" {
  run powerline -h
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ "usage: powerline" ]]
}


@test "Test neofetch is available for aliases" {
  [[ -f /usr/bin/neofetch ]]
}

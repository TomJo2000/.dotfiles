#!/usr/bin/env bash

# This file is sourced by `$DOT_FILES/.config/meta/deploy`
# which uses locations[] and requires[] from each deploy spec
# shellcheck disable=SC2034

locations=(
    "${HOME}/.zlogout"
    "${HOME}/.zshrc"
    "${XDG_DATA_HOME}/zsh/scripts"
)


requires=(
    'zsh'
)


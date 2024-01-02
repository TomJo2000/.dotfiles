#!/usr/bin/env bash

# This file is sourced by `$DOT_FILES/.config/meta/deploy`
# which uses locations[] and requires[] from each deploy spec
# shellcheck disable=SC2034

locations=(
    "${XDG_DATA_HOME}/systemd/user"
)


requires=(
    'keepassxc'
)


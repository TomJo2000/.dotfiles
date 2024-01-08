#!/usr/bin/env bash

# This file is sourced by `$DOT_FILES/.config/meta/deploy`
# which uses locations[] and requires[] from each deploy spec
# shellcheck disable=SC2034

locations=(
    "${XDG_CONFIG_HOME}/git"
)


requires=(
    'git'
    'ssh'
    'less'
    'delta'
)

post_deploy() {
local DELTA_CONF="${XDG_CONFIG_HOME}/delta.conf"
# Included files in the git config
git --config-env=include.path=DELTA_CONF config include.path
}


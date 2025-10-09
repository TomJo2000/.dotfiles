#!/usr/bin/env bash

err() {
    printf 'error: %s\n' "$@"
} >&2

die() {
    err "$*"
    exit 1
}
WG_CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/wg"

[[ -d "${WG_CONF_DIR}" ]] || die "No such directory '${WG_CONF_DIR}'"

WG0_FILE="$(find "${WG_CONF_DIR}" \
    -maxdepth 1 \
    -type f \
    -name '*wg*.conf' \
    -perm 0600 \
    | shuf -n1)"

ln -sf "$WG0_FILE" "$WG_CONF_DIR/wg0.conf"

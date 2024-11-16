#!/usr/bin/env bash

# License: BSD Zero Clause
# Copyright (c) 2024 TomIO
man() {
    # try the local man pages first
    command man "$@" || {
        (( $# )) || return 1
            local content src
            # where are we getting the man pages from?
            src="https://man.archlinux.org/man/$1"

            echo "Trying to fetch it from $src"
            content="$(curl -sL "${src}.raw")"

        # check that we didn't get a 404 back.
        if [[ "$content" == *'</html>' ]]; then
            echo '404: Man page not found'
            return 1
        fi

        # inject a note at the top that this is an online man page
        printf -v content '%s\n' \
            ".SS Online man page from $src" \
            "$content"

        command man -l /dev/stdin <<< "$content"
    }
}

man "$@"
# vim: set ft=bash et ts=4 sw=4 ff=unix

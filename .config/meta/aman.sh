#!/usr/bin/env bash
# vim: set ft=bash et ts=4 sw=4 ff=unix
# SPDX-License-Identifier: 0BSD

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
# BSD Zero Clause License
#
# Copyright (c) 2025 tom@termux.dev
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

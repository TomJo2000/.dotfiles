# -*- justfile -*-

set ignore-comments := true
set quiet := true

# variables

dotfiles := justfile_directory()
home := home_directory()

[private]
default:
    just --list

# Deployment related recipes

import '.config/meta/deploy.just'

# Placeholder
[group('utils')]
diff DIRS:
    echo "diff {{ DIRS }}"

# Fetch and install the latest version of the Hasklig NFM Fonts.
[group('utils')]
fonts: (has 'bash' 'git' 'tail' 'curl' 'fc-cache')
    "{{ dotfiles }}/.config/meta/fetch_fonts.sh"

# Update the stats section of the README
stats: (has 'bash' 'git' 'scc' 'awk' 'sed')
    "{{ dotfiles }}/.config/meta/readme_stats.sh"

# check if the given dependencies are available in the $PATH
[group('utils')]
[positional-arguments]
[private]
[unix]
has +prog:
    #!/usr/bin/env sh
    err=0
    POSIXLY_CORRECT=1
    for prog in "$@"; do
        if ! command -v "${prog}" > /dev/null 2>&1; then
            missing+=" $prog"
            err=$(( err + 1 ))
        fi
    done
    [ -z "$missing" ] || printf '%b' "\e[1mMissing:" "\e[0;31m${missing}\e[m\n" >&2
    exit 0 # "$err"

# vim: set et ts=4 sw=4 ff=unix

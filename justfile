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
    echo "diff"

# Fetch and install the latest version of the Hasklig NFM Fonts.
[group('utils')]
fonts: (has 'bash' 'git' 'tail' 'curl' 'fc-cache')
    "{{ dotfiles }}/.config/meta/fetch_fonts.sh"

# Update the stats section of the README
stats: (has 'bash' 'git' 'scc' 'awk' 'sed')
    "{{ dotfiles }}/.config/meta/readme_stats.sh"

# check if the given depedencies are available in the $PATH
[group('utils')]
[positional-arguments]
[private]
[unix]
has +program:
    #!/usr/bin/env sh
    err=0
    for prog in "$@"; do
        if ! command -v "${prog}" &> /dev/null; then
            echo -e "\e[1mMissing \e[31m${prog}\e[m" >&2
            err=$(( err + 1 ))
        fi
    done
    exit "$err"

# vim: et ts=4 sw=4 ff=unix

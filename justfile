# -*- justfile -*-

set ignore-comments := true
set quiet := true

# variables

dotfiles := justfile_directory()

[private]
default:
    just --list

# Deployment related recipes

import '.config/meta/deploy.just'

# Placeholder
[group('utils')]
[private]
diff DIRS:
    echo "diff {{ DIRS }}"

[doc('Fetch and install the latest version of the Hasklig NFM Fonts.')]
[group('utils')]
fonts: (has 'bash' 'git' 'tail' 'curl' 'fc-cache')
    "{{ dotfiles }}/.config/meta/fetch_fonts.sh"

[doc('Update the stats section of the README.')]
[group('utils')]
stats: (has 'bash' 'git' 'scc' 'awk' 'sed')
    "{{ dotfiles }}/.config/meta/readme_stats.sh"

[doc('Lint shebang recipes')]
[group('utils')]
[positional-arguments]
[private]
lint *targets: (has 'bash' 'shellcheck')
    #!/usr/bin/env bash
    declare -a justfiles=(
        "{{ justfile() }}"
        "{{ dotfiles }}/.config/meta/deploy.just"
        "{{ dotfiles }}/.config/meta/post-deploy.just"
    )

    for file in "${justfiles[@]}"; do
        while read -r line; do
            :
        done < "$file"
    done

[doc('Check if the given dependencies are available in the $PATH.')]
[group('utils')]
[positional-arguments]
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

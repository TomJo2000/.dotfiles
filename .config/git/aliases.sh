#!/usr/bin/env bash

# shellcheck disable=SC2034 # Used by `delta` command in functions
readonly DELTA_PAGER='less -R -f /dev/stdin'
readonly -a aliases=('news' 'staged' 'unstaged' 'churn')

# show the last <n> (1 by default) commits
news() {
    git log -w -p HEAD~"${1:-1}".. "${@:2}"
}

# show information and diffs for staged files with full colorization
staged() {
    local del
    local -a MODE=('--staged') removed=()

    # If this function was called from git unstaged
    # don't use the '--staged' argument for the git diff calls.
    [[ "${FUNCNAME[1]}" == 'unstaged' ]] && MODE=()

    while read -r del; do
        removed+=("$del")
    done < <(git -P diff "${MODE[@]}" --name-only --diff-filter=D)

    delta < <(
        # In Git versions before 2.20.1 (from Dec. 15, 2018) this needs to be color.status
        # Also why the hell are you running such an ancient git version?
        git -c color.ui=always status "$@"
        git -P diff "${MODE[@]}" --shortstat "$@"
        (( ${#removed[@]} )) && {
            echo
            printf ' \e[31mdeleted:\t%s\e[m\n' "${removed[@]}"
        }
        git -P diff "${MODE[@]}" --diff-filter=d --ignore-space-change "$@"
    )
}

# same as above but for unstaged changes
unstaged() {
    staged "$@"
}

# Show the <n> (20 by default) most edited files
# Written by Corey Haines
# Scriptified by Gary Bernhardt
# Simplified and made extensible by TomIO
# Example, show the 10 most committed to files in the last month:
# ~$ git churn 10 --since='1 month ago'
churn() {
    git log --all --find-renames --find-copies --name-only --format='format:' "${@:2}" \
    | sort \
    | grep -v '^$' \
    | uniq -c \
    | awk '{print $1 \"\t\" $2}' \
    | sort -g \
    | tail -n "${1:-20}"
}


# These are not to be changed externally.
readonly -f "${aliases[@]}"
# If it's on the list, run it with its args.
[[ " ${aliases[*]} " == *" $1 "* ]] && "$@"

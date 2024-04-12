#!/usr/bin/env bash
# This script is licensed under the MIT License and in large parts adapted from:
# https://github.com/4513ECHO/dotfiles/blob/a80b18c59d35b631a3f4c96387a2a6a8b330d4f7/scripts/gen_stat.sh

err() {
    printf 'error: %s\n' "$*"
} >&2

die() {
    err "$*"
    exit 1
}

src="${1:-"${DOT_FILES}/README.md"}"
read -r GIT_ROOT < <(git -C "${src%\/*}" rev-parse --show-toplevel) || die "${src%\/*} is not in a git repository."

insert_command() {
    local tag_start="<!--${1}-start-->" tag_end="<!--${1}-end-->"
    shift
    local tmp ext=".old"
    tmp="$(mktemp)"
    if ! grep -Fxq "$tag_start" "$src" && \
         grep -Fxq "$tag_end" "$src"; then
        die "You don't have $tag_start or $tag_end in your file"
    fi
    # http://fahdshariff.blogspot.ru/2012/12/sed-mutli-line-replacement-between-two.html
    # clear old result
    sed -i"$ext" "/$tag_start/,/$tag_end/{//!d;}" "$src"
    { # create result file
    echo "<!-- this section has been automatically generated by readme_stats.sh -->"
        "$@"
    } | tee --append "$tmp" | bat -l html --paging=never --style=numbers

    # insert result file
    sed --in-place "/$tag_start/r $tmp" "$src"
    rm -f "$tmp" "${src}${ext}"
}

neovim_plugins() { # any line in lazy-lock.json with "commit" in it is a plugin
    grep -cF '"commit"' "${DOT_FILES}/.config/nvim/lazy-lock.json"
}

table_format() { # (WIP) cursed regex iterator/formater
    local -a _vals=() _len=()
    local line row_count col_count idx='0' regex='<th>[^<]*<\/th>'

    while read -r line; do # read in the table line by line
    (( row_count++ ))
    [[ "$line" == *'<tr>'*'<th>'* ]] && { # if it's a row with headings
        while [[ "$line" =~ $regex ]]; do # format
        if (( idx < col_count )); then
            (( ${#BASH_REMATCH[0]} > _len[idx % 8] )) && {
                _len[idx % 8]="${#BASH_REMATCH[0]}"
            }
        else
            _len[idx % 8]="${#BASH_REMATCH[0]}"
        fi
        _vals[idx++]="${BASH_REMATCH[0]}"

        line="${line/"${BASH_REMATCH[0]}"/}"
        done
        printf "%-${_len[0]}s %-${_len[1]}s %-${_len[2]}s %-${_len[3]}s %-${_len[4]}s %-${_len[5]}s %-${_len[6]}s %-${_len[7]}s\n" \
            "${_vals[@]}"
    continue
    }

    done <<< "$*"
}

loc_count() {
local line
local -a files

while read -r line; do
    files+=("${GIT_ROOT}/${line}")
done < <(git -C "${GIT_ROOT}" ls-files --full-name)

# scc's --remap-all option is finnicky
# and doesn't like unquoted whitespace of any kind
# or being split over multiple lines with leading whitespace.
#
# Spits out a minified HTML table on a single line.
: "$(scc --no-cocomo --no-complexity --exclude-file .gitignore \
--sort code --size-unit binary --format html-table \
--remap-all '# shellcheck shell=':Shell,\
'#!/usr/bin/env bash':Shell,\
'# -*- desktopfile -*-':'Desktop file',\
'# -*- gitconfig -*-':'Git config',\
'# -*- sshconfig -*-':'SSH config',\
'# -*- justfile -*-':'Justfile',\
'# -*- service -*-':'Systemd Service',\
'# -*- ini -*-':INI,\
-- "${files[@]}" | awk -- '{ $1=$1; output=output $0 } END { print output }')"

: "${_//><tr>/>$'\n'      <tr>}"
: "${_//><table>/>$'\n'  <table>}"
: "${_//><thead>/>$'\n'    <thead>}"
: "${_//><\/thead>/>$'\n'    <\/thead>}"
: "${_//><\/tbody>/>$'\n'    <\/tbody>}"
: "${_//><\/tfoot>/>$'\n'    <\/tfoot>}"
: "${_//><\/table>/>$'\n'  <\/table>}"
# read -ra formatted_table < <(table_format "$_")

printf '%s\n' "  ${_}"
# printf '%s\n' "${formatted_table[@]}"
}

# set -x
insert_command 'loc' loc_count
# insert_command 'neovim' neovim_plugins

# shellcheck disable=SC2016 # ?? This isn't a command substitution Shellcheck.
printf -v updated_at 'Statistics are updated at [`%s`](%s/commit/%s)' \
    "$(git -C "${GIT_ROOT}" rev-parse --short HEAD)" \
    "$(git -C "${GIT_ROOT}" remote get-url origin | sed -e 's|\.com:|\.com/|;s|^git@|https://|;s|\.git||')" \
    "$(git -C "${GIT_ROOT}" rev-parse HEAD)"
echo "$updated_at"
sed -i "s@^Statistics are updated at .*\$@$updated_at@" "$src"
# set +x


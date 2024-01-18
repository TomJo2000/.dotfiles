#!/usr/bin/env bash
# This script is licensed under the MIT License and in large parts adapted from:
# https://github.com/4513ECHO/dotfiles/blob/a80b18c59d35b631a3f4c96387a2a6a8b330d4f7/scripts/gen_stat.sh

: "${DOT_FILES:="$(git rev-parse --show-toplevel)"}"
src="${1:-README.md}"

err() {
    printf 'error: %s\n' "$*"
} >&2

die() {
    err "$*"
    exit 1
}

insert_command() {
    tag_start="<!--$1-start-->"
    tag_end="<!--$1-end-->"
    shift
    ext=".orig"
    tmp="$(mktemp)"
    if ! grep -Fxq "$tag_start" "$src" && \
         grep -Fxq "$tag_end" "$src"; then
        die "You don't have $tag_start or $tag_end in your file"
    fi
    # http://fahdshariff.blogspot.ru/2012/12/sed-mutli-line-replacement-between-two.html
    # clear old result
    sed -i"$ext" "/$tag_start/,/$tag_end/{//!d;}" "$src"
    { # create result file
        echo '```'
        "$@"
        echo '```'
    } | tee --append "$tmp"

    # insert result file
    sed --in-place "/$tag_start/r $tmp" "$src"
    rm -f "$tmp" "${src}${ext}"
}

neovim_plugins() { # any line in lazy-lock.json with "commit" in it is a plugin
    grep -cF '"commit"' "$DOT_FILES/.config/nvim/lazy-lock.json"
}

loc_count() {
# scc's --remap-all option is finnicky
# and doesn't like unquoted whitespace of any kind
# or being split over multiple lines with leading whitespace.
scc --no-cocomo --no-complexity --exclude-file .gitignore \
--sort code --size-unit binary --format html-table \
--remap-all '# shellcheck shell=':Shell,\
'#!/usr/bin/env bash':Shell,\
'# -*- desktopfile -*-':'Desktop file',\
'# -*- gitconfig -*-':'Git config',\
'# -*- sshconfig -*-':'SSH config',\
'# -*- service -*-':'Systemd Service',\
'# -*- ini -*-':INI,\
-- "$DOT_FILES" | sed -e 's@\t@  @g'
}

insert_command 'LOC' loc_count
insert_command 'neovim' neovim_plugins

printf -v updated_at "Statistics are updated at [\`%s\`](%s/commit/%s)," \
    "$(git rev-parse --short HEAD)" \
    "$(git remote get-url origin | sed -e 's|\.com:|\.com/|;s|^git@|https://|')" \
    "$(git rev-parse HEAD)"
echo "$updated_at"
sed -i "s@^Statistics are updated at .*\$@$updated_at@" "$src"


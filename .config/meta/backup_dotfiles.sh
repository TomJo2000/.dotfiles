#!/usr/bin/env bash

# backup to USB
# rsync -i --progress -a ~/git/.dotfiles "/run/media/tom/JOSH 32GB/VScode/git/"
#
# update in repo
# rsync --progress --existing --filter=". ${XDG_CONFIG_HOME}/meta/rsync_ignore" --delete-during --out-format='%B %o %n %L' -a "${HOME}/" "${HOME}/git/.dotfiles/"
# deploy from repo

# find . ! -wholename '*.git*' -printf '%04m %P\n'

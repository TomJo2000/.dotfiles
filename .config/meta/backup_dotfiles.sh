#!/usr/bin/env bash

# backup to USB
# rsync -i --progress -a ~/git/.dotfiles "/run/media/tom/JOSH 32GB/VScode/git/"
#
# update in repo
# rsync --progress --existing --filter=". ${DOT_FILES}/.config/meta/rsync_ignore" --delete-during -i -a "${HOME}/" "${DOT_FILES}/"
# deploy from repo

# find . ! -wholename '*.git*' -printf '%04m %P\n'

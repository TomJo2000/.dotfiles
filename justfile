# -*- justfile -*-
set ignore-comments
set quiet

# variables
dotfiles := justfile_directory()
home := home_directory()
exclude_file := dotfiles / ".config/meta/rsync_ignore"

default:
    just --list

@deploy: _deploy_preview && _deploy_files # deploy out files

_deploy_preview:
    rsync --dry-run --out-format="%'''-6b/%'''7l %o %B %M %n" --filter=". {{exclude_file}}" -a "{{dotfiles}}/" "{{home}}/"

[confirm("Are you sure you want to deploy these files?")]
_deploy_files:
    rsync --filter=". {{exclude_file}}" -a "{{dotfiles}}/" "{{home}}/"

@enroll: # add files to the repo
    echo "enroll"


@diff: # diffs directories
    echo "diff"

@stats: # update the README stats
    {{dotfiles}}/.config/meta/readme_stats.sh

# vim: ft=just


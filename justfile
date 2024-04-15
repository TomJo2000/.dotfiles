# -*- justfile -*-
set ignore-comments
set quiet

# variables
dotfiles := justfile_directory()
home := home_directory()
exclude_file := dotfiles / ".config/meta/rsync_ignore"

default:
    just --list

@deploy: # preview and deploy files
    rsync --dry-run --out-format="%'''-6b/%'''7l %o %B %M %n" --filter=". {{exclude_file}}" -a "{{dotfiles}}/" "{{home}}/"
    -just deploy_files # it's fine if this "fails" due to negative confirmation

[private, confirm("Are you sure you want to deploy these files? (y/N)")]
@deploy_files:
    rsync --progress --filter=". {{exclude_file}}" -a "{{dotfiles}}/" "{{home}}/"

@enroll +FILES: # add files to the repo
    echo "enroll"


@diff DIRS: # diffs directories
    echo "diff"

@stats: # update the README stats
    {{dotfiles}}/.config/meta/readme_stats.sh

# vim: ft=just


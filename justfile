# -*- justfile -*-

set ignore-comments := true
set quiet := true

# variables

dotfiles := justfile_directory()
home := home_directory()
exclude_file := dotfiles / ".config/meta/rsync_ignore"

default:
    just --list

@deploy:
    rsync --dry-run --out-format="%'''-6b/%'''7l %o %B %M %n" --filter=". {{ exclude_file }}" -a "{{ dotfiles }}/" "{{ home }}/"
    -just deploy_files # it's fine if this "fails" due to negative confirmation

[confirm("Are you sure you want to deploy these files? (y/N)")]
[private]
@deploy_files:
    rsync --progress --filter=". {{ exclude_file }}" -a "{{ dotfiles }}/" "{{ home }}/"

@diff DIRS:
    echo "diff"

@enroll +FILES:
    echo "enroll"

@fonts:
    "{{ dotfiles }}/.config/meta/fetch_fonts.sh"

@stats:
    "{{ dotfiles }}/.config/meta/readme_stats.sh"

# vim: ft=just

# -*- justfile -*-

set ignore-comments := true
set quiet := true

# variables

dotfiles := justfile_directory()
home := home_directory()
exclude_file := dotfiles / ".config/meta/rsync_ignore"

[private]
default:
    just --list

# Deploy files
deploy:
    just has 'rsync'
    rsync --dry-run --out-format="%'''-6b/%'''7l %o %B %M %n" --filter=". {{ exclude_file }}" -a "{{ dotfiles }}/" "{{ home }}/"
    -just deploy_files # it's fine if this "fails" due to negative confirmation

[confirm("Are you sure you want to deploy these files? (y/N)")]
[private]
deploy_files:
    rsync --progress --filter=". {{ exclude_file }}" -a "{{ dotfiles }}/" "{{ home }}/"

# Placeholder
[group('utils')]
diff DIRS:
    echo "diff"

# Fetch and install the latest version of the Hasklig NFM Fonts.
[group('utils')]
fonts:
    just has 'bash' 'git' 'tail' 'curl' 'fc-cache'
    "{{ dotfiles }}/.config/meta/fetch_fonts.sh"

# Update the stats section of the README
stats:
    just has 'bash' 'git' 'scc' 'awk' 'sed'
    "{{ dotfiles }}/.config/meta/readme_stats.sh"

# check if the given depedencies are available in the $PATH
[group('utils')]
[positional-arguments]
[private]
[unix]
has +program:
    #!/usr/bin/env sh
    for prog in "$@"; do
        if ! command -v "${prog}" &> /dev/null; then
            echo -e "Missing \e[31m${prog}\e[m"
            exit 1
        fi
    done

# vim: et ts=4 sw=4 ff=unix

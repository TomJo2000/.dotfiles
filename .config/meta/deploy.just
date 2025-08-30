# This justfile contains all the deploy targets.
exclude_file := dotfiles / ".config/meta/rsync_ignore"

# Load post deployment hooks.
import 'post-deploy.just'

# Deploy files
[positional-arguments]
[doc('Deploy specified targets.')]
deploy *targets='all':
    #!/usr/bin/env bash
    declare -a TARGETS=(
        'git'  # Git/Delta
        'misc' # Various one-off configuration files
        'nvim' # Neovim
        'ssh'  # SSH and SSH Agent service
        'wg'   # Wireguard
        'zsh'  # Zsh/Starship
    )

    # Handle 'all' target
    [[ " $* " == *' all '* ]] && set -- "${TARGETS[@]}"
    just  run_deploy "$@"
    just post_deploy "$@"


[private]
[positional-arguments]
deploy_preview +files:
    #!/usr/bin/env bash
    declare -a args=(
    '--dry-run'                                 # Just simulate
    '--archive'                                 # Preserve: symlinks, permissions, times, group, owner, special files
    '--recursive'                               # Include subdirectories recursively
    "--out-format=%'''7l %o %B %M %n"           # <sent>/<size> <operation> <Permission bits> <mtime> <filename>
    '--filter=. {{ exclude_file }}'             # Ignore the files listed in the exclude file
    '--from0'                                   # Use NUL delimiters for the file list
    '--files-from=-'                            # Take a file list from stdin
    '{{ dotfiles }}/'                           # Source directory
    '{{ home }}/'                               # Destination directory
    )
    rsync "${args[@]}" < <( printf '%s\0' "$@")
    printf '\e[33mPREVIEW: Deploying to \e[1;34m%s\e[m\n' "{{ home }}"

[private]
[positional-arguments]
[confirm("Are you sure you want to deploy these files? (y/N)")]
deploy_files +files:
    #!/usr/bin/env bash
    declare -a args=(
    '--archive'                                 # Preserve: symlinks, permissions, times, group, owner, special files
    '--recursive'                               # Include subdirectories recursively
    "--out-format=%'''6b/%'''7l %o %B %M %n"           # <sent>/<size> <operation> <Permission bits> <mtime> <filename>
    '--filter=. {{ exclude_file }}'             # Ignore the files listed in the exclude file
    '--from0'                                   # Use NUL delimiters for the file list
    '--files-from=-'                            # Take a file list from stdin
    '{{ dotfiles }}/'                           # Source directory
    '{{ home }}/'                               # Destination directory
    )
    rsync "${args[@]}" < <( printf '%s\0' "$@")

# check if the given depedencies are available in the $PATH
[unix]
[private]
[positional-arguments]
run_deploy +targets:
    #!/usr/bin/env bash
    # Print out our list of targets
    printf '%s' 'Deploying targets:'
    printf ' \e[30;47m%s\e[m' "$@"
    echo

    declare -a files=()
    for target in "$@"; do
        # Run the recipe for the target
        files+=( $(just "target_${target}") )
    done

    # Print out the list of all files we are deploying.
    just deploy_preview "${files[@]}"
    # This can fail if declined, that's fine
    just deploy_files "${files[@]}" || :


### Targets
[private]
[group('targets')]
[doc('Git and Delta.')]
target_git: (has 'git')
    #!/usr/bin/env bash
    declare -a files=(
        '.config/git/'
        '.config/delta.conf'
    )
    printf '%s\n' "${files[@]}"

[private]
[group('targets')]
[doc('Random one-offs.')]
target_misc:
    #!/usr/bin/env bash
    declare -a files=()
    just has 'alacritty'             && files+=('.config/alacritty/alacritty.toml')
    just has 'btop'                  && files+=('.config/btop/themes/termstream.theme')
    just has 'cava'                  && files+=('.config/cava/config')
    just has 'foot'                  && files+=('.config/foot/foot.ini')
    just has 'keepassxc' 'systemctl' && files+=('.local/share/systemd/user/keepassxc.service')
    just has 'mpv'                   && files+=('.config/mpv/')
    just has 'neofetch'              && files+=('.config/neofetch/config.conf')
    just has 'paru'                  && files+=('.config/paru/paru.conf')
    just has 'nheko' 'keepassxc'     && files+=('.config/autostart/nheko.desktop') # Needs DBus Secret provider
    just has 'spotify'               && files+=('.config/autostart/spotify.desktop')
    just has 'thunderbird'           && files+=('.config/autostart/org.mozilla.Thunderbird.desktop')
    just has 'vorta' 'borg'          && files+=('.config/autostart/vorta.desktop')
    just has 'tmux'                  && files+=('.config/tmux/tmux.conf')
    just has 'kwallet-query'         && files+=(
        '.config/kwalletrc'
        '.config/xdg-desktop-portal/portals.conf'
    )
    printf '%s\n' "${files[@]}"

[private]
[group('targets')]
[doc('Neovim and formatter configurations')]
target_nvim: (has 'nvim' 'git')
    #!/usr/bin/env bash
    declare -a files=(
        '.config/nvim/' # Config dir
        '.stylua.toml'  # Lua formatter config
        '.editorconfig' # Filetype specific formatting directives
    )
    printf '%s\n' "${files[@]}"

[private]
[group('targets')]
[doc('SSH and agent service.')]
target_ssh: (has 'ssh')
    #!/usr/bin/env bash
    # SSH config file
    declare -a files=('.ssh/config')
    # SSH agent systemd user service
    just has 'systemctl' && files+=('.local/share/systemd/user/ssh-agent.service')
    printf '%s\n' "${files[@]}"

[private]
[group('targets')]
[doc('Wireguard.')]
target_wg: (has 'wg-quick' 'resolvconf')
    #!/usr/bin/env bash
    declare -a files=('.config/wg/PostDown.sh')
    printf '%s\n' "${files[@]}"

[private]
[group('targets')]
[doc('Zsh and Starship prompt.')]
target_zsh: (has 'zsh' 'git')
    #!/usr/bin/env bash
    declare -a files=(
        '.zshrc'       # Shell setup file
        '.zlogout'     # Shell logout file
        '.config/zsh/' # Config dir
    )
    # Starship prompt config
    just has 'starship' && files+=('.config/starship.toml')
    printf '%s\n' "${files[@]}"

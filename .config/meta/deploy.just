# This justfile contains all the deploy targets.
home := home_directory()
exclude_file := dotfiles / ".config/meta/rsync_ignore"

# Post deployment hooks.
import 'deploy_hooks.just'

# Deploy files
[doc('Deploy specified targets. (This is usually what you want)')]
[group('deploy')]
[positional-arguments]
deploy *targets='all':
    #!/usr/bin/env bash
    declare -a TARGETS=(
        'git'  # Git/Delta
        'kde'  # KDE programs
        'misc' # Various one-off configuration files
        'nvim' # Neovim
        'ssh'  # SSH and SSH Agent service
        'wg'   # Wireguard
        'zsh'  # Zsh/Starship
    )

    # Handle 'all' target
    [[ " $* " == *' all '* ]] && set -- "${TARGETS[@]}"
    # Print out our list of targets
    printf '%s' 'Deploying targets:'
    printf ' \e[30;47m%s\e[m' "$@"
    echo

    declare -a FILES=()
    declare -A HOOKS=()
    for target in "$@"; do
        # Check that this is a valid target.
        [[ " ${TARGETS[*]} " == *" $target "* ]] || {
            printf "\e[31m[  DEPLOY]: Unknown target '%s'\e[m\n" "$target"
            continue
        }
        # Source the recipe for the target
        source <(just "target_${target}")
    done

    # Print out the list of all files we are deploying.
    just deploy_preview "${FILES[@]}"
    # This can fail if declined, that's fine just exit before we do the hooks.
    just deploy_files "${FILES[@]}" || exit 0
    # But only run the post deploy hooks if the files were deployed.
    just deploy_hooks "${!HOOKS[@]}"

[doc('Show a preview of the files that are about to be deployed')]
[group('deploy')]
[positional-arguments]
[private]
deploy_preview +files:
    #!/usr/bin/env bash
    declare -a args=(
    '--dry-run'                       # Just simulate
    '--archive'                       # Preserve: symlinks, permissions, times, group, owner, special files
    '--recursive'                     # Include subdirectories recursively
    "--out-format=%'''7l %o %B %M %n" # <sent>/<size> <operation> <Permission bits> <mtime> <filename>
    '--filter=. {{ exclude_file }}'   # Ignore the files listed in the exclude file
    '--from0'                         # Use NUL delimiters for the file list
    '--files-from=-'                  # Take a file list from stdin
    '{{ dotfiles }}/'                 # Source directory
    '{{ home }}/'                     # Destination directory
    )
    rsync "${args[@]}" < <( printf '%s\0' "$@")
    printf '\n\e[33m[PREVIEW]: Deploying to \e[1;34m%s\e[m\n' "{{ home }}"

[confirm('Are you sure you want to deploy these files? (y/N)')]
[doc('Deploy the previewed set of files.')]
[group('deploy')]
[positional-arguments]
deploy_files +files:
    #!/usr/bin/env bash
    declare -a args=(
    '--archive'                              # Preserve: symlinks, permissions, times, group, owner, special files
    '--recursive'                            # Include subdirectories recursively
    "--out-format=%'''6b/%'''7l %o %B %M %n" # <sent>/<size> <operation> <Permission bits> <mtime> <filename>
    '--filter=. {{ exclude_file }}'          # Ignore the files listed in the exclude file
    '--from0'                                # Use NUL delimiters for the file list
    '--files-from=-'                         # Take a file list from stdin
    '{{ dotfiles }}/'                        # Source directory
    '{{ home }}/'                            # Destination directory
    )
    rsync "${args[@]}" < <( printf '%s\0' "$@")

### Targets
[group('targets')]
[doc('Git and Delta.')]
target_git: (has 'git')
    #!/usr/bin/env cat
    FILES+=(
        '.config/git/'
        '.config/delta.conf'
    )

[group('targets')]
[doc('KDE related.')]
target_kde: (has 'plasmashell')
    #!/usr/bin/env cat
    FILES+=(
        '.config/dolphinrc'
        '.local/share/kxmlgui5/dolphin/dolphinui.rc'
        '.config/kglobalshortcutsrc'
        '.config/klipperrc'
        '.config/krunnerrc'
        '.config/kscreenlockerrc'
        '.config/kwalletrc'
        '.config/plasma-localerc'
        '.config/xdg-desktop-portal/portals.conf'
    )

[group('targets')]
[doc('Random one-offs.')]
target_misc:
    #!/usr/bin/env cat
    just has 'alacritty'                && { FILES+=('.config/alacritty/alacritty.toml') HOOKS[fonts]=''; }
    just has 'btop'                     && FILES+=('.config/btop/themes/termstream.theme')
    just has 'cava'                     && FILES+=('.config/cava/config')
    just has 'fastfetch'                && FILES+=('.config/fastfetch/config.jsonc')
    just has 'foot'                     && { FILES+=('.config/foot/foot.ini') HOOKS[fonts]=''; }
    just has 'keepassxc' 'systemctl'    && { FILES+=('.local/share/systemd/user/keepassxc.service') HOOKS[reload_systemd]=''; }
    just has 'mpv'                      && FILES+=('.config/mpv/')
    just has 'ncdu' || just has 'ncdu2' && FILES+=('.config/ncdu/config')
    just has 'nheko' 'keepassxc'        && { FILES+=('.config/autostart/nheko.desktop') HOOKS[fonts]=''; } # Needs DBus Secret provider
    just has 'paru'                     && FILES+=('.config/paru/paru.conf')
    just has 'qdirstat'                 && FILES+=('.config/QDirStat/')
    just has 'spotify'                  && FILES+=('.config/autostart/spotify.desktop')
    just has 'thunderbird'              && FILES+=('.config/autostart/org.mozilla.Thunderbird.desktop')
    just has 'tmux'                     && { FILES+=('.config/tmux/tmux.conf') HOOKS[tmux]=''; }
    just has 'vorta' 'borg'             && FILES+=('.config/autostart/vorta.desktop')
    just has 'wezterm'                  && { FILES+=('.config/wezterm/') HOOKS[fonts]=''; }

[group('targets')]
[doc('Neovim and formatter configurations.')]
target_nvim: (has 'nvim' 'git')
    #!/usr/bin/env cat
    FILES+=(
        '.config/nvim/' # Config dir
        '.stylua.toml'  # Lua formatter config
        '.editorconfig' # Filetype specific formatting directives
    )

    HOOKS[fonts]=''

[group('targets')]
[doc('SSH and ssh-agent service.')]
target_ssh: (has 'ssh')
    #!/usr/bin/env cat
    # SSH config file
    FILES+=('.ssh/config')
    # SSH agent systemd user service
    just has 'systemctl' && {
        FILES+=('.local/share/systemd/user/ssh-agent.service')
        HOOKS[reload_systemd]=''
    }


    HOOKS[ssh_keys]=''

[group('targets')]
[doc('Wireguard.')]
target_wg: (has 'wg-quick' 'resolvconf')
    #!/usr/bin/env cat
    FILES+=('.config/wg/PostDown.sh')

[group('targets')]
[doc('Zsh and Starship prompt.')]
target_zsh: (has 'zsh' 'git')
    #!/usr/bin/env cat
    FILES+=(
        '.zshrc'       # Shell setup file
        '.config/zsh/' # Config dir
    )
    # Starship prompt config
    just has 'starship' && FILES+=('.config/starship.toml')

    HOOKS[fonts]=''
    HOOKS[zsh]=''

# This justfile contains the post deployment hooks
# for targets that need additional setup beyond the config files.

[doc('Handle post deployment hooks.')]
[group('deploy')]
[group('hooks')]
[positional-arguments]
deploy_hooks +targets:
    #!/usr/bin/env bash
    printf '\e[33m[   HOOKS]: Running post-deploy hooks\e[m\n'

    declare -a HOOKS=(
        'fonts'          # Check if NerdFonts are set up.
        'reload_systemd' # Reload the systemd user daemon
        'ssh_keys'       # Check SSH keys specified in config
        'tmux'           # Clone tpm for tmux
        'zsh'            # Clone or updaze Zsh plugins.
    )

    for hook in "$@"; do
        # Check that this is a valid hook..
        [[ " ${HOOKS[*]} " == *" $hook "* ]] || {
            printf "\e[31m[   HOOKS]: Unknown hook '%s'\e[m\n" "$hook"
            continue
        }
        # If this hook isn't in the list of hooks, skip it.
        just "hook_${hook}"
    done

[group('hooks')]
[doc('Set up NerdFonts.')]
hook_fonts: (has 'curl' 'git' 'fc-cache')
    #!/usr/bin/env bash
    printf '\e[32m[   FONTS]:\e[m %s\n' \
    "Setting up fonts"
    echo "<< Not yet implemented >>"
    exit 0 # no-op for now

[group('hooks')]
[doc('Reload systemd user daemon.')]
hook_reload_systemd: (has 'systemctl')
    #!/usr/bin/env bash
    printf '\e[32m[ SYSTEMD]:\e[m %s\n' \
        "Reloading systemd user daemon"
    systemctl --user daemon-reload

[group('hooks')]
[doc('Check SSH keys.')]
hook_ssh_keys: (has 'ssh-copy-id')
    #!/usr/bin/env bash
    printf '\e[32m[SSH-KEYS]:\e[m %s\n' \
        "Checking SSH keys from config"
    echo "<< Not yet implemented >>"
    exit 0 # no-op for now

[group('hooks')]
[doc('Tmux plugins.')]
hook_tmux: (has 'zsh' 'git')
    #!/usr/bin/env bash
    printf '\e[32m[    TMUX]:\e[m %s\n' \
        "Setting up Tmux plugins"
    echo "<< Not yet implemented >>"
    exit 0 # no-op for now
    git clone https://github.com/tmux-plugins/tpm

[group('hooks')]
[doc('Zsh plugins.')]
hook_zsh: (has 'zsh' 'git')
    #!/usr/bin/env bash
    printf '\e[32m[     ZSH]:\e[m %s\n' \
        "Setting up Zsh plugins"
    echo "<< Not yet implemented >>"
    exit 0 # no-op for now

    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$zsh_script_dir/fast-syntax-highlighting"
    git clone https://github.com/marlonrichert/zsh-autocomplete.git "$zsh_script_dir/zsh-autocomplete"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$zsh_script_dir/zsh-autosuggestions"

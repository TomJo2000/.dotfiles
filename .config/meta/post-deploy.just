# This justfile contains the post deployment hooks
# for targets that need additional setup beyond the config files.

[doc('Handle post deployment hooks')]
[group('post-deploy')]
[positional-arguments]
[private]
post_deploy +targets:
    #!/usr/bin/env bash
    declare -a POST_HOOKS=(
        'fonts'    # Check if NerdFonts are set up.
        'ssh_keys' # Check SSH keys specified in config
        'tmux'     # Clone tpm for tmux
        'zsh'      # Clone or updaze Zsh plugins.
    )

    printf '\e[33m[   HOOKS]: Running post-deploy hooks\e[m\n'

    for target in "${POST_HOOKS[@]}"; do
        # If this target isn't in the list of targets, skip it.
        just "post_${target}"
    done

[private]
[group('targets')]
[doc('Set up NerdFonts.')]
post_fonts: (has 'curl' 'git' 'fc-cache')
    #!/usr/bin/env bash
    printf '\e[32m[   FONTS]:\e[m %s\n' \
    "Setting up fonts"
    exit 0 # no-op for now

[private]
[group('targets')]
[doc('Check SSH keys.')]
post_ssh_keys: (has 'ssh-copy-id')
    #!/usr/bin/env bash
    printf '\e[32m[SSH-KEYS]:\e[m %s\n' \
        "Checking SSH keys from config"
    exit 0 # no-op for now

[private]
[group('targets')]
[doc('Tmux plugins.')]
post_tmux: (has 'zsh' 'git')
    #!/usr/bin/env bash
    printf '\e[32m[    TMUX]:\e[m %s\n' \
        "Setting up Tmux plugins"
    exit 0 # no-op for now
    git clone https://github.com/tmux-plugins/tpm


[private]
[group('targets')]
[doc('Zsh plugins.')]
post_zsh: (has 'zsh' 'git')
    #!/usr/bin/env bash
    printf '\e[32m[     ZSH]:\e[m %s\n' \
        "Setting up Zsh plugins"

    exit 0 # no-op for now

    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$zsh_script_dir/fast-syntax-highlighting"
    git clone https://github.com/marlonrichert/zsh-autocomplete.git "$zsh_script_dir/zsh-autocomplete"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$zsh_script_dir/zsh-autosuggestions"

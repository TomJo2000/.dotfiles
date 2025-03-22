# This justfile contains the post deployment hooks
# for targets that need additional setup beyond the config files.

[doc('Handle post deployment hooks')]
[group('post-deploy')]
[positional-arguments]
[private]
post_deploy +targets:
    #!/usr/bin/env bash
    declare -a POST_HOOKS=(
        'misc' # check if NerdFonts are set up.
        'zsh'  # clone or updaze Zsh plugins.
    )
    for target in "$@"; do
        # If this target isn't in the list of targets, skip it.
        [[ " ${POST_HOOKS[*]} " != *" ${target} "* ]] && continue
        just "post_${target}"
    done

[private]
[group('targets')]
[doc('Zsh and Starship prompt.')]
post_misc:
    #!/usr/bin/env bash
    : # no-op for now

[private]
[group('targets')]
[doc('Zsh and Starship prompt.')]
post_zsh: (has 'zsh' 'git')
    #!/usr/bin/env bash
    : # no-op for now

#!/usr/bin/env bash
# <> list of installed plugins
local plugin_repos; local -a found_plugins=()
while read -rs -d $'\n' plugin_repos; do # ?? split sub-directories into an array robustly
    found_plugins+=("$plugin_repos")
done < <( find "$zsh_script_dir" -mindepth 1 -maxdepth 1 -type d )


    timing[updates]="-$EPOCHREALTIME"
    function updates() { # <> Everything relating to update checking.

        [[ -d "$zsh_script_dir" ]] || mkdir -p "$zsh_script_dir" # if script dir doesn't exist, make it.
        printf '%b' \
            'Last checked for updates at: ' \
            "${col[fg_blue]}" \
            "$(date -r "$zsh_script_dir" '+%x %X' || echo 'Unknown')" \
            "${col[reset]}\n"

        function parse_frequency() { # <> Resolve $update_frequency from human readable form to seconds.
            [[ "${debug_verbosity[*]}" =~ (^| )(updates|all)( |$) ]] && { # >< If we are debugging updates, this is irrelevant just set it to 0.
                update_frequency='0'
                return
            }
            local minute hour day week
            (( minute = 60 )) # seconds
            (( hour = 60 * minute ))
            (( day = 24 * hour ))
            (( week = 7 * day ))

            if   [[ $update_frequency =~ ^[0-9]+$ ]]; then # |> If the value is numeric, just use it as is.
                : # ?? (no-op)
            elif [[ $update_frequency =~ ^([0-9]+[SsMmHhDdWw])+$ ]]; then # |> if its in the regular 1w2d3h4m5s format, resolve it.
                # ** replace each letter with its corresponding conversion constant, then sum them up; this fails without an operation on the sed output, so we just do + 0
                (( update_frequency = $( sed -E "s/[Ww]/ \* $week + /;s/[Dd]/ \* $day + /;s/[Hh]/ \* $hour + /;s/[Mm]/ \* $minute + /;s/[Ss]//" <<< $update_frequency ) + 0 ))
            else # |> Fallthrough in case of invalid pattern, default to a week.
                printf '%b' \
                    'Error:' \
                    'Could not resolve value for ' \
                    "\$update_frequency=\"${update_frequency:-<unset>}\" " \
                    'defaulting to 1 Week\n'
                (( update_frequency = 1 * week ))
            fi
        return
        }; parse_frequency

        [[ "${debug_verbosity[*]}" =~ (^| )(updates|all)( |$) ]] && { # >< Debug: Updates
            printf '%b' "Debug: Updates\n"
        }
        (( EPOCHSECONDS - $(date -r "$zsh_script_dir" '+%s') >= update_frequency )) && { # ?? This only runs if the update_frequency has passed or we're debugging this
        local -a external_plugins
            function check_upstream() { # <> check for updates and query user if available

                function prompt_update() { # <> handle update specifics
                    local user_input
                    printf '%b' \
                        "Would you like to update [${col[fg_orange]}${plugin_name:-Example Plugin}${col[reset]}]?\n" \
                        "${col[fg_green]}Y${col[reset]}es/${col[fg_red]}N${col[reset]}o(${col[fg_light_grey]}default${col[reset]})\n" \
                        "${col[fg_blue]}${col[bold]}[ ]${col[reset]}\e[2G" # Make braces for input, then move cursor back to column 2
                    read -r user_input
                    # shellcheck disable=SC2015
                    [[ "$user_input" =~ ^[Yy](es)?$ ]] && { # |> if the user selects to update the plugin, add it to the list
                        external_plugins+=("${col[fg_green]}${plugin_name}")
                    } || {
                        external_plugins+=("${col[fg_red]}${plugin_name}")
                    }
                    printf '%b' \
                        "${external_plugins[*]:: -1}" "${col[reset]} " \
                        "${col[uline]}${col[blink]}" "${external_plugins[-1]}" "${col[reset]}\n"
                return
                }

                local plugin_name="${PWD##*\/}"; plugin_name="${plugin_name%.*}" # Remove all but the last part of the directory name, leaving the plugin name.

                [[ "${debug_verbosity[*]}" =~ (^| )(updates|all)( |$) ]] && { # >< Debug: Updates
                    printf '%b' "${col[fg_purple]}Debug${col[reset]}: update prompt\n"
                    prompt_update
                return
                }

                # (ACK) Based on https://stackoverflow.com/a/3278427
                local LOCAL REMOTE BASE
                read -r LOCAL REMOTE < <( git rev-parse 'HEAD' '@{upstream}' )
                BASE="$( git merge-base 'HEAD' '@{upstream}' )"

                if   [[ "$LOCAL" == "$REMOTE" ]]; then
                    printf '%b' "[${col[fg_green]}${plugin_name}${col[reset]}] Up to date\n"
                elif [[ "$LOCAL" == "$BASE" ]]; then
                    timing[updates_logic]="-$EPOCHREALTIME"
                    printf '%b' "[${col[fg_orange]}${plugin_name}${col[reset]}] New changes available\n"
                    prompt_update # (todo) Prompt user for update. (I'll add this later)
                    (( timing[updates_logic] += EPOCHREALTIME ))
                fi
            return
            }

            local index
            for index in "${found_plugins[@]}"; do # |> loop over the array of plugins
                [[ "${plugins[${index##*\/}]:0:1}" == '/' ]] && { # ?? skip update checking for local plugins
                    printf '%b' "[${col[fg_green]}${index##*\/}${col[reset]}] Local Plugin\n"
                    continue
                }
                ( # |> Do update checking in a subshell to avoid having to cd back inside of the parent shell
                    cd "$index" && check_upstream 2> /dev/null
                    :
                )
            done
            touch -cm "$zsh_script_dir" # Update the script directories modification time.
        }
        unset -v "update_frequency" # update frequency isn't needed anymore at this point, so clean it up.
    return
    }; updates # Run the updates function, since we're done defining it.

#!/usr/bin/env zsh
function parse_args() { # (ACK) Based on: https://stackoverflow.com/a/14203146

    (( $# )) || return 0 # if we have no args, return early
    timing[args]="-$EPOCHREALTIME"

    function get_new_verbosity() { # <> if we were given an invalid verbosity request a new one
    while true; do
        local user_input='' # reset input
        printf "%b${col[reset]} " "Valid options:" "${debug_valid[*]/#/${col[bold]}${col[inv]}}" "\n${col[fg_green]}Please provide a valid setting for verbosity:"
        read -r user_input
        if [[ "${debug_valid[*]}" =~ (^|[[:space:]])$user_input($|[[:space:]]) ]]; then # (RegEx) the \s RegEx shorthand for whitespace does not work in test expressions, need to fallback to [[:space:]]
            # shellcheck disable=SC2206
            while read -rs -d $'\n' plugin_repos; do # |> split sub-directories into an array robustly
                found_plugins+=("$plugin_repos")
            done <<< "$user_input"
            debug_verbosity+=("$user_input")
            return
        fi
    done
    }

# shellcheck disable=SC2046
{ # <> Version and dependency information
local name; name="TomIO's .zshrc"
local version; version="${col[uline]}${col[fg_zomp]}v2.0.0${col[reset]}"
local license; license="${col[fg_green]}MIT${col[reset]}"
local commit
    : $(<"${DOT_FILES}/.git/HEAD") # last field of the HEAD
    : $(<"${DOT_FILES}/.git/${_}") # actual SHA of the HEAD
commit="${col[fg_green]}${col[dim]}#${_::7}${col[reset]}"
local -a dependencies; dependencies=(
    "${col[orange]}${col[uline]}Dependencies:${col[reset]}"
    "${col[fg_light_green]}Zsh${col[reset]} - Shell (MIT License)"
    "${col[fg_blue]}GNU Coreutils${col[reset]} - Utils (GPLv3+)"
    "${col[fg_orange]}Git${col[reset]} - Update Checking/Version Control (GPLv2)"
    "${col[fg_yellow]}OpenSSH${col[reset]} - Remote Access (BSD License)"
    )
}

local -a posargs=()
    while (( $# )); do # <> As long as we got positional args:
        case "$1" in
            ('-v'|'--verbose') # |> set debug mode
            timing[verbosity]="-$EPOCHREALTIME"
            local -a debug_valid=( # ** valid values for ${debug_verbosity[*]}, set with the `-v|--verbose <value>` flag.
                'all'
                'args'
                'async'
                'banner'
                'color'
                'installed'
                'missing'
                'off'
                'ssh'
                'timings'
                'updates'
            )

            printf '%b' \
                "Found ${col[uline]}${col[ital]}${col[fg_cyan]}'$1'${col[reset]} " \
                "with option: ${col[uline]}${col[ital]}${col[fg_cyan]}'${2:-<none>}'${col[reset]}\n"

            if [[ -n "$2" && ${2:0:1} != "-" && ${debug_valid[*]} =~ (^| )$2( |$) ]]; then
                debug_verbosity+=("$2")
                shift "2"
            else
                printf '%s\n' "which is invalid."
                get_new_verbosity
                shift "$(( ( ${#2} != 0 ) + 1 ))"
            fi
            echo
            (( timing[verbosity] += EPOCHREALTIME ))
        ;;
        ('-h'|'--help'|'--usage') # |> print usage information
            debug_verbosity+=('off') # ?? This will make main() print the debug banner, which is more compact
            printf '%s\n' "I haven't written a --help output yet"
            break
        ;;
        ('-V'|'--version') # |> print version information
            debug_verbosity+=('off') # ?? This will make main() print the debug banner, which is more compact
            printf '%b\n' \
            "${name} ${version}${commit} | License: ${license}" \
            "${dependencies[@]}"
            break
        ;;
        ('--') # |> end of args
            shift # shift -- off the stack
            posargs+=("$@") # add remaining args to $posargs
            [[ "${debug_verbosity[*]}" =~ (^| )(args|all)( |$) ]] && {
            printf '%s\n' \
                "Found ${col[uline]}${col[ital]}'--'${col[reset]}, stopping parsing." \
                "Leftover args: ${col[ital]}${col[fg_purple]}$*${col[reset]}"
            }
            break
        ;;
        (--*=|--*|-*) # |> unknown flags
            printf '%s\n' "Unknown flag $1, ignoring"
            shift
        ;;
        (*) # |> keep the order of positional arguments
            posargs+=("$1")
            shift
        ;;
        esac
    done
    set -- "${posargs[@]}" # restore positional arguments
return
}

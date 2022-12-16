#!/usr/bin/env zsh
# shellcheck shell=bash # ?? Shellcheck doesn't officially support Zsh linting, Bash is a close enough analog in most cases.

# Shell: Developed for mainly for Zsh. Adaptable to Bash without major rewrites
# Dependencies: coreutils (paste)


# Comment styling
# ** Highlight
# ?? Informational
# <> annotations for whole code blocks, i.e purpose of a function, bracegroup, loop, etc.
# !! Important
# ~~ Invalidated
# (TODO) Todo comments
# (WIP) Work in Progress
# (ACK) acknowledgment
# (RegEx) additional explanations for RegEx


function parse_args(){ # (ACK) Based on: https://stackoverflow.com/a/14203146

typeset -a debug_valid # ?? valid values for $debug_verbosity, set with the `-v|--verbose <value>` flag.
local debug_verbosity
local debug_valid=( "all" "args" "test" )
local name="shell-pad"
local version="0.0.1-alpha"
local license="AGPLv3"
local usage

printf -v usage "%b" \
"$name v$version\n" \
"$name \"\${ARRAY[@]}\" [OPTIONS]\n" \
"Pad strings with characters based on the longest element in the input\n\n" \
"character(s) to pad with to the left of the string\n" \
"character(s) to pad with to the right of the string\n" \
"character(s) separating the strings\n" \
"width at which line should be broken, absolute or percentage\n" \
"enable debugging output, valid options:"

    function get_new_verbosity(){
    while true; do
        local user_input='' # reset input
        printf "%b${col[reset]} " "Valid options:" "${debug_valid[@]/#/${col[bold]}${col[inv]}}" "\n${col[fg_green]}Please provide a valid setting for verbosity:"
        read -r user_input
        if [[ "${debug_valid[*]}" =~ (^|[[:space:]])$user_input($|[[:space:]]) ]]; then # the \s RegEx shorthand for whitespace does not work in test expressions, need to fallback to [[:space:]]
            debug_verbosity=$user_input; return
        fi
    done
    }

    function padding(){
        [[ "$1" =~ ^--.+= ]] && { # (RegEx) $1 is of the --name=value variety
            <<< "${1##*=}" # Remove the '=' and everything in front of it.
        }
    }

local POSARGS=''
    while (( "$#" )); do
        [[ ${1:0:1} != "-" ]] && { # (RegEx) if the first positional argument doesn't start with a '-' append it to $POSARGS, shift over the args and skip to the next iteration
            POSARGS="$POSARGS $1"
            shift
            continue
            }

        [[ "$1" =~ ^(-h|--help=?.*)$ ]] && {
            echo -e "$usage"
            break
            }

        [[ "$1" =~ ^(-V|--version=?.*)$ ]] && {
            echo -e "$name v$version | License: $license"
            break
            }

        [[ "$1" =~ ^(-l|--left-pad=?.*)$ ]] && {
            local l_pad
            l_pad="$( padding $@ )"
            shift
            printf "$l_pad\n"
            continue
            }

        [[ "$1" =~ ^(-r|--right-pad=?.*)$ ]] && {
            local r_pad
            r_pad="$( padding $@ )"
            shift
            printf "$r_pad\n"
            continue
            }

        [[ "$1" =~ ^(-s|--separator=?.*)$ ]]
        [[ "$1" =~ ^(-w|--width=?.*)$ ]]
    done
    eval set -- "$POSARGS" # restore positional arguments
return
}

(( $# )) && parse_args "$@" || parse_args "--help" # if args were passed, parse them, otherwise print usage information


# ** We can't quote looping over array keys with Zsh's syntax here, otherwise the Tokenization for VSCode's Outliner doesn't comprehend it.
# shellcheck disable=SC2068,SC2296 # ?? Shellcheck doesn't understand Zsh's method for looping over associative array keys.
function shell_pad(){ # (ACK) Based on: https://stackoverflow.com/a/59991764

    local max_length=$({ paste -d '' <(printf "%s -> \n" ${(k)col[@]}) <(printf "%s\n" "${col[@]}") ;} | wc -L)
    local max_length i=1 # Set parameters for line wrap

    for key in ${(k)col[@]}; do
            pad=$(( max_length - "${#*}" )) # get initial padding amount
            formatted_string=${*//\\/\\\\}
            while (( pad ; pad-- )) ; do # as long as we aren't at the length of the longest individual element,
                formatted_string="${formatted_string} " # remove one from the padding counter and add a space
            done
            echo -ne "$formatted_string" # print the padded string
            (( i=i%x, i++ )) && echo -n "${separator:-'|'} " || echo # print a column separator after the padded string; break the line whenever it reaches half of the total screen width
    done
}

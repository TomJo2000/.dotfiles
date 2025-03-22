#!/usr/bin/env zsh
# shellcheck shell=bash # ?? Shellcheck doesn't officially support Zsh linting, Bash is a close enough analog in most cases.

# Comment styling
# ** Highlight
# ?? Informational
# >< Additional
# <> Top level blocks
# |> nested blocks
# !! Important
# ~~ Invalidated
# (TODO) Todo comments
# (WIP) Work in Progress
# (ACK) acknowledgment
# (RegEx) additional explanations for RegEx

zmodload zsh/datetime # ?? $EPOCHREALTIME is provided by zsh/datetime, thus it has to be loaded before the first use of that variable.
declare -A timing=( [all]="-$EPOCHREALTIME" ) # ** Before we do anything else, get the timing framework started

function setup() { # <> General setup that has to run regardless of shell level

### **=====General Compatibility======**
setopt BASH_RE_MATCH        # Make the =~ operator behave like in Bash, see `man zshoptions`
setopt RE_MATCH_PCRE        # Make [[ "val" =~ ^pattern$ ]] use PCRE instead of ERE
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shells
# >< can cause issues with some plugins, disable before loading problematic plugins then reenable
setopt KSH_ARRAYS           # Make Arrays 0-indexed like Ken intended
### **================================**

declare -gA promises=() # holds a list of pending promises to resolve

timing[list_plugins]="-$EPOCHREALTIME"
### **=========User Specifics=========**
export zsh_script_dir="${HOME}/.local/share/zsh/scripts" # "plugin" script location
declare -g update_frequency='7d' # ?? interval between update checks. Format: 1w2d3h4m5s (case insensitive); Default: 7d

declare -gA plugins=( # ?? List plugins you wish to use by repo URL
                  [col_gen]="${zsh_script_dir}/col_gen/col_gen.sh"           # local
                  [percode]="${zsh_script_dir}/percode/percode.sh"           # local
             [shared_agent]="${zsh_script_dir}/shared_agent/shared_agent.sh" # local
                [shell_pad]="${zsh_script_dir}/shell_pad/shell_pad.zsh"      # local
                   [synker]="${zsh_script_dir}/synker/synker.sh"             # local
                   [typeof]="${zsh_script_dir}/typeof/typeof.sh"             # local
 [fast-syntax-highlighting]='https://github.com/zdharma-continuum/fast-syntax-highlighting.git'
         [zsh-autocomplete]='https://github.com/marlonrichert/zsh-autocomplete.git'
      [zsh-autosuggestions]='https://github.com/zsh-users/zsh-autosuggestions.git'
          [zsh-completions]='https://github.com/zsh-users/zsh-completions.git'
)
### **================================**
(( timing[list_plugins] += EPOCHREALTIME ))

timing[color]="-$EPOCHREALTIME"

### Color palette array for easier colorization
declare -gA pal=( # ** Associative arrays are unsorted
       [black]='#050307'
         [red]='#DF0D0B'
       [green]='#0AA342'
      [yellow]='#EDBA04'
        [blue]='#0759B6'
     [magenta]='#B7208F'
        [cyan]='#06C2F7'
  [light_grey]='#B0B2B4'
   [dark_grey]='#4F4D4B'
   [light_red]='#EB939B'
 [light_green]='#4EAF26'
      [orange]='#F36D11'
   [dark_blue]='#0F2A9F'
      [purple]='#B84FE0'
        [zomp]='#0C8167'
       [white]='#FBF6FD'
)

declare -agx order=( # 'name' '#RRGGBB'
    'black'       "${pal[black]}"
    'red'         "${pal[red]}"
    'green'       "${pal[green]}"
    'yellow'      "${pal[yellow]}"
    'blue'        "${pal[blue]}"
    'magenta'     "${pal[magenta]}"
    'cyan'        "${pal[cyan]}"
    'light_grey'  "${pal[light_grey]}"
    'dark_grey'   "${pal[dark_grey]}"
    'light_red'   "${pal[light_red]}"
    'light_green' "${pal[light_green]}"
    'orange'      "${pal[orange]}"
    'dark_blue'   "${pal[dark_blue]}"
    'purple'      "${pal[purple]}"
    'zomp'        "${pal[zomp]}"
    'white'       "${pal[white]}"
)

# >< Luma based on Rec. 601
# Luminance is in range 0..255000 as each value is 0..255
# luminance=$(( (r * 299) + (g * 587) + (b * 114) ))

# <> Use col_gen expand `pal[]` to 256 Colors
# (WIP) Still being worked on
# "${plugins[col_gen]}" # ** exports function `col_gen()`

function hex2rgb() { # |> helper function to convert #RRGGBB -> rrr;ggg;bbb
local hex="${1#\#}"
    [[ "$hex" =~ ^[0-9A-Fa-f]{6}$ ]] || {
        printf 'Invalid hex: \e[31m%s\e[m\n' "$1"
        return 1
    } >&2 # redirect this bracegroups output to stderr
    printf '%d;%d;%d\n' "$(( 0x${hex:0:2} ))" "$(( 0x${hex:2:2} ))" "$(( 0x${hex:4:2} ))"
return
}

declare -Agx col
local color_name color_value mode idx color_prefix='fg_'

# <> These two for loops dynamically build the `col[]` array entries for foreground, background each color
for mode in '38;2;' '48;2;'; do # foreground (38;2;) and background (48;2;) modes
    for (( idx = 0; idx < ${#order[@]}; )); do
        color_name="${order[idx++]}"; color_value="${order[idx++]}"
        # ** This accursed contraption works around $'' not allowing dynamic string interpolation
        printf -v "col[${color_prefix}${color_name}]" \
            '%b' "\e[${mode}$(hex2rgb "$color_value")m" # index names follow the pattern col[{f,b}g_<color>]
    done
    color_prefix='bg_'
done
unset -f hex2rgb

col+=( # ** append the following sequences to the `col[]` array
     [reset]=$'\e[m'   # reset all escape sequences
  [fg_reset]=$'\e[39m' # reset foreground only
  [bg_reset]=$'\e[49m' # reset background only
      [bold]=$'\e[1m'
       [dim]=$'\e[2m'  # dimmed color
    [no_dim]=$'\e[22m' # also resets bold
      [ital]=$'\e[3m'  # italic
   [no_ital]=$'\e[23m'
     [uline]=$'\e[4m'  # underline
  [no_uline]=$'\e[24m'
     [blink]=$'\e[5m'  # blinking text
  [no_blink]=$'\e[25m'
       [inv]=$'\e[7m'  # swapped foreground and background
    [no_inv]=$'\e[27m'
    [strike]=$'\e[9m'  # strikethrough
 [no_strike]=$'\e[29m'
)

(( timing[color] += EPOCHREALTIME ))

}; setup
(( timing[setup] = timing[all] + EPOCHREALTIME ))

### Setup XDG base-directories if they aren't already
: "${XDG_CONFIG_HOME:="${HOME}/.config"}" \
  "${XDG_CACHE_HOME:="${HOME}/.cache"}" \
  "${XDG_DATA_HOME:="${HOME}/.local/share"}" \
  "${XDG_STATE_HOME:="${HOME}/.local/state"}" \
  "${XDG_RUNTIME_DIR:="/run/user/${UID}"}"

(( TERMUX_APP_PID )) && XDG_RUNTIME_DIR="${PREFIX}/var/run/user"

export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_STATE_HOME XDG_RUNTIME_DIR


# shellcheck source=./.config/zsh/arg_parse.zsh
source "$XDG_CONFIG_HOME/zsh/arg_parse.zsh"
# shellcheck source=./.config/zsh/main.zsh
source "$XDG_CONFIG_HOME/zsh/main.zsh"

parse_args "$@" # parse args
(( $# )) && (( timing[args] += EPOCHREALTIME )) # this unit is only applicable if we had args

[[ "$SHLVL" -eq 1 || ! "${debug_verbosity[*]}" =~ (^| )(off)?( |$) ]] && main # >< Only run `main()` if we're in a un-nested shell, or debugging.
(( timing[main] += EPOCHREALTIME ))


### initialize starship prompt, this needs to be done in every nested shell.
# Sourcing a proc substitution is what `starship init zsh` does anyway,
# this way we just don't have to eval it.
# shellcheck source=/dev/null
if source <(starship init zsh --print-full-init); then
    [[ "$TERM" == 'foot' ]] && {
        function prompt_marker() {
            # shellcheck disable=SC1003 # ?? this \\ is a u+009C string terminator
            printf '\e]133;A\e\\'
        }
        precmd_functions+=('prompt_marker')
    }
else
    printf '%s\n' "Error: failed to initialize starship prompt" # Print error message if starship failed to initialize
fi

### Cleanup of remaining variables and functions.
unset -f "setup" "main" "parse_args" # unset functions
unset -v "plugins" "debug_valid" # debug related variables

# <> Timing printout
timing[self]="-$EPOCHREALTIME" # Of course we also wanna time the time the timing calculations take.
declare -a timing_order=( # ** Order of timing nodes
'setup'
  'list_plugins'
  'color' # async

'args'
  'verbosity'

'main'
  'ssh_agent' # async
  'printouts'
    'env_specifics'
    'printouts_banner'
  'updates'
    'updates_logic'
  'plugins'
    'history'
    'path'
    'pager'
    'source'
    'suggestions'
    'completions'
    'syntax-highlighting'
  'promises'
)

nbsp="\xC2\xA0" # non-breaking space
declare -A timing_line=( # ** helper assoc with the same keys as ${timing[@]} containing the tree
               [setup]="${col[fg_dark_blue]}${nbsp}${col[fg_green]}setup()"
        [list_plugins]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}List expected plugins"
               [color]="${col[fg_dark_blue]}${nbsp}└╴${col[reset]}Color Palette Generation"

                [args]="${col[fg_dark_blue]}${nbsp}${col[fg_green]}parse_args()"
           [verbosity]="${col[fg_dark_blue]}${nbsp}└╴${col[reset]}parse verbosity"

                [main]="${col[fg_dark_blue]}${nbsp}${col[fg_green]}main()"
           [ssh_agent]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}Attach shell to SSH Agent"
       [env_specifics]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}Determine environment specifics"
           [printouts]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}Printouts"
    [printouts_banner]="${col[fg_dark_blue]}${nbsp}│${nbsp}└╴${col[reset]}Print Banner"
             [updates]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}Update checking"
       [updates_logic]="${col[fg_dark_blue]}${nbsp}│${nbsp}└╴${col[reset]}Update prompt(Realtime)"
             [plugins]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}Plugin checking"
             [history]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}Shell history setup"
                [path]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}Update \${PATH}"
               [pager]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}Pager options"
              [source]="${col[fg_dark_blue]}${nbsp}└╴${col[reset]}Sourcing Plugins"
         [suggestions]="${col[fg_dark_blue]}${nbsp}${nbsp}${nbsp}├╴${col[reset]}Setting up autosuggestions"
         [completions]="${col[fg_dark_blue]}${nbsp}${nbsp}${nbsp}├╴${col[reset]}Setting up completions"
 [syntax-highlighting]="${col[fg_dark_blue]}${nbsp}${nbsp}${nbsp}├╴${col[reset]}Setting up syntax highlighting"
            [promises]="${col[fg_dark_blue]}${nbsp}${nbsp}${nbsp}└╴${col[reset]}Resolving outstanding promises"
)

[[ "${debug_verbosity[*]}" =~ (^| )(timings|all)( |$) ]] && { # >< DEBUG: timings
    printf '%b\n' " ${col[fg_purple]}DEBUG${col[reset]} - timings:"
}

for time in "${timing_order[@]}"; do
    (( ${timing[$time]:-0} )) || { # unset <NULL> indices
        [[ "${debug_verbosity[*]}" =~ (^| )(timings|all)( |$) ]] && { # >< DEBUG: timings - <NULL> values
            printf '%b' \
                "[${col[fg_purple]}${time}${col[reset]}]=" \
                "<${col[fg_light_red]}${col[ital]}NULL${col[reset]}>\n"
        }
        unset "timing[$time]"
        continue
    }

    value="${timing[$time]%.*}"; fraction="${timing[$time]#*.}" # ** Split time values on the '.'
    [[ $fraction =~ e-?[0-9]+$ ]] && { # handle e-notation # ?? (starts happening under 100µs)
        exponent="${fraction#*e-}"
        [[ "${debug_verbosity[*]}" =~ (^| )(timings|all)( |$) ]] && { # >< DEBUG: timings - demux e-notation
        printf '%b' \
            " ${col[fg_purple]}${time}${col[reset]}: " \
            "'${col[fg_light_red]}${value}${col[reset]}'." \
            "'${col[fg_zomp]}${fraction}${col[reset]}' " \
            "E:'${col[fg_orange]}-${exponent}${col[reset]}'\n"
        }
        printf -v fraction "%0$((exponent))d%d" "${value}" "${fraction%e*}"
        (( value = 0 ))
    }
    [[ "${debug_verbosity[*]}" =~ (^| )(timings|all)( |$) ]] && { # >< DEBUG: timings - markup incoming time values
    paste -d '' \
        <(printf "%b\n" "[${col[fg_purple]}${time}${col[reset]}]=") \
        <(printf "%b\n" "'${col[fg_light_red]}${value}${col[reset]}.${col[fg_zomp]}${fraction}${col[reset]}'")
    }

    if   (( value != 0 )); then # ?? Second range
        timing_ordered+=("$( printf '%b%8b%b\n' \
            "${col[fg_green]}" \
            "$((value)).${fraction:0:3}s" \
            "${timing_line[${time}]}" )" )
    elif (( ${fraction:0:3} != 0 )); then # ?? Millisecond range
        timing_ordered+=("$( printf '%b%8b%b\n' \
            "${col[fg_green]}" \
            "$(( ${fraction:0:3} )).${fraction:3:2}ms" \
            "${timing_line[${time}]}" )" )
    elif (( ${fraction:0:6} != 0 )); then # ?? Microsecond range
        timing_ordered+=("$( printf '%b%8b%b\n' \
            "${col[fg_green]}" \
            "$(( ${fraction:3:3} )).${fraction:6:2}µs" \
            "${timing_line[${time}]}" )" )
    else # ?? Nanosecond range
        timing_ordered+=("$( printf '%b%8b%b\n' \
            "${col[fg_green]}" \
            "$(( ${fraction:6:3} )).${fraction:9:2}ns" \
            "${timing_line[${time}]}" )" )
    fi
done

printf '%b\n' "${timing_ordered[@]}" # ?? Print out all timing nodes which have run.

printf '%b%6.2f%b\n' \
"${col[fg_green]}" "$(( (EPOCHREALTIME + timing[self]) * 10 ** 3 ))" "ms${col[reset]} ${col[bold]}${col[fg_dark_blue]}<+>${col[reset]} Timing calculations" \
"${col[fg_green]}" "$(( (EPOCHREALTIME + timing[all] ) * 10 ** 3 ))" "ms${col[reset]} ${col[bold]}${col[fg_dark_blue]}<+>${col[reset]} Total time"
unset -v "time" "value" "fraction" "exponent" "nbsp" # unset leftover internal variables
unset -v "debug_valid" "debug_verbosity" "timing_order" "timing_ordered" "timing_line" "timing" # unset leftover helper arrays

# [=============================Useful resources=============================]
# [ Shellscript Linter                                                       ]
# [ https://www.shellcheck.net/                                              ]
# [                                                                          ]
# [ Hyperpolyglot.org's comparison of *NIX shell syntax                      ]
# [ https://hyperpolyglot.org/unix-shells                                    ]
# [                                                                          ]
# [ Advanced Bash Scripting Guide                                            ]
# [ https://tldp.org/LDP/abs/html/index.html                                 ]
# [                                                                          ]
# [ Dylan Araps' Pure Bash bible                                             ]
# [ https://github.com/dylanaraps/pure-bash-bible                            ]
# [                                                                          ]
# [ Wooledge Wiki - UNIX/Shell scripting wiki                                ]
# [ https://mywiki.wooledge.org/EnglishFrontPage                             ]
# [                                                                          ]
# [ ANSI Escape Sequences                                                    ]
# [ https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#rgb-colors ]
# [                                                                          ]
# [ Zsh ZLE and bindkey reference                                            ]
# [ https://stackoverflow.com/a/55235069                                     ]
# [==========================================================================]

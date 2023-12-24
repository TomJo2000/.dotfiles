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
setopt KSH_ARRAYS           # Make Arrays 0-indexed like god intended
### **================================**

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
                  [f-sy-h]='https://github.com/z-shell/F-Sy-H.git'
     [zsh-autosuggestions]='https://github.com/zsh-users/zsh-autosuggestions.git'
         [zsh-completions]='https://github.com/zsh-users/zsh-completions.git'
 [zsh-syntax-highlighting]='https://github.com/zsh-users/zsh-syntax-highlighting.git'
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
        printf 'Invalid hex: \e[31m%s\e[m\n' "$hex"
        return 1
    } >&2 # redirect this bracegroups output to stderr
    printf "%d;%d;%d\n" "$(( 0x${hex:0:2} ))" "$(( 0x${hex:2:2} ))" "$(( 0x${hex:4:2} ))"
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

function main() { # <> contains everything that only needs to run when setting up a un-nested shell

timing[main]="-$EPOCHREALTIME"
[[ -e '/mnt/c/Users/Josh/Desktop' ]] && { # |> If we are in WSL add a env var for quicker access to the Windows Desktop location
    export WSL_DESKTOP='/mnt/c/Users/Josh/Desktop'
    alias mpv=mpv.exe # alias the Windows version of MPV to `mpv`
}

[[ -e "$HOME/git/.dotfiles/.config/starship.toml" ]] && { # |> check if we have a DOT_FILES repo in the usual spot
    export DOT_FILES="$HOME/git/.dotfiles"
    export STARSHIP_CONFIG="${DOT_FILES}/.config/starship.toml"
}

(( timing[env_specifics] = timing[main] + EPOCHREALTIME ))

timing[printouts]="-$EPOCHREALTIME"

local col_banner # Color banner
printf -v col_banner '%b' \
    "\r           ${col[fg_blue]}dt" \
    "\n          I@@w     ${col[fg_magenta]}Starship Prompt" \
    "\n         ${col[fg_blue]}r@@@@l    ${col[fg_light_grey]}using ${col[fg_orange]}Termstream" \
    "\n        ${col[fg_blue]}f#@@@@#b   ${col[fg_light_grey]}theme by ${col[fg_yellow]}@TomIO" \
    "\n     ${col[fg_blue]},%gg@@@@@@0}m," \
    "\n   ${col[fg_blue]}yPwZ/@@@@@@@@µ&oPa" \
    "\n ;O0´  Q@@@@@@@@\$  \`r6." \
    "\n(Q°   .@@@@@@@@@@;   \`0," \
    "\nGj    G@@@@@@@@@@Q    kD" \
    "\nQ    ,@@@@@@%^}@@@;   ;g" \
    "\nVy   A@@@@Q°   v@@0   q)" \
    "\n uP.y@@@#%      v@@l dv" \
    "\n  ?o\$@@6%        k@8y'" \
    "\n    ##zEosyuyweaIuMQ" \
    "\n   ´%°             m${col[reset]}"

[[ ! "${debug_verbosity[*]}" =~ (^| )(banner|all)?( |$) ]] && { # >< Debug banner: # (RegEx) Only redefine the banner if ${debug_verbosity[*]} isn't 'banner', 'all' or unset
    printf -v col_banner "%b${col[reset]}" \
        "${col[fg_green]}${col[bg_dark_grey]}D" "${col[fg_yellow]}   ${col[uline]}__${col[no_uline]}\n" \
        "${col[fg_green]}${col[bg_dark_grey]}e" "${col[fg_yellow]} <(${col[reset]}o ${col[fg_yellow]})${col[uline]}___${col[no_uline]}\n" \
        "${col[fg_green]}${col[bg_dark_grey]}b" "${col[fg_yellow]}  ( .${col[uline]}_${col[no_uline]}> /\n" \
        "${col[fg_green]}${col[bg_dark_grey]}u" "${col[fg_yellow]}   \`${col[uline]}___${col[no_uline]}/\n" \
        "${col[fg_green]}${col[bg_dark_grey]}g"
    }

[[ "${debug_verbosity[*]}" =~ (^| )(color|all)( |$) ]] && { # >< Debug: Color
        printf '%b\n' "${col[fg_purple]}[${col[reset]}=====${col[fg_purple]}DEBUG${col[reset]}=====${col[fg_purple]}]${col[reset]}"
            # (WIP) Redoing color debugging
        printf '%b\n' "${col[fg_purple]}[${col[reset]}=====${col[fg_purple]}DEBUG${col[reset]}=====${col[fg_purple]}]${col[reset]}"
}

    [[ -z "$ANDROID_ROOT" || -n "${debug_verbosity[*]}" ]] && printf '%b' "${col_banner}\n" # test that we're not on Android/Termux.
    [[ -n "$STARSHIP_SHELL" ]] && printf '%b\n' '🚀 Starship Prompt Initialized' # print confirmation message if starship successfully started
    (( timing[printouts_banner] = timing[printouts] + EPOCHREALTIME ))

timing[ssh_agent]="-$EPOCHREALTIME"
    local async_fd
    exec {async_fd}<> <( # async / fd_alloc
        systemctl show --property MainPID --value --user ssh-agent.service
    )

[[ "${debug_verbosity[*]}" =~ (^| )(ssh|all)( |$) ]] && { # >< Debug: SSH
    echo "yes"
}
SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:=/run/user/${UID}}/ssh-agent.socket"
(( timing[ssh_agent] += EPOCHREALTIME ))


### Update checking
# <> list of installed plugins
local plugin_repos; local -a found_plugins=()
while read -rs -d $'\n' plugin_repos; do # ?? split sub-directories into an array robustly
    found_plugins+=("$plugin_repos")
done < <( find "$zsh_script_dir" -mindepth 1 -maxdepth 1 -type d )

(( timing[printouts] += EPOCHREALTIME ))

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
                LOCAL="$( git rev-parse '@{0}' )"
                REMOTE="$( git rev-parse '@{u}' )"
                BASE="$( git merge-base '@{0}' '@{u}' )"

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
    (( timing[updates] += EPOCHREALTIME ))

### Evaluate missing plugins
timing[plugins]="-$EPOCHREALTIME"
[[ "${debug_verbosity[*]}" =~ (^| )("missing"|"all")( |$) ]] && { # >< Debug: Missing plugins
    debug_plugins=( # Add a couple fake missing plug-ins for debugging
        'https://127.0.0.1/fake_plugin/zsh-fake-plugin'
        'https://127.0.0.1/fake_plugin/zsh-not-a-real-plugin'
        'https://127.0.0.1/fake_plugin/zsh-also-not-a-real-plugin'
        'https://127.0.0.1/fake_plugin/zsh-get-real'
        'https://127.0.0.1/fake/zsh-fake-debug-plugins'
        '/home/tom/.config/zsh/scripts/local-fake'
        '/home/tom/.config/zsh/scripts/another-local-fake'
    ) # Then print out the lists.
    printf "%b${col[reset]}\n" \
    "${col[fg_purple]}DEBUG:${col[reset]} Adding some fake plugins for missing detection" \
    "${col[fg_purple]}Wanted:" \
    "${plugins[@]/#/${col[fg_orange]}}" \
    "${debug_plugins[@]/#/${col[blink]}${col[fg_orange]}}" \
    "${col[fg_purple]}Found:" \
    "${found_plugins[@]/#/${col[fg_green]}}"
}

# (ACK) Based on: https://stackoverflow.com/a/2315459
local -a p_diff=() # ** Array of missing plugins
local wanted found
# shellcheck disable=SC2068,SC2296 # ?? Shellcheck doesn't understand Zsh's method for looping over associative array keys.
for wanted in ${(k)plugins[@]##*\/}; do
    local skip=''
    for found in "${found_plugins[@]##*\/}"; do
        [[ "$wanted" == "$found" ]] && { skip=1; break; }
    done
    [[ -n "$skip" ]] || p_diff+=("$wanted")
done

[[ "${debug_verbosity[*]}" =~ (^| )(missing|all)( |$) ]] && printf '%b' "${p_diff[@]}" # >< Debug: Missing plugins

# [[ -n ${p_diff[*]} ]] && printf "${col[fg_red]}%b${col[reset]} Missing:\n" "${p_diff[@]}" # (WIP)

(( timing[plugins] += EPOCHREALTIME ))


### XDG base-directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

### Shell Options
setopt AUTO_CD              # cd can be omitted when typing in a valid file path
setopt CDABLE_VARS          # expand variable for changing directories

### Keybindings
bindkey -- '\e[H'    beginning-of-line              # HOME
bindkey -- '\e[1;2H' beginning-of-buffer-or-history # Shift + HOME
bindkey -- '\e[F'    end-of-line                    # END
bindkey -- '\e[1;2F' end-of-buffer-or-history       # Shift + END
bindkey -- '\e[1;2C' emacs-forward-word             # Shift + ->
bindkey -- '\e[1;2D' emacs-backward-word            # Shift + <-
bindkey -- '\e[3~'   delete-char                    # DEL

### Environment setup.
printf -v LS_COLORS '%s' \
    "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:" \
    "*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.7z=01;31:" \
    "*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:" \
    "*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:" \
    "*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:" \
    "*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:" \
    "*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:" \
    "*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:" \
    "*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:" \
    "*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.swp=00;90:*.tmp=00;90:*.dpkg-dist=00;90:*.dpkg-old=00;90:" \
    "*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.deb=04;31:*.rpm=04;31:"
export LS_COLORS # set custom $LS_COLORS

timing[history]="-$EPOCHREALTIME"

### History Setup
local -a hist_options=(
'HIST_VERIFY'             # put the history expansion into the command line instead of instantly running it
'SHARE_HISTORY'           # automate history file updating
'EXTENDED_HISTORY'        # record timestamp of command in HISTFILE
'HIST_IGNORE_SPACE'       # ignore commands that start with space
'HIST_NO_FUNCTIONS'       # ignore function definitions
'HIST_IGNORE_ALL_DUPS'    # ignore duplicates
'HIST_EXPIRE_DUPS_FIRST'  # delete duplicates first when HISTFILE size exceeds HISTSIZE if there are any
'INC_APPEND_HISTORY_TIME' # append command to history file immediately after execution
)

setopt "${hist_options[@]}"

export HISTFILE="$HOME/.histfile"
export HISTSIZE='4000'
export SAVEHIST='10000'

(( timing[history] += EPOCHREALTIME ))
timing[path]="-$EPOCHREALTIME"

    function path_amend() { # <> add directories to $PATH if they are not in it already
        local P
        local -a add_to_path=(
            "$HOME/.local/bin"
            "$HOME/.cargo/bin"
        )

        for P in "${add_to_path[@]}"; do
            [[ "$PATH" == *"$P"* ]] || export PATH="$PATH:$P" # (RegEx) Check if the directory is already in $PATH, if its not, add it.
        done
    }; path_amend

(( timing[path] += EPOCHREALTIME ))
timing[pager]="-$EPOCHREALTIME"

### `man` options
export MANROFFOPT="-P -c" # ** color output doesn't seem to work without this anymore

### `less` pager stylization and options
    export LESSCHARSET='utf-8'
    # |> define the Unicode private use ranges as printable to make NerdFonts work without '-r' which the man page discourages from use
    export LESSUTFCHARDEF='E000-F8FF:p'       # ** 'Private Use Area'
           LESSUTFCHARDEF+=',F0000-FFFFD:p'   # ** 'Supplementary Private Use Area-A'
           LESSUTFCHARDEF+=',100000-10FFFD:p' # ** 'Supplementary Private Use Area-B'

    export LESS_TERMCAP_me; printf -v LESS_TERMCAP_me '%b' "${col[reset]:-\e[m}"
    export LESS_TERMCAP_se; printf -v LESS_TERMCAP_se '%b' "${col[reset]:-\e[m}"
    export LESS_TERMCAP_ue; printf -v LESS_TERMCAP_ue '%b' "${col[reset]:-\e[m}"
    export LESS_TERMCAP_md; printf -v LESS_TERMCAP_md '%b' "${col[fg_blue]:-\e[38;2;7;89;182m}"                       # #0759B6
    export LESS_TERMCAP_so; printf -v LESS_TERMCAP_so '%b' "${col[fg_yellow]:-\e[38;2;237;186;4m}"                    # #EDBA04
    export LESS_TERMCAP_mb; printf -v LESS_TERMCAP_mb '%b' "${col[fg_red]:-\e[38;2;223;13;11m}"                       # #DF0D0B
    export LESS_TERMCAP_us; printf -v LESS_TERMCAP_us '%b' "${col[uline]:-\e[4m}${col[fg_green]:-\e[38;2;10;163;66m}" # #0AA342


    local -a less_prompt=( # <> Prompt for `less`
        '-PM'           # set the '-M' (long) prompt
        "${col[fg_dark_blue]:-\e[38;2;15;42;159m}${col[inv]:-\e[7m}" # set the color and make it inverted for the powerline
        '❮?f%F:stdin.❯' # if the input is a standard file, use the file name, otherwise (aka if input is a pipe) use `❮stdin❯` as the string.
        "${col[bg_dark_blue]:-\e[38;2;15;42;159m}${col[fg_light_green]:-\e[38;2;78;175;38m}${col[bg_reset]:-\e[m}"
        '['             # opening bracket
        ''             # Line number power line symbol
        '%lt'           # top line of the screen
        '-'             # a dash
        '%lb'           # bottom line of the screen
        '/'             # a slash
        '%L'            # total lines
        ']'             # closing bracket
        '┆'             # soft separator
        '?e%Pb:%Pt.'    # percentage into the file (based on the top most line of the screen), unless we're at the end of the file
        '\%'            # a (escaped) % sign
        "${col[no_inv]:-\e[27m}${col[fg_light_green]:-\e[38;2;78;175;38m}${col[reset]:-\e[m}"
        '%t'            # trim trailing whitespace
    )

    local -a less_colors=( # <>
        # >< "-DB" # binary chars
        # >< "-DC" # Control char
        # >< "-DE" # Errors
        # >< "-DH" # Headers, lines, columns
        # >< "-DM" # Marks
        # >< "-DN" # Line numbers
        # >< "-DP" # Prompts
        # >< "-DR" # Right scroll, line overflow indicator
        # >< "-DS" # Search results
        # >< "-D1" # 1st sub-pattern of the search pattern
        # >< "-D2" # 2nd sub-pattern of the search pattern
        # >< "-D3" # 3rd sub-pattern of the search pattern
        # >< "-D4" # 4th sub-pattern of the search pattern
        # >< "-D5" # 5th sub-pattern of the search pattern
        # >< "-DW" # Move highlight unread
        # >< "-Dd" # Bold text
        # >< "-Dk" # Blinking text
        # >< "-Ds" # Standout text
        # >< "-Du" # Underlined text
    )

    local -a less_opts=( # <> set default options for `less`
        '--save-marks' # retain marks across invocations
        '--file-size'  # determine file size on opening (may take a significant amount of time on pipes)
        '--mouse'      # enable scrolling with the mouse
        '-g'           # only highlight last search (bit faster than the default behavior)
        '-i'           # ignore case when searching as long as the search string is lowercase.
        '-R'           # display escape sequences for colors, hyperlinks and UTF-8 correctly
        '-x4'          # set tab width to 4 columns
        '-J'           # mark selected lines/search hits
        '-M'           # Use the 'long prompt'
        '-S'           # split long lines over multiple lines
        "$( printf '%s' "${less_colors[@]}" )" # colors
        "$( printf '%b' "${less_prompt[@]}" )" # (Long) prompt # ?? | ❮.zshrc❯[423-456/627]┆69%
    )
    export LESS="${less_opts[*]}"
    # export LESSEDIT='%E -rg %g:?lt+%lt.%t' # implicit LESSEDIT format is: '%E ?lm+%lm. %g'
    # export LESSOPEN="|-${XDG_CONFIG_HOME}/less/lessopen.sh %s"

(( timing[pager] += EPOCHREALTIME ))

# setup nvim as default EDITOR and DIFF program.
export EDITOR="nvim"
export DIFFPROG="nvim -d"

alias ls='LC_COLLATE=C ls --file-type --color' # colorize ls by default

# (WIP)
# mkssh-key() {
#     local key_name=""
#     ssh-keygen -t rsa -b 4096 -f "$PWD/$key_name" -C "${USER}@${HOST}-$(date -I)"
# }

# (WIP)
#function parse_ls_cols(){
#    local value
#    while read -rd ':' value; do
#        printf '%b%b\e[0m:' "${value/#*=/\e[}m" "${value}"
#    done <<< "$LS_COLORS"
#    echo
#
#return
#}

timing[source]="-$EPOCHREALTIME" # sourcing stuff
setopt NO_KSH_ARRAYS

timing[completions]="-$EPOCHREALTIME"
### Completions
[[ "${fpath[*]}" == *"${zsh_script_dir}/zsh-completions/src"* ]] || {
    fpath+=("${zsh_script_dir}/zsh-completions/src") # Zsh Completions does not get sourced, its /src directory containing the completions gets appended to $fpath
}
autoload -U compinit # load compinit

# **    :completion:function:completer:command:argument:tag <- Template
zstyle ':completion:*' menu select=1 # show a selection menu if there's more than 1 possible completion
zstyle ':completion:*' use-cache true # use a cache for completions
zstyle ':completion:*' cache-path "${XDG_STATE_HOME}/zsh_completions" # put the cache there
zstyle ':completion:*' special-dirs true # complete `.` and `..`
zstyle ':completion:*' list-colors "$LS_COLORS" # color completion candidates using the same scheme as $LS_COLORS
zstyle ':completion:*' rehash true # update completions for newly installed packages
zstyle ':completion:*:options' description 'yes' # provide descriptions for options

zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters # complete variable subscripts
zstyle ':completion:*:manuals' separate-sections true # display man completion by section number
# (WIP) make _fc completions not spew out every history event as an option

compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-${ZSH_VERSION}"

(( timing[completions] += EPOCHREALTIME ))

timing[suggestions]="-$EPOCHREALTIME"
# <> Zsh-autosuggestions customization
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=${pal[light_grey]}"

# shellcheck source=/dev/null # ?? Ignore Shellcheck's inability to parse external sources by default
source "$zsh_script_dir/zsh-autosuggestions/zsh-autosuggestions.zsh" 2>> /dev/null # Load autosuggestions
(( timing[suggestions] += EPOCHREALTIME ))


# <> Fast-syntax-highlighting customization
timing[f-sy-h]="-$EPOCHREALTIME"

# only source it if we haven't already
# shellcheck source=/dev/null # ?? Ignore Shellcheck's inability to parse external sources by default
(( ${#FAST_HIGHLIGHT} )) || source "$zsh_script_dir/f-sy-h/F-Sy-H.plugin.zsh"
(( timing[f-sy-h] += EPOCHREALTIME ))

# only set KSH_ARRAYS after loading plugins to avoid jank
setopt KSH_ARRAYS # Make Arrays start at index 0 # !! breaks unpatched zsh-autosuggestions and z-sy-h

### Resolve async/awaits
timing[async]="-$EPOCHREALTIME"

SSH_AGENT_PID="$(</dev/fd/${async_fd})" # await / consume
exec {async_fd}>&- # fd_free
printf '%b\n' "Connected to SSH Agent.\nPID: ${col[inv]}$SSH_AGENT_PID${col[reset]}"

(( timing[async] += EPOCHREALTIME ))
(( timing[source] += EPOCHREALTIME ))
}

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
parse_args "$@" # parse args
(( $# )) && (( timing[args] += EPOCHREALTIME )) # this unit is only applicable if we had args

[[ "$SHLVL" -eq 1 || ! "${debug_verbosity[*]}" =~ (^| )(off)?( |$) ]] && main # >< Only run `main()` if we're in a un-nested shell, or debugging.
(( timing[main] += EPOCHREALTIME ))


### initialize starship prompt, this needs to be done in every nested shell.
# Sourcing a proc substitution is what `starship init zsh` does anyway,
# this way we just don't have to eval it.
if source <(/usr/bin/starship init zsh --print-full-init); then
    function prompt_marker() {
        printf '\e]133;A\e\\'
    }
    precmd_functions+=('prompt_marker')
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
  'color'

'args'
  'verbosity'

'main'
  'printouts'
    'printouts_banner'
    'ssh_agent'
  'updates'
    'updates_logic'
  'plugins'
    'history'
    'path'
    'pager'
    'source'
    'completions'
    'suggestions'
    'f-sy-h'
    'async'
)

nbsp="\xC2\xA0" # non-breaking space
declare -A timing_line=( # ** helper assoc with the same keys as ${timing[@]} containing the tree
                  [setup]="${col[fg_dark_blue]}${nbsp}${col[fg_green]}setup()"
     [list_plugins]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}List expected plugins"
            [color]="${col[fg_dark_blue]}${nbsp}└╴${col[reset]}Color Palette Generation"

             [args]="${col[fg_dark_blue]}${nbsp}${col[fg_green]}parse_args()"
        [verbosity]="${col[fg_dark_blue]}${nbsp}└╴${col[reset]}parse verbosity"

             [main]="${col[fg_dark_blue]}${nbsp}${col[fg_green]}main()"
    [env_specifics]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}Determine environment specifics"
        [printouts]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}Printouts"
 [printouts_banner]="${col[fg_dark_blue]}${nbsp}│${nbsp}├╴${col[reset]}Print Banner"
        [ssh_agent]="${col[fg_dark_blue]}${nbsp}│${nbsp}└╴${col[reset]}SSH Agent"
          [updates]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}Update checking"
    [updates_logic]="${col[fg_dark_blue]}${nbsp}│${nbsp}└╴${col[reset]}Update prompt(Realtime)"
          [plugins]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}Plugin checking"
          [history]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}Shell history setup"
             [path]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}Update \${PATH}"
            [pager]="${col[fg_dark_blue]}${nbsp}├╴${col[reset]}Pager options"
           [source]="${col[fg_dark_blue]}${nbsp}└╴${col[reset]}Sourcing Plugins"
      [completions]="${col[fg_dark_blue]}${nbsp}${nbsp}${nbsp}├╴${col[reset]}Completions"
      [suggestions]="${col[fg_dark_blue]}${nbsp}${nbsp}${nbsp}├╴${col[reset]}History based autosuggestions"
           [f-sy-h]="${col[fg_dark_blue]}${nbsp}${nbsp}${nbsp}├╴${col[reset]}Setting up syntax highlighting"
            [async]="${col[fg_dark_blue]}${nbsp}${nbsp}${nbsp}└╴${col[reset]}Resolving async/awaits"
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

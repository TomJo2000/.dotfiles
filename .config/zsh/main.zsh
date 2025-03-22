function main() { # <> contains everything that only needs to run when setting up a un-nested shell
timing[main]="-$EPOCHREALTIME"

### SSH Agent
local promise
# If we are connected remotely, don't clobber a possible forwarded agent by overwriting SSH_AUTH_SOCK
(( ${#SSH_CONNECTION} )) || export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

exec {promise}<> <( #
    systemctl show --property MainPID --value --user ssh-agent.service
); promises[ssh_pid]="$promise"; promise=''

exec {promise}<> <( # promise agent status
# We need SSH_AUTH_SOCK and SSH_AGENT_PID for `ssh-add` to connect to the SSH Agent
parse_ssh_add() { # make sense of the `ssh-add -l` output and format the output accordingly
    # Grab the `ssh-agent` PID from our service manager
    local SSH_AGENT_PID
    SSH_AGENT_PID="$(systemctl show --property MainPID --value --user ssh-agent.service)"
    local -a keys=()
    local line
    while read -r line; do
        keys+=("$line")
    done < <(ssh-add -l)

    local width; (( width = ${#SSH_AGENT_PID} >= ${#keys[*]} ? ${#SSH_AGENT_PID} : ${#keys[*]} ))
    case "${keys[*]}" in
        ('Could not open a connection to your authentication agent.') # couldn't connect to agent
        printf '%s\n' "Error: could not attach to SSH Agent." "${keys[*]}"
        return
        ;;
        ('The agent has no identities.') # success no keys
        printf "%s ${col[inv]}%${width}s${col[reset]}\n" \
            'Agent PID:    ' "${SSH_AGENT_PID}" \
            'Keys in agent:' '0'
        ;;
        (*) # success and keys
        printf "%s ${col[inv]}%${width}s${col[reset]}\n" \
            'Agent PID:    ' "${SSH_AGENT_PID}" \
            'Keys in agent:' "${#keys[*]}"
        ;;
    esac
    echo 'Successfully connected to SSH Agent'
}; parse_ssh_add
); promises[ssh_agent]="$promise"; promise=''

[[ "${debug_verbosity[*]}" =~ (^| )(ssh|all)( |$) ]] && { # >< Debug: SSH
    echo "yes"
}
(( timing[ssh_agent] = timing[main] + EPOCHREALTIME ))


timing[env_specifics]="-$EPOCHREALTIME"
[[ -e "$HOME/git/.dotfiles/.config/starship.toml" ]] && { # |> check if we have a DOT_FILES repo in the usual spot
    export DOT_FILES="$HOME/git/.dotfiles"
    export STARSHIP_CONFIG="${DOT_FILES}/.config/starship.toml"
}

# Set up Golang dependency storage in a sensible place.
export GOPATH="${XDG_CACHE_HOME}/go"
(( timing[env_specifics] += EPOCHREALTIME ))

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
(( timing[printouts] += EPOCHREALTIME ))

### Update checking
timing[plugins]="-$EPOCHREALTIME"
    # exec {promise}<> <( #
    #     source "${zsh_script_dir}/update.sh"
    #     updates
    # ); promises[plugin_updates]="$promise"; promise=''
(( timing[updates] = timing[plugins] + EPOCHREALTIME ))

### Evaluate missing plugins
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

### Shell Options
setopt AUTO_CD              # cd can be omitted when typing in a valid file path
setopt CDABLE_VARS          # expand variable for changing directories

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
export HISTSIZE='10000'
export SAVEHIST="$HISTSIZE"
export HISTDUP='erase'

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

# setup nvim as default EDITOR and MANPAGER program.
if command -v 'nvim' &> '/dev/null'; then
    export EDITOR='nvim'
    export MANPAGER='nvim -c Man! -o -'
fi

alias ls='LC_COLLATE=C ls --file-type --color' # colorize ls by default

### `less` pager stylization and options
export LESSCHARSET='utf-8'
export LESSUTFCHARDEF='E000-F8FF:p,'
       LESSUTFCHARDEF+='F0000-FFFFD:p,'
       LESSUTFCHARDEF+='100000-10FFFD:p'
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
    '-K'           # Close on ctrl-c
    '-M'           # Use the 'long prompt'
    '-S'           # split long lines over multiple lines
    # "$( printf '%s' "${less_colors[@]}" )" # colors
    "$( printf '%b' "${less_prompt[@]}" )" # (Long) prompt # ?? | ❮.zshrc❯[423-456/627]┆69%
)
# Set all the options we set up
export LESS="${less_opts[*]}"

export LESSOPEN='|lesspipe.sh %s'
# Use these for the Systemd pager as well
export SYSTEMD_LESS="-F ${LESS}"
# export LESSEDIT='%E -rg %g:?lt+%lt.%t' # implicit LESSEDIT format is: '%E ?lm+%lm. %g'

(( timing[pager] += EPOCHREALTIME ))

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

timing[suggestions]="-$EPOCHREALTIME"
autoload -U compinit
# <> Zsh-autocomplete customization
zstyle '*:compinit' arguments -d "$XDG_CACHE_HOME/zsh/zcompdump-${ZSH_VERSION}"  # write completion cache to XDG basedir
# zstyle ':autocomplete:*' widget-style menu-select                                #
zstyle ':completion:*:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**' #

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=${pal[light_grey]}"
# shellcheck source=/dev/null # ?? Ignore Shellcheck's inability to parse external sources by default
source "$zsh_script_dir/zsh-autosuggestions/zsh-autosuggestions.zsh" 2>> /dev/null # Load autosuggestions
# source  "$zsh_script_dir/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
(( timing[suggestions] += EPOCHREALTIME ))

### Completions
timing[completions]="-$EPOCHREALTIME"
[[ "${fpath[*]}" == *"${zsh_script_dir}/zsh-completions/src"* ]] || {
    fpath+=("${zsh_script_dir}/zsh-completions/src") # Zsh Completions does not get sourced, its /src directory containing the completions gets appended to $fpath
}

# **    :completion:function:completer:command:argument:tag <- Template
zstyle ':completion:*' menu select=1 # show a selection menu if there's more than 1 possible completion
zstyle ':completion:*' use-cache true # use a cache for completions
zstyle ':completion:*' cache-path "${XDG_STATE_HOME}/zsh_completions" # put the cache there
zstyle ':completion:*' special-dirs true # complete `.` and `..`
zstyle ':completion:*' list-colors "$LS_COLORS" # color completion candidates using the same scheme as $LS_COLORS
zstyle ':completion:*' rehash true # update completions for newly installed packages
zstyle ':completion:*:options' description 'yes' # provide descriptions for options
zstyle ':completion:*' keep-prefix true # do not expand variables or expansions


zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters # complete variable subscripts
zstyle ':completion:*:manuals' separate-sections true # display man completion by section number
# (WIP) make _fc completions not spew out every history event as an option
compinit
(( timing[completions] += EPOCHREALTIME ))

# <> Fast-syntax-highlighting customization
timing[syntax-highlighting]="-$EPOCHREALTIME"
# only source it if we haven't already
# shellcheck source=/dev/null # ?? Ignore Shellcheck's inability to parse external sources by default
(( ${#FAST_HIGHLIGHT} )) || source "$zsh_script_dir/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
(( timing[syntax-highlighting] += EPOCHREALTIME ))

### Keybindings
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -- '\e[H'    beginning-of-line              # <Home>
bindkey -- '\e[1;2H' beginning-of-buffer-or-history # <S-Home>
bindkey -- '\e[F'    end-of-line                    # <End>
bindkey -- '\e[3~'   delete-char                    # <Del>
bindkey -- '\e[1;2F' end-of-buffer-or-history       # <S-End>
bindkey -- '\e[A'    up-line-or-history             # <Up>
bindkey -- '\e[B'    down-line-or-history           # <Down>
bindkey -- '\e[1;5C' vi-forward-word                # <C-Right>
bindkey -- '\e[1;5D' vi-backward-word               # <C-Left>
bindkey -- '^W^Q'    edit-command-line              # <C-w><C-q>
bindkey -- '^Wq'     edit-command-line              # <C-w>q

# only set KSH_ARRAYS after loading plugins to avoid jank
setopt KSH_ARRAYS # Make Arrays start at index 0 # !! breaks unpatched zsh-autosuggestions and z-sy-h
(( timing[source] += EPOCHREALTIME ))

### Resolve outstanding promises
timing[promises]="-$EPOCHREALTIME"
# $promise already declared local at the top of main()
local fd
# shellcheck disable=SC2296
for promise in "${(k)promises[@]}"; do
    fd="${promises[$promise]}"
    case "$promise" in
        ('ssh_pid') # resolve SSH Agent PID
            SSH_AGENT_PID="$(</dev/fd/"${fd}")"
        ;;
        ('ssh_agent') # resolve SSH Agent status
            # local agent_status
            printf '%b\n' "$(</dev/fd/"${fd}")"
            export SSH_AUTH_SOCK SSH_AGENT_PID
        ;;
        ('plugin_updates') # resolve plugin updates
            : # (FIXME) Something broke with this.
            # printf '%b\n' "$(</dev/fd/${fd})"
        ;;
        (*) # If I didn't account for it throw a message
        printf "${col[bold]}${col[fg_red]}%s${col[reset]}\n" "No resolve handler for: ${promise}"
        ;;
    esac
    exec {fd}>&- # close the FD
done
unset promises

(( timing[promises] += EPOCHREALTIME ))
}

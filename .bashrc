# ~/.bashrc: executed by bash(1) for non-login shells.

# Start timer for bashrc loading
__BASHRC_START_TIME=$(date +%s.%N)

# Exit if not an interactive shell
[[ $- != *i* ]] && return

# ------------------
# History Optimization
# ------------------
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
HISTSIZE=2000
HISTFILESIZE=10000
__prompt_history_sync() {
    local exit_code=$?
    (history -a 2>/dev/null &)
    return $exit_code
}

[[ $PROMPT_COMMAND != *"__prompt_history_sync"* ]] && PROMPT_COMMAND="__prompt_history_sync"

# ------------------
# Terminal Settings & Prompt
# ------------------
shopt -s checkwinsize
if [[ "$TERM" =~ (xterm|rxvt)-.*|.*-256color ]]; then
  color_prompt=yes
fi
if [[ $color_prompt ]]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
[[ "$TERM" =~ xterm.*|rxvt.* ]] && PS1="\[\e]0;\u@\h: \w\a\]$PS1"
[[ -z "${COLORTERM}" ]] && COLORTERM=truecolor

# ------------------
# Aliases & Color Support
# ------------------
if command -v dircolors &>/dev/null; then
  eval "$(dircolors -b ~/.dircolors 2>/dev/null || dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
alias ll='ls -alFh --group-directories-first'
alias la='ls -A'
alias l='ls -CF'
if command -v notify-send >/dev/null 2>&1; then
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history 1 | sed -e '\''s/^ *[0-9]\{1,\} *//;s/[;&|] *alert$//'\'')"'
fi

# ------------------
# Bash Completion (if available)
# ------------------
if ! shopt -oq posix; then
  for comp in /usr/share/bash-completion/bash_completion /etc/bash_completion; do
    [[ -r $comp ]] && { source "$comp"; break; }
  done
fi

# ------------------
# Load Custom Aliases & Functions
# ------------------
[[ -r ~/.bash_aliases ]] && . ~/.bash_aliases

for component in ~/.bash_functions.d/*; do
  [[ -f "$component" && -r "$component" ]] && . "$component"
done 2>/dev/null

# ------------------
# Load Private Variables
# ------------------
[[ -r ~/.vars.sh ]] && . ~/.vars.sh

# ------------------
# Tools
# ------------------
# FZF
[[ -r ~/.fzf.bash ]] && . ~/.fzf.bash

# Starship Prompt (if installed)
command -v starship &>/dev/null && eval "$(starship init bash)"

# Lazy-load heavy tools
declare -A lazy_load=(
  [nvm]="$HOME/.nvm/nvm.sh"
  [sdk]="$HOME/.sdkman/bin/sdkman-init.sh"
)
lazy_load_tool() {
  local tool="$1" file="$2"
  eval "${tool}() {
    unset -f ${tool}
    source \"${file}\"
    ${tool} \"\$@\"
  }"
}
for tool in "${!lazy_load[@]}"; do
  file="${lazy_load[$tool]}"
  [ -r "$file" ] && lazy_load_tool "$tool" "$file"
done

# completion for sdkman
SDKMAN_DIR="$HOME/.sdkman"
_sdk_init() {
  [[ -r "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && . "$SDKMAN_DIR/bin/sdkman-init.sh"
}
complete -F _sdk_init sdk

# Cleanup and metrics
unset color_prompt component lazy_load


# End timer and display load time (only for interactive shells)
if [[ $- == *i* ]]; then
  __BASHRC_END_TIME=$(date +%s.%N)
  __BASHRC_ELAPSED=$(echo "$__BASHRC_END_TIME - $__BASHRC_START_TIME" | bc)
  echo "Bash startup time: ${__BASHRC_ELAPSED} seconds"
fi


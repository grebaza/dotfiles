#!/usr/bin/env bash

set -eu

is_app_installed() {
  type "$1" &>/dev/null
}

tmux_is_at_least() {
    if [[ $tmux_version == "$1" ]] || [[ $tmux_version == master ]]; then
        return 0
    fi

    local i
    local -a current_version wanted_version
    IFS='.' read -ra current_version <<<"$tmux_version"
    IFS='.' read -ra wanted_version <<<"$1"

    # fill empty fields in current_version with zeros
    for ((i = ${#current_version[@]}; i < ${#wanted_version[@]}; i++)); do
        current_version[i]=0
    done

    # fill empty fields in wanted_version with zeros
    for ((i = ${#wanted_version[@]}; i < ${#current_version[@]}; i++)); do
        wanted_version[i]=0
    done

    for ((i = 0; i < ${#current_version[@]}; i++)); do
        if ((10#${current_version[i]} < 10#${wanted_version[i]})); then
            return 1
        fi
        if ((10#${current_version[i]} > 10#${wanted_version[i]})); then
            return 0
        fi
    done
    return 0
}

# Get data either form stdin or from file
# =======================================
buf=$(cat "$@")

tmux_version="$(tmux -V | cut -d ' ' -f 2 | sed 's/next-//' | sed 's/[a-z]*//g')"
copy_backend_enable=$(tmux show-option -gvq "@copy_backend_enable")
copy_backend_remote_tunnel_port=$(tmux show-option -gvq "@copy_backend_remote_tunnel_port")


# Use a Copy-backend
# ==================
# resolve copy-backend only if tmux option is set and choose between
# pbcopy (OSX), reattach-to-user-namespace (OSX), xclip/xsel (Linux)
if [ "$copy_backend_enable" == "on" ]; then
  copy_backend=""
  if is_app_installed pbcopy; then
    copy_backend="pbcopy"
  elif is_app_installed reattach-to-user-namespace; then
    copy_backend="reattach-to-user-namespace pbcopy"
  elif [ -n "${DISPLAY-}" ] && is_app_installed xsel; then
    copy_backend="xsel -i --clipboard"
  elif [ -n "${DISPLAY-}" ] && is_app_installed xclip; then
    copy_backend="xclip -i -f -selection primary | xclip -i -selection clipboard"
  elif [ -n "${copy_backend_remote_tunnel_port-}" ] \
      && (netstat -f inet -nl 2>/dev/null || netstat -4 -nl 2>/dev/null) \
        | grep -q "[.:]$copy_backend_remote_tunnel_port"; then
    copy_backend="nc localhost $copy_backend_remote_tunnel_port"
  fi

  # if copy backend is resolved, copy and exit
  if [ -n "$copy_backend" ]; then
    printf "%s" "$buf" | eval "$copy_backend"
    exit;
  fi
fi


# Copy via OSC 52 ANSI escape sequence to controlling terminal
# ============================================================
# since 3.3 there is -w flag for set- and load-buffer to send to clipboard using OSC 52
if tmux_is_at_least 3.3; then
  exit;
fi
buflen=$( printf %s "$buf" | wc -c )

# https://sunaku.github.io/tmux-yank-osc52.html
# The maximum length of an OSC 52 escape sequence is 100_000 bytes, of which
# 7 bytes are occupied by a "\033]52;c;" header, 1 byte by a "\a" footer, and
# 99_992 bytes by the base64-encoded result of 74_994 bytes of copyable text
maxlen=74994

# warn if exceeds maxlen
if [ "$buflen" -gt "$maxlen" ]; then
  printf "input is %d bytes too long" "$(( buflen - maxlen ))" >&2
fi

# build up OSC 52 ANSI escape sequence
esc="\033]52;c;$( printf %s "$buf" | head -c $maxlen | base64 | tr -d '\r\n' )\a"
esc="\033Ptmux;\033$esc\033\\"

# resolve target terminal to send escape sequence
# if we are on remote machine, send directly to SSH_TTY to transport escape sequence
# to terminal on local machine, so data lands in clipboard on our local machine
pane_active_tty=$(tmux list-panes -F "#{pane_active} #{pane_tty}" | awk '$1=="1" { print $2 }')
target_tty="${SSH_TTY:-$pane_active_tty}"

# shellcheck disable=SC2059
printf "$esc" > "$target_tty"

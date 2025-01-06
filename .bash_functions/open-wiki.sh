#!/bin/bash
open-wiki() {
  local dir="$1"
  local new_cwd
  local cwd_changed

  if [[ -z "$dir" || -z "$(find "$dir" -maxdepth 1 -type f -regex '.*\.\(md\|txt\)' -print -quit)" ]]; then
    new_cwd="$HOME/wiki"
    mkdir -p "$new_cwd" && pushd "$HOME/wiki" > /dev/null || return && cwd_changed=true
  fi

  # if [ -n "$WAYLAND_DISPLAY" ]; then
  #   file=$(rg --files --follow | bemenu --fn 'Hack 11' -p "wiki:" -i -l 20)
  # else
  file=$(rg --files --follow | rofi -show-icons -normal-window -dmenu -i -p "notes")
  # file=$(rg --files --follow | rofi -dmenu -no-custom  -i -p "wiki")
  # fi

  if [[ -n "$file" ]]; then
    vim "$file"
  fi
  [[ -n $cwd_changed ]] && popd > /dev/null || return
}
alias ow=open-wiki

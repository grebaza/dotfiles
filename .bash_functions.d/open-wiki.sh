openwiki() {
  local dir="${1:-.}"  # Default to cwd if no argument is provided
  local cwd_changed=false

  [ -n "$dir" ] && pushd "$dir" &>/dev/null && cwd_changed=true

  # Select file using ripgrep and rofi
  local file=$(rg --files --follow | rofi show-icons -dmenu -i -p "notes")
  [[ -n "$file" ]] && $EDITOR "$file"

  # Return to the previous directory only if we changed it
  $cwd_changed && popd &>/dev/null
}
alias ow='openwiki ~/wiki'

# shellcheck disable=SC2148
openwiki() {
  local dir="${1:-.}"  # Default to cwd if no argument is provided
  local WIKI_DIR="$HOME/wiki"
  local cwd_changed=false

  # If directory is empty or has no .md/.txt files, switch to WIKI_DIR
  if ! find "$dir" -maxdepth 1 -type f \( -name "*.md" -o -name "*.txt" \) | grep -q '.'; then
    dir="$WIKI_DIR"
    mkdir -p "$dir" && pushd "$dir" > /dev/null && cwd_changed=true
  fi

  # Set picker arguments for rofi
  local picker_args=(-show-icons -dmenu -i -p "notes")
  [[ -n $WAYLAND_DISPLAY ]] && picker_args+=("-normal-window")

  # Select file using ripgrep and rofi
  local file
  file=$(rg --files --follow | rofi "${picker_args[@]}")

  # Open selected file in Vim
  [[ -n $file ]] && vim "$file"

  # Return to the previous directory only if we changed it
  $cwd_changed && popd > /dev/null
}
alias ow=openwiki

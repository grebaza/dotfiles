openwiki() {
  local dir="${1:-$PWD}"  # Default to current directory
  local WIKI_DIR="$HOME/wiki"

  # Choose first directory containing markdown/text files
  local target_dir=""
  for d in "$dir" "$WIKI_DIR"; do
    test -n "$(find "$d" -maxdepth 1 -type f \( -name "*.md" -o -name "*.txt" \) -print -quit)" && target_dir="$d" && break
  done

  [[ -z "$target_dir" ]] && echo "No .md or .txt files found!" && return 1 # Exit if no files found

  # Select file using ripgrep and rofi
  local file=$(cd "$target_dir" && rg --files --follow --hidden --glob '!.*' --sort path | rofi -show-icons -dmenu -i -p "notes")
  [[ -n "$file" ]] && $EDITOR "$target_dir/$file"
}
alias ow=openwiki

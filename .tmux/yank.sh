#!/usr/bin/env bash
# Minimal OSC52 clipboard copy script with maximum length handling.
# This script reads from standard input, base64-encodes the input,
# removes newlines, and truncates the output to a maximum length.
#
# The maximum length is defined by 'maxlen' (in characters, after base64 encoding)
# based on recommendations from the tmux-yank project:
# https://sunaku.github.io/tmux-yank-osc52.html
#
# Usage:
#   <command> | ./yank.sh
#
set -euo pipefail

# Maximum allowed length for the OSC52 sequence (base64-encoded).
# Adjust this value if your terminal supports longer sequences.
maxlen=74994

# Read from stdin, encode, remove newlines, and truncate to maxlen.
encoded=$(head -c "$maxlen" | base64 | tr -d '\r\n')

# Exit quietly if no input was provided.
[ -z "$encoded" ] && exit 0

# Output the OSC52 escape sequence to set the clipboard.
printf "\033]52;c;%s\a" "$encoded"

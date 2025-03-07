# Backup script using rclone
# OneDrive restrictions on https://support.microsoft.com/en-us/office/restrictions-and-limitations-in-onedrive-and-sharepoint-64883a5d-228e-48f5-b3d2-eb39e07630fa
#!/bin/bash
# Optimized backup script using rclone with minimal external commands

rclone_copy() {
  local src="$1" dst="$2"

  # rclone options stored in an array for clarity and efficiency
  local opts=(
    --update --verbose --transfers 30
    --checkers 8 --contimeout 60s --timeout 300s
    --retries 3 --low-level-retries 10 --stats 10s
    --exclude-regexp '(^|/)(\.env|\.git|\.hg|\.venv|__pycache__|env|node_modules|venv|con|prn|aux)(/|$)'
    --delete-excluded
  )

  /usr/bin/rclone sync "${opts[@]}" "$src" "$dst"
}

backup() {
  if (( $# < 1 )); then
    echo "backup: expected at least 1 argument, got $# ($*)" >&2
    echo "usage: backup SOURCE" >&2
    return 1
  fi

  local src_task="$1"
  local remote_name="${2:-1drive}"

  # Loop over each task in BACKUP_DIRS and match with the provided source
  for task in $BACKUP_DIRS; do
    [[ "$task" != "$src_task" ]] && continue

    # Convert task to uppercase and replace '-' with '_' using Bash built-ins,
    # then append _DIR to derive the environment variable name.
    local env_var="${task^^}"
    env_var="${env_var//-/_}_DIR"
    local local_dir="${!env_var}"

    if [[ -n "$local_dir" ]]; then
      echo "Backing up '$local_dir' to '$remote_name:$task/'..."
      rclone_copy "$local_dir" "$remote_name:$task/"
    fi
  done
}

# OneDrive restrictions on https://support.microsoft.com/en-us/office/restrictions-and-limitations-in-onedrive-and-sharepoint-64883a5d-228e-48f5-b3d2-eb39e07630fa
rclone_copy() {
  local src="$1"
  local dst="$2"

  /usr/bin/rclone sync \
    --update --verbose --transfers 30 \
    --checkers 8 --contimeout 60s --timeout 300s \
    --retries 3 --low-level-retries 10 --stats 10s \
    --exclude '.env/**' \
    --exclude '.git/**' \
    --exclude '.hg/**' \
    --exclude '.venv/**' \
    --exclude '__pycache__/**' \
    --exclude 'env/**' \
    --exclude 'node_modules/**' \
    --exclude 'venv/**' \
    --exclude 'con/**' \
    --exclude 'prn/**' \
    --exclude 'aux/**' \
    --delete-excluded \
    "$src" "$dst" # names not allowed in Onedrive
}

backup() {
  if [[ $# -lt 1 ]]; then
    local THIS_FUNC_NAME="${funcstack[1]-}${FUNCNAME[0]-}"
    echo "$THIS_FUNC_NAME - 1 argument are expected. given $#. args=[$*]" >&2
    echo "usage: $THIS_FUNC_NAME SOURCE" >&2
    return 1
  fi
  local source="$1"
  local source_addr=""
  local destination_addr=""
  local remote_name="${2:-1drive}"

  for task in $BACKUP_DIRS; do
    if [ "$task" == "$source" ]; then
      # get platform (if exists envar <component-in-uppercase>_PLATFORM)
      LOCAL_DIR_VAR=$(echo "$task" | tr '[:lower:]' '[:upper:]' | tr - _)_DIR
      LOCAL_DIR=${!LOCAL_DIR_VAR}
      if [ -n "$LOCAL_DIR" ]; then
        # make backup
        source_addr="$LOCAL_DIR"
        destination_addr="$remote_name:$task/"
        rclone_copy "$source_addr" "$destination_addr"
      fi
    fi

  done
}

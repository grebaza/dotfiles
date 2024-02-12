#!/usr/bin/env bash

rclone_copy() {
  /usr/bin/rclone copy \
    --update --verbose --transfers 30 \
    --checkers 8 --contimeout 60s --timeout 300s \
    --retries 3 --low-level-retries 10 --stats 10s \
    --exclude "**/.hg/**" \
    --exclude "**/.git/**" \
    --exclude "**/node_modules/**" \
    --exclude "**/env/**" \
    --exclude "**/__pycache__/**" \
    --delete-excluded \
    "$source_addr" "$destination_addr"
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
              rclone_copy
          fi;
      fi;

  done
}

share_repo() {
  if [[ -z "$1" ]]; then
    echo "Usage: share_repo <repository_directory>" >&2
    return 1
  fi

  local repo_dir="$1"

  sudo chgrp -R repos "$repo_dir"
  sudo chmod -R g+rw "$repo_dir"
  sudo find "$repo_dir" -type d -exec chmod g+s {} +
  git init --bare --shared=all "$repo_dir"
}


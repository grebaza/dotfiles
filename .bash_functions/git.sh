# shellcheck disable=SC2148
share_repo(){
  sudo chgrp -R repos "$1"
  sudo chmod -R g+rw "$1"
  sudo chmod g+s "$(find "$1" -type d)"
  git init --bare --shared=all "$1"
}

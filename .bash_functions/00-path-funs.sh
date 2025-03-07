# from: https://stackoverflow.com/questions/24515385/is-there-a-general-way-to-add-prepend-remove-paths-from-general-environment-vari
# SYNOPSIS: path_prepend varName path
# Note: Forces path into the first position, if already present.
#       Duplicates are removed too, unless they're directly adjacent.
# EXAMPLE: path_prepend PATH /usr/local/bin
_path_prepend() {
  local aux=":${!1}:"
  aux=${aux//:$2:/:}; aux=${aux#:}; aux=${aux%:}
  printf -v "$1" '%s' "${2}${aux:+:}${aux}"
}

# SYNOPSIS: path_append varName path
# Note: Forces path into the last position, if already present.
#       Duplicates are removed too, unless they're directly adjacent.
# EXAMPLE: path_append PATH /usr/local/bin
_path_append() {
  local aux=":${!1}:"
  aux=${aux//:$2:/:}; aux=${aux#:}; aux=${aux%:}
  printf -v "$1" '%s' "${aux}${aux:+:}${2}"
}

# SYNOPSIS: path_remove varName path
# Note: Duplicates are removed too, unless they're directly adjacent.
# EXAMPLE: path_remove PATH /usr/local/bin
_path_remove() {
  local aux=":${!1}:"
  aux=${aux//:$2:/:}; aux=${aux#:}; aux=${aux%:}
  printf -v "$1" '%s' "$aux"
}

path_prepend() {
  _path_prepend PATH $1
}

path_append() {
  _path_append PATH $1
}

path_remove() {
  _path_remove PATH $1
}

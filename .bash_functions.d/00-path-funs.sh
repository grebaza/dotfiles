# Optimized path manipulation functions
# Reference: https://stackoverflow.com/questions/24515385/

# _path_clean: Removes duplicate occurrences of a given path segment
# Arguments:
#   $1 - Name of the variable (a colon-separated string) to clean
#   $2 - The path segment to remove duplicates of
# Returns:
#   The cleaned string via stdout
_path_clean() {
  local varname="$1" newpath="$2"
  local aux=":${!varname}:"
  aux="${aux//:${newpath}:/:}" # Remove all duplicate occurrences
  aux="${aux#:}"               # Strip leading colon
  aux="${aux%:}"               # Strip trailing colon
  printf '%s' "$aux"
}

# _path_prepend: Forces newpath to the beginning of the colon-separated variable
_path_prepend() {
  local varname="$1" newpath="$2"
  local aux
  aux="$(_path_clean "$varname" "$newpath")"
  printf -v "$varname" '%s' "${newpath}${aux:+:}${aux}"
}

# _path_append: Forces newpath to the end of the colon-separated variable
_path_append() {
  local varname="$1" newpath="$2"
  local aux
  aux="$(_path_clean "$varname" "$newpath")"
  printf -v "$varname" '%s' "${aux}${aux:+:}${newpath}"
}

# _path_remove: Removes all occurrences of newpath from the colon-separated variable
_path_remove() {
  local varname="$1" newpath="$2"
  local aux
  aux="$(_path_clean "$varname" "$newpath")"
  printf -v "$varname" '%s' "$aux"
}

# Public functions for modifying the PATH variable
path_prepend() {
  _path_prepend PATH "$1"
}

path_append() {
  _path_append PATH "$1"
}

path_remove() {
  _path_remove PATH "$1"
}

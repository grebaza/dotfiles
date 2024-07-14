export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && path_prepend "$PYENV_ROOT/bin"
eval "$(pyenv init -)"

# Load pyenv-virtualenv automatically by adding
# the following to ~/.bashrc:
# eval "$(pyenv virtualenv-init -)"

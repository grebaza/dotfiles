# Simple Python version management
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && path_prepend "$PYENV_ROOT/bin"

# pyenv-virtualenv (pyenv-plugin to manage virtualenv)
# install cmd: `git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv`
# eval "$(pyenv virtualenv-init -)"

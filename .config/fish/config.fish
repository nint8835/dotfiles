. ~/.config/fish/aliases.fish

set -x PYENV_ROOT $HOME/.pyenv

set -x PATH $PYENV_ROOT/bin $PATH
set -x PATH $HOME/.scripts $PATH
set -x PATH $HOME/.cargo/bin $PATH

status --is-interactive; and . (pyenv init -|psub)
status --is-interactive; and . (pyenv virtualenv-init -|psub)

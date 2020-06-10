# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="$PATH:/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/share/bash-completion/completions/fzf" 2> /dev/null

# Key bindings
# ------------
source "$DOTFILES_PATH/fzf/key-bindings.zsh"

fpath+=${ZDOTDIR:-~}/.zsh_functions

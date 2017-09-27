# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/becker/.fzf/bin* ]]; then
  export PATH="$PATH:/Users/becker/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/becker/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/becker/.fzf/shell/key-bindings.zsh"


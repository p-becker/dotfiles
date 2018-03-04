# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export DOTFILES_PATH=~/dotfiles

TERM="xterm-256color"

# Hide user/hostname
DEFAULT_USER=$USER

# Installed via homebrew.
# Hardcoded because `brew --prefix` takes a long time.
export PATH="/usr/local/opt/neovim/bin:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"

export PATH="$DOTFILES_PATH/bin:$PATH"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
 export EDITOR='vim'
else
 export EDITOR='nvim'
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias vi="nvim"
alias vim="nvim"

alias b="bundle exec"
alias brc="bundle exec rails console"
alias cop="bundle exec rubocop --rails --display-cop-names"

alias ctags="/usr/local/opt/ctags/bin/ctags"
export PATH="/usr/local/opt/ctags/bin:$PATH"

alias colours='for i in {0..255}; do printf "\x1b[38;5;${i}mcolor%-5i\x1b[0m" $i ; if ! (( ($i + 1 ) % 8 )); then echo ; fi ; done'

alias tags="ctags -R --exclude=.git --exclude=node_modules --exclude=tmp --exclude=log --exclude=public"

# always ls after cd
function cd() {
    new_directory="$*";
    if [ $# -eq 0 ]; then
        new_directory=${HOME};
    fi;
    builtin cd "${new_directory}" && ls
}

# nvm
alias loadnvm=". /usr/local/opt/nvm/nvm.sh"

# https://dougblack.io/words/zsh-vi-mode.html
# vi mode instead of emacs mode
bindkey -v
function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1

# Keybindings
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

[ -f "$DOTFILES_PATH"/fzf/.fzf.zsh ] && source "$DOTFILES_PATH"/fzf/.fzf.zsh

# Rbenv
export RBENV_ROOT=~/.rbenv
# Disable for now for a tiny bit of startup speed
# Besides settings up the shim path as above, it does:
# - Adds to path and sets RBENV_SHELL (copied below)
# - Install autocompletion
# - Rehahes shims
# - Installs dispatcher for things like 'rbenv shell'
#eval "$(rbenv init -)"
export PATH=$RBENV_ROOT/shims:$RBENV_ROOT/bin:$PATH
export RBENV_SHELL=zsh
#
# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'

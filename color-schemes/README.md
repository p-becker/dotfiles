# Vim/iTerm2 Color Schemes
Picked from https://github.com/chrishunt/color-schemes.git

To test your color scheme:

```bash
$ ./script/test
```

## Railscasts Theme

![](https://raw.github.com/chrishunt/color-schemes/master/railscasts/screenshot.png)

**Vim** | [Base16](https://github.com/chriskempson/base16-vim), by Chris Kempson

    $ cp railscasts/base16-railscasts.vim ~/.vim/colors/
    $ vim ~/.vimrc

      " ~/.vimrc
      set background=dark
      colorscheme base16-railscasts

      highlight clear SignColumn
      highlight VertSplit    ctermbg=236
      highlight ColorColumn  ctermbg=237
      highlight LineNr       ctermbg=236 ctermfg=240
      highlight CursorLineNr ctermbg=236 ctermfg=240
      highlight CursorLine   ctermbg=236
      highlight StatusLineNC ctermbg=238 ctermfg=0
      highlight StatusLine   ctermbg=240 ctermfg=12
      highlight IncSearch    ctermbg=3   ctermfg=1
      highlight Search       ctermbg=1   ctermfg=3
      highlight Visual       ctermbg=3   ctermfg=0
      highlight Pmenu        ctermbg=240 ctermfg=12
      highlight PmenuSel     ctermbg=3   ctermfg=1
      highlight SpellBad     ctermbg=0   ctermfg=1

**iTerm2** | [Base16](https://github.com/chriskempson/base16-iterm2), by Chris Kempson

    $ open railscasts/base16-railscasts.dark.256.itermcolors  # adds to iTerm color list
    $ vi ~/.tmux.conf

      # ~/.tmux.conf
      set -g default-terminal "screen-256color"
      set -g status-bg colour235
      set -g status-fg white

      set-window-option -g window-status-current-fg black
      set-window-option -g window-status-current-bg green

      set -g pane-border-fg colour235
      set -g pane-border-bg black
      set -g pane-active-border-fg green
      set -g pane-active-border-bg black

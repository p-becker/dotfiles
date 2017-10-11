let mapleader = ","

set relativenumber

let dotfiles_path = $DOTFILES_PATH
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(dotfiles_path.'/vim/plugins/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" Plug 'junegunn/vim-easy-align'

" Installed via homebrew
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
" {{{
  let g:fzf_nvim_statusline = 0 " disable statusline overwriting

  nnoremap <silent> <leader>f :Files<CR>
  nnoremap <silent> <leader>b :Buffers<CR>
  nnoremap <silent> <leader>w :Windows<CR>
  nnoremap <silent> <leader>; :BLines<CR>
  " nnoremap <silent> <leader>o :BTags<CR>
  nnoremap <silent> <leader>t :Tags<CR>
  nnoremap <silent> <leader>h :History<CR>
  nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
  " nnoremap <silent> <leader>. :AgIn 

  nnoremap <silent> K :call SearchWordWithAg()<CR>
  vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
  nnoremap <silent> <leader>gc :Commits<CR>
  nnoremap <silent> <leader>gb :BCommits<CR>
  nnoremap <silent> <leader>ft :Filetypes<CR>

  imap <C-x><C-f> <plug>(fzf-complete-file-ag)
  imap <C-x><C-l> <plug>(fzf-complete-line)

  function! SearchWordWithAg()
    execute 'Ag' expand('<cword>')
  endfunction

  function! SearchVisualSelectionWithAg() range
    let old_reg = getreg('"')
    let old_regtype = getregtype('"')
    let old_clipboard = &clipboard
    set clipboard&
    normal! ""gvy
    let selection = getreg('"')
    call setreg('"', old_reg, old_regtype)
    let &clipboard = old_clipboard
    execute 'Ag' selection
  endfunction

  function! SearchWithAgInDirectory(...)
    call fzf#vim#ag(join(a:000[1:], ' '), extend({'dir': a:1}, g:fzf#vim#default_layout))
  endfunction
  command! -nargs=+ -complete=dir AgIn call SearchWithAgInDirectory(<f-args>)
" }}}

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug 'tpope/vim-surround'

Plug 'vim-syntastic/syntastic'

Plug 'janko-m/vim-test'
" Initialize plugin system
call plug#end()

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint']

" KEYBINDINGS
" vim-test
nmap <silent> <leader>rt :TestNearest<CR>
nmap <silent> <leader>rT :TestFile<CR>
nmap <silent> <leader>ra :TestSuite<CR>
nmap <silent> <leader>rr :TestLast<CR>
nmap <silent> <leader>rv :TestVisit<CR>

map <C-n> :NERDTreeToggle<CR>
" How can I close vim if the only window left open is a NERDTree?
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Easier pane navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Split down and to the right
set splitbelow
set splitright

" Colors
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

" Always display filename in status bar
set statusline+=%f
set laststatus=2

" http://www.markcampbell.me/2016/04/12/setting-up-yank-to-clipboard-on-a-mac-with-vim.html
" yank to clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif

" Improve performance
" Use old regex engine to fix lag when editing ruby files
autocmd FileType ruby setlocal re=1
set ttyfast
set lazyredraw
" Nice, but disable this for more speed
set cursorline
" https://github.com/scrooloose/vimfiles/blob/master/vimrc
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
"display tabs and trailing spaces
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

set hlsearch
set incsearch   "find the next match as we type the search

set wrap        "dont wrap lines
set linebreak   "wrap lines at convenient points

"undo settings
" https://vi.stackexchange.com/questions/6/how-can-i-use-the-undofile
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
if !isdirectory($HOME."/.vim/swapfiles")
    call mkdir($HOME."/.vim/swapfiles", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile

set directory=~/.vim/swapfiles//

set colorcolumn=+1 "mark the ideal max text width

"default indent settings
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

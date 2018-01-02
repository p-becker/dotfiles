let mapleader = ","

set relativenumber
set number

set ignorecase

" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" Keep Plugin commands between vundle#begin/end.
" Installed via homebrew
"Plugin 'file:///usr/local/opt/fzf'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
" {{{
  let g:fzf_nvim_statusline = 0 " disable statusline overwriting

  " FIND STUFF <leader>f
  nnoremap <silent> <leader>ff :Files<CR>
  nnoremap <silent> <leader>fb :Buffers<CR>
  nnoremap <silent> <leader>fw :Windows<CR>
  nnoremap <silent> <leader>f; :BLines<CR>
  " nnoremap <silent> <leader>o :BTags<CR>
  nnoremap <silent> <leader>ft :Tags<CR>
  nnoremap <silent> <leader>fh :History<CR>

  nnoremap <silent> <leader>a :Ag<CR>
  nnoremap <silent> <leader>A :call SearchWordWithAg()<CR>
  vnoremap <silent> <leader>A :call SearchVisualSelectionWithAg()<CR>

  noremap <silent> <leader>fgc :Commits<CR>
  nnoremap <silent> <leader>fgb :BCommits<CR>
  " Currently unused and should be remapped to prevent slowing down
  " <leader>f
  " nnoremap <silent> <leader>ft :Filetypes<CR>

  imap <C-x><C-f> <plug>(fzf-complete-file-ag)
  imap <C-x><C-l> <plug>(fzf-complete-line)
  imap <C-x><C-p> <plug>(fzf-complete-path)

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
Plugin 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plugin 'tpope/vim-surround'

Plugin 'vim-syntastic/syntastic'

Plugin 'ruanyl/coverage.vim'

Plugin 'janko-m/vim-test'

Plugin 'tpope/vim-fugitive'

Plugin 'benmills/vimux'

Plugin 'tpope/vim-dispatch'

Plugin 'pangloss/vim-javascript'

Plugin 'mxw/vim-jsx'

Plugin 'tpope/vim-unimpaired'

Plugin 'scrooloose/nerdcommenter'

Plugin 'vim-ruby/vim-ruby'

Plugin 'tpope/vim-rails'

Plugin 'tpope/vim-rbenv'

Plugin 'tpope/vim-bundler'

Plugin 'KeitaNakamura/neodark.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required, Specify a directory for plugins

" coverage.vim
let g:coverage_json_report_path = 'coverage/coverage-final.json'
let g:coverage_sign_covered = '⦿'
let g:coverage_interval = 5000
let g:coverage_show_covered = 0
let g:coverage_show_uncovered = 1

" Status line
" Reset statusline in case vimrc gets sourced again
set statusline=
" Display filename in status bar
set statusline+=%f

"modified flag
set statusline+=%#warningmsg#
set statusline+=%m
set statusline+=%*

"read only flag
set statusline+=%#identifier#
set statusline+=%r
set statusline+=%*

set statusline+=%{fugitive#statusline()}

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%#warningmsg#
set statusline+=%{StatuslineTrailingSpaceWarning()}
set statusline+=%*

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%=      "left/right separator
"set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning
" Search for trailing whitespace
nnoremap <leader>wf /\s\+$<CR>
" Remove all trailing whitespace
nnoremap <leader>wd :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")

        if !&modifiable
            let b:statusline_trailing_space_warning = ''
            return b:statusline_trailing_space_warning
        endif

        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction

function! StatuslineCurrentUser()
    return '[' . $VIMUSER . '] '
endfunction

"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let b:statusline_tab_warning = ''

        if !&modifiable
            return b:statusline_tab_warning
        endif

        let tabs = search('^\t', 'nw') != 0

        "find spaces that arent used as alignment in the first indent column
        let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"The reason for this guard is that calling syntax enable multiple times, like when sourcing your .vimrc repeatedly, it will clobber any color highlighting you already have set up. I've seen this clobber NERDTree highlighting, among other things, without the guard.
if !exists("g:syntax_on")
    syntax enable
endif

"syntastic settings
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_enable_highlighting=1
let g:syntastic_enable_signs=1
highlight SyntasticErrorLine guibg=#550000
highlight SyntasticWarningLine guibg=#331d1e

let g:syntastic_javascript_checkers = ['eslint']
let syntastic_stl_format = '[Syntax: %E{line:%fe }%W{#W:%w}%B{ }%E{#E:%e}]'

let test#strategy = "basic"
let test#ruby#rspec#executable = 'spring rspec'
" KEYBINDINGS
" vim-test
nmap <silent> <leader>tt :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ta :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>

map <leader>n :NERDTreeToggle<CR>
map <leader>N :NERDTreeFind<CR>

" How can I close vim if the only window left open is a NERDTree?
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"nerdtree settings
let g:NERDTreeWinSize = 40
let g:NERDTreeMinimalUI=1

" Easier pane navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" provide hjkl movements in Insert mode via the <Alt> modifier key
inoremap <A-h> <C-o>h
inoremap <A-j> <C-o>j
inoremap <A-k> <C-o>k
inoremap <A-l> <C-o>l

"make Y consistent with C and D
nnoremap Y y$

" Run current file in interactive ruby shell
nnoremap <leader>ri :!irb -r %:p<CR>

" Save in one keypress
nnoremap <F19> :update<cr>
inoremap <F19> <Esc>:update<cr>

" Split down and to the right
set splitbelow
set splitright

" Colors
" 24 bit true colors
set termguicolors

set background=dark
colorscheme neodark

" Improve terminal colors
let g:terminal_color_0  = '#1F2F38'
let g:terminal_color_1  = '#DC657D'
let g:terminal_color_2  = '#84B97C'
let g:terminal_color_3  = '#F0C674'
let g:terminal_color_4  = '#639EE4'
let g:terminal_color_5  = '#E69CA0'
let g:terminal_color_6  = '#4BB1A7'
let g:terminal_color_7  = '#C7C18B'
let g:terminal_color_8  = '#263A45'
let g:terminal_color_9  = '#D75F87'
let g:terminal_color_10 = '#87AF87'
let g:terminal_color_11 = '#D7AF5F'
let g:terminal_color_12 = '#5FD7D7'
let g:terminal_color_13 = '#D7AFAF'
let g:terminal_color_14 = '#5FD7D7'
let g:terminal_color_15 = '#3A3A3A'

highlight clear SignColumn

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
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

"when copying/pasting from the term into :e from a git diff or rspec or
"similar we edit things like
"
"./app/models/foo.rb:10:in
"
"Save the time of stripping trailing shit and just make this edit and go to
"line 10.
autocmd bufenter * call s:checkForLnum()
function! s:checkForLnum() abort
    let fname = expand("%:f")
    if fname =~ ':\d\+\(:.*\)\?$'
        let lnum = substitute(fname, '^.*:\(\d\+\)\(:.*\)\?$', '\1', '')
        let realFname = substitute(fname, '^\(.*\):\d\+\(:.*\)\?$', '\1', '')
        bwipeout
        exec "edit " . realFname
        doautocmd bufread
        doautocmd bufreadpre
        call cursor(lnum, 1)
    endif
endfunction

" GIT STUFF <leader>g
" Tig
nnoremap <leader>gt :Silent tig<CR>
nnoremap <leader>gg :Silent tig %<CR>

" Git commit with message
nnoremap <leader>gc :Silent git add .; git commit<CR> :execute '!git push'<CR>

" Git WIP commit and push
nnoremap <leader>gw :Silent git add .; git commit -m 'WIP'<CR> :execute '!git push'<CR>

" Git diff with fugitive
nnoremap <leader>gd :Gdiff<CR>

" Clear search highlight
map <leader>h :noh<cr>

" Search and replace
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

" Syntax highlighting for .thor files
autocmd BufNewFile,BufRead *.thor set syntax=ruby

let b:easytags_async = 1
let g:easytags_auto_highlight = 0
let g:easytags_events = ['BufWritePost']
let ruby_space_errors = 1

" https://stackoverflow.com/questions/44002912/how-to-scroll-the-terminal-emulator-in-neovim
if has("nvim")
  " Make escape work in the Neovim terminal.
  tnoremap <Esc> <C-\><C-n>

  " Make navigation into and out of Neovim terminal splits nicer.
  tnoremap <C-h> <C-\><C-N><C-w>h
  tnoremap <C-j> <C-\><C-N><C-w>j
  tnoremap <C-k> <C-\><C-N><C-w>k
  tnoremap <C-l> <C-\><C-N><C-w>l

  " I like relative numbering when in normal mode.
  autocmd TermOpen * setlocal conceallevel=0 colorcolumn=0 relativenumber

  " Prefer Neovim terminal insert mode to normal mode.
  autocmd BufEnter term://* startinsert
endif

" fzf configuration
execute "source ".fnameescape(dotfiles_path)."/vim/fzf.vim"

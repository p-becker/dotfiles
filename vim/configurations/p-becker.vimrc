let mapleader = ","

set relativenumber
set number

set ignorecase

" https://github.com/mislav/thoughtbot-dotfiles/blob/master/vimrc
let vimrc_bundle_file = expand(fnameescape(dotfiles_path)."/vim/configurations/p-becker.vimrc.bundles")
if filereadable(vimrc_bundle_file)
  exec "source " . g:vimrc_bundle_file
end

filetype plugin indent on    " required, Specify a directory for plugins
" Only needed when polyglot is used
"let g:polyglot_disabled = ['elm']
let g:elm_detailed_complete = 1
let g:elm_format_autosave = 1
let g:elm_syntastic_show_warnings = 1

" coverage.vim
let g:coverage_json_report_path = 'coverage/coverage-final.json'
let g:coverage_sign_covered = '⦿'
let g:coverage_interval = 5000
let g:coverage_show_covered = 0
let g:coverage_show_uncovered = 1

" Status line
" Always show the status line
set laststatus=2
" Disable default mode indicator in favor of vim-airline
set noshowmode
" Slim down the status bar provided by vim-airline
let g:airline_section_b = airline#section#create([])
let g:airline_section_c = airline#section#create('%<%<%{airline#extensions#fugitiveline#bufname()}%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#')
let g:airline_section_x = airline#section#create('%{airline#util#wrap(airline#extensions#branch#get_head(),0)}')
let g:airline_section_y = airline#section#create([])
let g:airline_section_z = airline#section#create(['%3p%% %{g:airline_symbols.linenr}%#__restore__#%L%#__restore__#L'])

" Search for trailing whitespace
nnoremap <leader>wf /\s\+$<CR>
" Remove all trailing whitespace
nnoremap <leader>wd :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

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

let test#strategy = "basic"
let test#ruby#rspec#executable = 'spring rspec'
" KEYBINDINGS
" vim-test
nmap <silent> <leader>tt :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ta :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>

" Codewars test framework
nmap <silent> <leader>tk :call TestKata()<CR>

function! TestKata()
  execute "vsplit | terminal ruby % | lynx --stdin"
endfunction

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

" Switch tabs
nnoremap <A-h> :tabp<CR>
nnoremap <A-l> :tabn<CR>
"make Y consistent with C and D
nnoremap Y y$

" Set default shell to zsh
set shell=/usr/local/bin/zsh
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
nnoremap <leader>gt :Start tig<CR>
nnoremap <leader>gg :Start tig %<CR>

" Git commit with message
nnoremap <leader>gc :Start git add .; git commit; git push<CR>

" Git WIP commit and push
nnoremap <leader>gw :call WipCommitAndPush()<CR>

function! WipCommitAndPush()
  silent exec "!git add .; git commit -m 'WIP'; git push"
endfunction

" Git diff with fugitive
nnoremap <leader>gd :Gdiff<CR>

" Clear search highlight
map <leader>h :noh<cr>

" Search and replace
nnoremap <leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

" Syntax highlighting for .thor files
autocmd BufNewFile,BufRead *.thor set syntax=ruby

" Update ctags upon save
let ctags_command = 'ctags -R --exclude=.git --exclude=node_modules --exclude=tmp --exclude=log --exclude=public'
autocmd BufWritePost *.rb,*.js,*.jsx,*.elm call jobstart(ctags_command)

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

" nvim-miniyank
nmap p <Plug>(miniyank-autoput)
nmap P <Plug>(miniyank-autoPut)
nmap <leader>j <Plug>(miniyank-cycle)
nmap <leader>p :Denite -mode=normal -winheight=10 miniyank<CR>

" fzf configuration
execute "source ".fnameescape(dotfiles_path)."/vim/fzf.vim"

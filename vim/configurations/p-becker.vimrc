" ----- SETTINGS -----
set relativenumber
set number
set ignorecase
" Set default shell to zsh
set shell=/usr/local/bin/zsh

" https://github.com/mislav/thoughtbot-dotfiles/blob/master/vimrc
let vimrc_bundle_file = expand(fnameescape(dotfiles_path)."/vim/configurations/p-becker.vimrc.bundles")
if filereadable(vimrc_bundle_file)
  exec "source " . g:vimrc_bundle_file
end

" Indentation
filetype plugin indent on    " required, Specify a directory for plugins
"default indent settings
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
" Use 4 spaces of indentation for some files
autocmd BufRead,BufNewFile *.ftl,*.java setl sw=4 sts=4 et
" -------------

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
" List match count in statusline
" mapping
nmap n <Plug>(anzu-n)
nmap N <Plug>(anzu-N)
nmap * <Plug>(anzu-star)
nmap # <Plug>(anzu-sharp)
set statusline=%{anzu#search_status()}

" Search for trailing whitespace
nnoremap <leader>wf /\s\+$<CR>
" Remove all trailing whitespace
nnoremap <leader>wd :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

"The reason for this guard is that calling syntax enable multiple times, like when sourcing your .vimrc repeatedly, it will clobber any color highlighting you already have set up. I've seen this clobber NERDTree highlighting, among other things, without the guard.
if !exists("g:syntax_on")
    syntax enable
endif

" How can I close vim if the only window left open is a NERDTree?
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let test#strategy = "basic"
let test#ruby#rspec#executable = 'bin/spring rspec'

" Split down and to the right
set splitbelow
set splitright

" Colors
" 24 bit true colors
set termguicolors
set background=dark
colorscheme neodark
" Improve terminal colors
let g:terminal_color_0  = '#1F2F38' " #1F2F38'
let g:terminal_color_1  = '#DC657D' " #DC657D'
let g:terminal_color_2  = '#84B97C' " #84B97C'
let g:terminal_color_3  = '#F0C674' " #F0C674'
let g:terminal_color_4  = '#639EE4' " #639EE4'
let g:terminal_color_5  = '#E69CA0' " #E69CA0'
let g:terminal_color_6  = '#4BB1A7' " #4BB1A7'
let g:terminal_color_7  = '#C7C18B' " #C7C18B'
let g:terminal_color_8  = '#263A45' " #263A45'
let g:terminal_color_9  = '#D75F87' " #D75F87'
let g:terminal_color_10 = '#87AF87' " #87AF87'
let g:terminal_color_11 = '#D7AF5F' " #D7AF5F'
let g:terminal_color_12 = '#5FD7D7' " #5FD7D7'
let g:terminal_color_13 = '#D7AFAF' " #D7AFAF'
let g:terminal_color_14 = '#5FD7D7' " #5FD7D7'
let g:terminal_color_15 = '#3A3A3A' " #3A3A3A'
" ------

" yank to clipboard
" http://www.markcampbell.me/2016/04/12/setting-up-yank-to-clipboard-on-a-mac-with-vim.html
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
set list        "display tabs and trailing spaces
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

set hlsearch
set incsearch   "find the next match as we type the search

set wrap        "dont wrap lines
set linebreak   "wrap lines at convenient points

set colorcolumn=+1 "mark the ideal max text width

" undo settings
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
" ------------

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

" Syntax highlighting for .thor files
autocmd BufNewFile,BufRead *.thor set syntax=ruby

" Update ctags upon save
let ctags_command = 'ctags -R'
autocmd BufWritePost *.rb,*.js,*.jsx,*.elm,*.java call jobstart(ctags_command)

" Clear search highlight after save
function! SearchHlClear()
  let @/ = ''
endfunction
autocmd BufWritePost * call SearchHlClear()

let ruby_space_errors = 1

" Terminal mode improvements
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

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

let mapleader = ","
" ----- KEYBINDINGS -----
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

" Run current file in interactive ruby shell
nnoremap <leader>ri :!irb -r %:p<CR>

" Save in one keypress
nnoremap <F6> :update<cr>
inoremap <F6> <Esc>:update<cr>

" Autocomplete
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>

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
" -------

" Diff two windows
nnoremap <leader>d :call ToggleWindoDiff()<cr>

let g:windodiff_open = 0

function! ToggleWindoDiff()
  if g:windodiff_open
    windo diffoff
    let g:windodiff_open = 0
  else
    windo diffthis
    let g:windodiff_open = 1
  endif
endfunction
" ---------------

" Clear search highlight and preview window
map <leader>h :noh<CR>:pc<cr>


" Search and replace
nnoremap <leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>

" Position cursor AFTER last pasted character, not on it
noremap p gp
noremap P gP
" Old behavior
noremap gp p
noremap gP P

" ----- PLUGIN SPECIFIC CONFIGURATION -----
" ale
" Styling for linter errors
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'

exe 'highlight ALEErrorSign guibg=NONE guifg='.g:terminal_color_9
exe 'highlight ALEWarningSign guibg=NONE guifg='.g:terminal_color_11
" Don't run until file gets saved
let g:ale_lint_on_text_changed = 'never'
" ---

"nerdtree settings
let g:NERDTreeWinSize = 40
let g:NERDTreeMinimalUI=1

" vim-yankstack
nmap <Leader>p <Plug>yankstack_substitute_older_paste
nmap <Leader>P <Plug>yankstack_substitute_newer_paste
" -------------

" vim-localorie
nnoremap <silent> <leader>lt :call localorie#translate()<CR>
nnoremap <silent> <leader>le :call localorie#expand_key()<CR>
" -------------

" Neosnippet
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" -------------

" vim-javacomplete2
autocmd FileType java setlocal omnifunc=javacomplete#Complete

" Default mappings
nmap <leader>jI <Plug>(JavaComplete-Imports-AddMissing)
nmap <leader>jR <Plug>(JavaComplete-Imports-RemoveUnused)
nmap <leader>ji <Plug>(JavaComplete-Imports-AddSmart)
nmap <leader>jii <Plug>(JavaComplete-Imports-Add)

imap <C-j>I <Plug>(JavaComplete-Imports-AddMissing)
imap <C-j>R <Plug>(JavaComplete-Imports-RemoveUnused)
imap <C-j>i <Plug>(JavaComplete-Imports-AddSmart)
imap <C-j>ii <Plug>(JavaComplete-Imports-Add)

nmap <leader>jM <Plug>(JavaComplete-Generate-AbstractMethods)

imap <C-j>jM <Plug>(JavaComplete-Generate-AbstractMethods)

nmap <leader>jA <Plug>(JavaComplete-Generate-Accessors)
nmap <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
nmap <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
nmap <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)
nmap <leader>jts <Plug>(JavaComplete-Generate-ToString)
nmap <leader>jeq <Plug>(JavaComplete-Generate-EqualsAndHashCode)
nmap <leader>jc <Plug>(JavaComplete-Generate-Constructor)
nmap <leader>jcc <Plug>(JavaComplete-Generate-DefaultConstructor)

imap <C-j>s <Plug>(JavaComplete-Generate-AccessorSetter)
imap <C-j>g <Plug>(JavaComplete-Generate-AccessorGetter)
imap <C-j>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)

vmap <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
vmap <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
vmap <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)

nmap <silent> <buffer> <leader>jn <Plug>(JavaComplete-Generate-NewClass)
nmap <silent> <buffer> <leader>jN <Plug>(JavaComplete-Generate-ClassInFile)
" -----------------

" vim-livedown
nmap <leader>mp :LivedownPreview<CR>
nmap <leader>mt :LivedownToggle<CR>
" ------------

" elm-vim
" Only needed when polyglot is used
"let g:polyglot_disabled = ['elm']
let g:elm_detailed_complete = 1
let g:elm_format_autosave = 1
let g:elm_syntastic_show_warnings = 1
" -------

" coverage.vim
let g:coverage_json_report_path = 'coverage/coverage-final.json'
let g:coverage_sign_covered = '⦿'
let g:coverage_interval = 5000
let g:coverage_show_covered = 0
let g:coverage_show_uncovered = 1
" ------------

" vimwiki
let g:vimwiki_list = [{'path': fnameescape(dotfiles_path).'/vim/wiki'}]

" fzf.vim
let g:fzf_nvim_statusline = 0 " disable statusline overwriting

" Search for selected text, forwards or backwards.
" http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

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

" fzf configuration
execute "source ".fnameescape(dotfiles_path)."/vim/fzf.vim"

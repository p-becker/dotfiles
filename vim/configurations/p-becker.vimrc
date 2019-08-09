" ----- SETTINGS -----
set number
set ignorecase
" Set default shell to zsh
set shell=/bin/zsh

" Indentation
filetype plugin indent on    " required, Specify a directory for plugins

" https://github.com/mislav/thoughtbot-dotfiles/blob/master/vimrc
let vimrc_bundle_file = expand(fnameescape(dotfiles_path)."/vim/configurations/p-becker.vimrc.bundles")
if filereadable(vimrc_bundle_file)
  exec "source " . g:vimrc_bundle_file
end

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
" Disable default mode indicator and ruler in favor of vim-airline
set noshowmode
" Slim down the status bar provided by vim-airline
let g:airline_extensions = []
let g:airline_highlighting_cache = 1
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
nmap <leader>wf /\s\+$<CR>
" Remove all trailing whitespace
nmap <leader>wd :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

"The reason for this guard is that calling syntax enable multiple times, like when sourcing your .vimrc repeatedly, it will clobber any color highlighting you already have set up. I've seen this clobber NERDTree highlighting, among other things, without the guard.
if !exists("g:syntax_on")
    syntax enable
endif

" How can I close vim if the only window left open is a NERDTree?
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let test#strategy = "basic"
let test#ruby#rspec#executable = 'bin/rspec'

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
set nocursorline
set norelativenumber
set noruler
" Don't display keystrokes, significantly slows vim down :<
set noshowcmd
" Prevent syntax highlighting getting bogged down by long lines
set synmaxcol=300
"set lazyredraw

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
"let ctags_command = 'ctags -R'
"autocmd BufWritePost *.rb,*.js,*.jsx,*.elm,*.java call jobstart(ctags_command)

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
  autocmd TermOpen term://* startinsert

endif

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

let mapleader = ","
let maplocalleader = ","
" ----- KEYBINDINGS -----
" No need for ex mode
nnoremap Q <nop>

" vim-test
nmap <silent> <leader>tt :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ta :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>
nmap <silent> <leader>tm :call TestMutations()<CR>
" Xunit test runner was removed with xunit 2.4
let test#csharp#runner = 'dotnettest'
"let test#csharp#dotnettest#options = '--no-build'

" Temporarily install mutant gem, run on current file
function! TestMutations()
  let l:mutation_executable = expand(fnameescape(g:dotfiles_path)."/bin/mutest_file")
  execute 'terminal '.mutation_executable.' '.expand('%')
  startinsert
endfunction

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
nnoremap <leader>dg :Gdiff<CR>
" -------

" Diff two windows
nnoremap <leader>dw :call ToggleWindoDiff()<cr>

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


" ----- PLUGIN SPECIFIC CONFIGURATION -----
" Gutentags
let g:gutentags_ctags_exclude = ["*.min.js", "*.min.css", "docker", "data", ".git", "node_modules", "tmp", "log", "public", "assets", "coverage", "*.sql"]

" ale
" Styling for linter errors
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'

exe 'highlight ALEErrorSign guibg=NONE guifg='.g:terminal_color_9
exe 'highlight ALEWarningSign guibg=NONE guifg='.g:terminal_color_11
" Don't run until file gets saved
let g:ale_lint_on_text_changed = 'never'
let g:ale_fixers = {'ruby': ['rubocop'], 'typescript': ['tslint']}
let g:ale_ruby_rubocop_options = '--rails'
let g:ale_fix_on_save = 0
let g:ale_dockerfile_hadolint_use_docker='yes'
let g:ale_linters = { 'cs': ['OmniSharp'] }
let g:nremap = {"[a": "", "]a": ""}
nnoremap [a :ALEPreviousWrap<cr>
nnoremap ]a :ALENextWrap<cr>
" ---

"nerdtree settings
let g:NERDTreeWinSize = 40
let g:NERDTreeMinimalUI=1

" vim-yankstack
" Must happen before any mapping involving y,d,c,p etc
call yankstack#setup()
" Position cursor AFTER last pasted character, not on it
noremap p gp
noremap P gP
" Old behavior
noremap gp p
noremap gP P
nmap <Leader>p <Plug>yankstack_substitute_older_paste
nmap <Leader>P <Plug>yankstack_substitute_newer_paste
"
"make Y consistent with C and D
nnoremap Y y$
" -------------

" vim-localorie
nnoremap <silent> <leader>lt :call localorie#translate()<CR>
nnoremap <silent> <leader>le :call localorie#expand_key()<CR>
" -------------

" vim-livedown
nmap <leader>mp :LivedownPreview<CR>
nmap <leader>mt :LivedownToggle<CR>
" ------------

" elm-vim
" Only needed when polyglot is used
"let g:polyglot_disabled = ['elm']
"let g:elm_detailed_complete = 1
"let g:elm_format_autosave = 1
" -------

" omnisharp-vim
let g:OmniSharp_selector_ui = 'fzf'
let g:OmniSharp_highlight_types = 1
" Use default embedded mono
let g:OmniSharp_server_use_mono = 0

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
nnoremap <a-cr> :OmniSharpGetCodeActions<CR>
" Run code actions with text selected in visual mode to extract method
xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>
xnoremap <a-cr> :call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
nnoremap <leader>r :OmniSharpRename<CR>
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

nnoremap <Leader>cf :OmniSharpCodeFormat<CR>
nnoremap <Leader>dr :terminal dotnet run

" Start the omnisharp server for the current solution
"nnoremap <Leader>ss :OmniSharpStartServer<CR>
"nnoremap <Leader>sp :OmniSharpStopServer<CR>

" Update the highlighting whenever leaving insert mode
autocmd InsertLeave *.cs call OmniSharp#HighlightBuffer()
" The following commands are contextual, based on the cursor position.
autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

" Finds members in the current buffer
autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>
autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
autocmd FileType cs nnoremap <buffer> <Leader>lt :OmniSharpTypeLookup<CR>
autocmd FileType cs nnoremap <buffer> <Leader>ld :OmniSharpDocumentation<CR>
autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

set updatetime=500

sign define OmniSharpCodeActions text=💡

function! OSCountCodeActions() abort
  if OmniSharp#CountCodeActions({-> execute('sign unplace 99')})
    let l = getpos('.')[1]
    let f = expand('%:p')
    execute ':sign place 99 line='.l.' name=OmniSharpCodeActions file='.f
  endif
endfunction

augroup OSCountCodeActions
  autocmd!
  autocmd FileType cs set signcolumn=yes
  autocmd CursorHold *.cs call OSCountCodeActions()
augroup END

" coverage.vim
"let g:coverage_json_report_path = 'coverage/coverage-final.json'
"let g:coverage_sign_covered = '⦿'
"let g:coverage_interval = 5000
"let g:coverage_show_covered = 0
"let g:coverage_show_uncovered = 1
" ------------

" vimwiki
let g:vimwiki_list = [{'path': fnameescape(dotfiles_path).'/vim/wiki',
                       \ 'syntax': 'markdown', 'ext': '.md'}]


let g:vimtex_compiler_progname = 'nvr'

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

nnoremap <Leader>ot :sp term://zsh<CR>

" FIND STUFF <leader>f
nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>fw :Windows<CR>
nnoremap <silent> <leader>f; :BLines<CR>
" nnoremap <silent> <leader>o :BTags<CR>
nnoremap <silent> <leader>ft :Tags<CR>
nnoremap <silent> <leader>fh :History<CR>

nnoremap <silent> <leader>a :Rg<CR>
nnoremap <silent> <leader>A :call SearchWordWithRg()<CR>
vnoremap <silent> <leader>A :call SearchVisualSelectionWithRg()<CR>

noremap <silent> <leader>fgc :Commits<CR>
nnoremap <silent> <leader>fgb :BCommits<CR>
" Currently unused and should be remapped to prevent slowing down
" <leader>f
" nnoremap <silent> <leader>ft :Filetypes<CR>

imap <C-x><C-f> <plug>(fzf-complete-file-ag)
imap <C-x><C-l> <plug>(fzf-complete-line)
imap <C-x><C-p> <plug>(fzf-complete-path)

function! SearchWordWithRg()
  execute 'Rg' expand('<cword>')
endfunction

function! SearchVisualSelectionWithRg() range
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  let old_clipboard = &clipboard
  set clipboard&
  normal! ""gvy
  let selection = getreg('"')
  call setreg('"', old_reg, old_regtype)
  let &clipboard = old_clipboard
  execute 'Rg' selection
endfunction

function! SearchWithAgInDirectory(...)
  call fzf#vim#ag(join(a:000[1:], ' '), extend({'dir': a:1}, g:fzf#vim#default_layout))
endfunction
command! -nargs=+ -complete=dir AgIn call SearchWithAgInDirectory(<f-args>)

" fzf configuration
execute "source ".fnameescape(dotfiles_path)."/vim/fzf.vim"

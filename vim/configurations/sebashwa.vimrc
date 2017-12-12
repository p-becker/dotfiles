set encoding=utf-8
filetype on
autocmd BufNewFile,BufRead *.json.jbuilder set ft=ruby
let mapleader=','
set termguicolors

" Highlight search results
set hlsearch

" Make it possible to change files without saving prompt
set hidden

" Write while closing files
set autowrite

" Split windows in this order
set splitright
set splitbelow

" Never wrap lines
set nowrap

" Indenting options
set autoindent
set smartindent
set tabstop=2 softtabstop=2 expandtab shiftwidth=2

" Folding method
set foldmethod=syntax
set foldnestmax=3
set foldlevelstart=99

" Set chars for spaces
set list listchars=tab:\ \ ,trail:·

" Ignore files
set wildignore+=*/tmp/*,*/vendor/*,*.so,*.swp,*.zip

" Disable swap files
set noswapfile

" Set line numbers
set number

" Always show status bar
set laststatus=2

" Mappings
map <Leader><CR> :w<CR>
nmap m<CR> :noh<CR>
nnoremap <Space> :e<CR>
nnoremap <Leader>co :copen<CR>
nnoremap <Leader>cc :cclose<CR>
nnoremap <Leader>cn :cnext<CR>
nnoremap <Leader>cp :cprev<CR>
inoremap kj <Esc>l
inoremap kJ <Esc>l
inoremap Kj <Esc>l
inoremap jj <Esc>l
inoremap jJ <Esc>l
inoremap Jj <Esc>l

" ---------------
" --> PLUGINS <--
" ---------------

call plug#begin('~/.nvim/plugged')

" Colors
Plug 'KeitaNakamura/neodark.vim'
let g:neodark#background = '#414141'

" Misc
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-abolish'
Plug 'AndrewRadev/splitjoin.vim'

" Languages
Plug 'dag/vim2hs'
Plug 'kchmck/vim-coffee-script'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'udalov/kotlin-vim'

" Multicursor
Plug 'terryma/vim-multiple-cursors'
let g:multi_cursor_exit_from_insert_mode = 0

" Yankstack
Plug 'maxbrunsfeld/vim-yankstack'
nmap <Leader>p <Plug>yankstack_substitute_older_paste
nmap <Leader>P <Plug>yankstack_substitute_newer_paste

" Reusable terminal
Plug 'kassio/neoterm'
let g:neoterm_size = 15
let g:neoterm_autoscroll = 1

" Vimwiki
Plug 'vimwiki/vimwiki'
let g:vimwiki_list = [{'path': '~/.notes/',
                     \ 'syntax': 'markdown', 'ext': '.md'}]

" Statusline
Plug 'itchyny/lightline.vim'
let g:lightline = { 'colorscheme': 'neodark' }
set noshowmode

" Filetree
Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }
map <Leader>n :NERDTreeToggle<CR>
map <Leader>N :NERDTreeFind<CR>

"Distraction-free writing
Plug 'junegunn/goyo.vim'

" Fuzzy Find
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
map <Leader>f :Files<CR>
map <Leader>b :Buffers<CR>
map <Leader>g :GFiles?<CR>
map <Leader>a :Ag 
map <Leader>A :Ag<CR>

" Linting
Plug 'neomake/neomake'
let g:neomake_ruby_rubocop_exe = '/usr/bin/env'
let g:neomake_ruby_rubocop_args = ['bundle', 'exec', 'rubocop', '--rails', '--display-cop-names']
let g:neomake_javascript_eslint_exe = system('PATH=$(npm bin):$PATH && which eslint | tr -d "\n"')
autocmd! BufWritePost * Neomake

" Testing
Plug 'janko-m/vim-test'
nmap <silent> <Leader>R :Topen<CR>:TestNearest<CR>
nmap <silent> <Leader>r :Topen<CR>:TestFile<CR>
nmap <silent> <Leader>s :Topen<CR>:TestSuite<CR>
let test#strategy = "neoterm"
let test#ruby#minitest#executable = 'bundle exec rake'
let test#javascript#runner#executable = 'NODE_ENV=test ./node_modules/.bin/jest'
let test#javascript#jest#executable = 'NODE_ENV=test ./node_modules/.bin/jest'
let test#javascript#jest#file_pattern = '^.*\.test\.js.*$'
let test#javascript#mocha#executable = 'NODE_ENV=test ./node_modules/.bin/mocha src/setup.test.js'
" let test#javascript#mocha#options = '--compilers js:babel-register,js:babel-polyfill'
" let test#javascript#mocha#file_pattern = '\.test\.js$'

call plug#end()

colorscheme neodark

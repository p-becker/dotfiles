" From http://afnan.io/2018-04-12/my-neovim-development-setup/

" deoplete.vim contains vim settings relevant to the deoplete autocompletion
" plugin
set runtimepath+=~/.vim/bundle/deoplete.nvim/
set completeopt=longest,menuone,preview
" Hide completion match message
set shortmess +=c
"
" deoplete options
let g:deoplete#enable_at_startup = 1

" Disable the candidates in Comment/String syntaxes.
"call deoplete#custom#source('_',
"            \ 'disabled_syntaxes', ['Comment', 'String'])

"autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" disable autocomplete by default
"call deoplete#custom#option({
      "\ 'auto_complete': v:false,
      "\ 'smart_case': v:true
      "\ })
"" set sources
"call deoplete#custom#option('sources', {
      "\ '_': ['around'],
      "\ 'ruby': ['ultisnips'],
      "\ 'typescript': ['typescript'],
      "\ 'typescript.tsx': ['typescript'],
      "\ 'vim': ['vim'],
      "\})

"inoremap <expr> <C-n> deoplete#mappings#manual_complete('around')
"" Use tab to trigger autocomplete + move to next entry
inoremap <expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

" Close autocomplete menu with Enter
imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" close preview window on leaving the insert mode
autocmd InsertLeave * if pumvisible() == 0 | pclose | endif

" Snippets
let g:UltiSnipsExpandTrigger="<C-j>"

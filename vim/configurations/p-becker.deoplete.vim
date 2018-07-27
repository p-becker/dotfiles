" From http://afnan.io/2018-04-12/my-neovim-development-setup/

" deoplete.vim contains vim settings relevant to the deoplete autocompletion
" plugin

set runtimepath+=~/.vim/bundle/deoplete.nvim/
" deoplete options
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

" disable autocomplete by default
"let b:deoplete_disable_auto_complete=1 
"let g:deoplete_disable_auto_complete=1
"call deoplete#custom#buffer_option('auto_complete', v:false)

if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
endif

" Disable the candidates in Comment/String syntaxes.
call deoplete#custom#source('_',
            \ 'disabled_syntaxes', ['Comment', 'String'])

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

call deoplete#custom#option({
      \ 'auto_complete': v:false,
      \ })
      "\ 'complete_method': 'completefunc'
inoremap <expr> <C-n> deoplete#mappings#manual_complete('around')
"let g:UltiSnipsExpandTrigger="<CR>"
let g:UltiSnipsExpandTrigger = "<nop>"
let g:ulti_expand_or_jump_res = 0
function ExpandSnippetOrCarriageReturn()
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return snippet
    else
        return "\<CR>"
    endif
endfunction
inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"
inoremap <expr> <C-x><C-s> deoplete#mappings#manual_complete('ultisnips')
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#mappings#manual_complete('around', 'LanguageClient', 'ultisnips')

function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
" set sources
let g:deoplete#sources = {}
let g:deoplete#sources.ruby = ['LanguageClient', 'around']
let g:deoplete#sources.vim = ['vim', 'around']

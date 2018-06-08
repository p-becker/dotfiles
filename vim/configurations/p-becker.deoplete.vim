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

" set sources
let g:deoplete#sources = {}
let g:deoplete#sources.ruby = ['LanguageClient', 'around']
let g:deoplete#sources.vim = ['vim', 'around']

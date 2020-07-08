" Styling for linter errors
"let g:ale_sign_error = '✘'
"let g:ale_sign_warning = '⚠'

exe 'highlight ALEErrorSign guibg=NONE guifg='.g:terminal_color_9
exe 'highlight ALEWarningSign guibg=NONE guifg='.g:terminal_color_11

" Don't run until file gets saved
let g:ale_lint_on_text_changed = 'never'
let g:ale_fixers = {'ruby': ['rubocop'], 'typescript': ['tslint']}
let g:ale_ruby_rubocop_options = '--rails'
let g:ale_linters = {
      \   'cs': ['OmniSharp'],
      \   'go': ['golint'],
      \   'proto': ['prototool-lint'],
      \}

let g:ale_fix_on_save = 0
let g:ale_dockerfile_hadolint_use_docker='yes'
let g:nremap = {"[a": "", "]a": ""}

nnoremap [a :ALEPreviousWrap<cr>
nnoremap ]a :ALENextWrap<cr>

" YAML linting from
" https://raw.githubusercontent.com/dense-analysis/ale/master/ale_linters/yaml/yamllint.vim
" Author: KabbAmine <amine.kabb@gmail.com>
call ale#Set('yaml_yamllint_executable', 'yamllint')
call ale#Set('yaml_yamllint_options', '-d relaxed')


call ale#linter#Define('yaml', {
\   'name': 'yamllint',
\   'executable': {b -> ale#Var(b, 'yaml_yamllint_executable')},
\   'command': function('ale_linters#yaml#yamllint#GetCommand'),
\   'callback': 'ale_linters#yaml#yamllint#Handle',
\})

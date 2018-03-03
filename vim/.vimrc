set nocompatible              " be iMproved, required
filetype off                  " required

let vimuser = empty($VIMUSER) ? "Default" : $VIMUSER
let dotfiles_path = $DOTFILES_PATH

function! SwitchProfile()
    if(g:vimuser == "Default")
      let g:vimuser = "majesticuser"
      "let g:vimuser = "sebashwa"
    else
      let g:vimuser = "Default"
    end

    silent exec '!osascript ~/dotfiles/scripts/switch_input_language.scpt'
    silent exec '!osascript ~/dotfiles/scripts/switch_tab.scpt '.fnameescape(g:dotfiles_path).' '.g:vimuser

    :xa
endfunction

" Improve session handling
set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds

" Save session when exiting
au VimLeave * execute 'mksession! '.fnameescape(g:dotfiles_path).'/vim/Session.vim'
" Source user configuration
execute 'source '.fnameescape(g:dotfiles_path).'/vim/configurations/'.vimuser.'.vimrc'

map <leader>m :call SwitchProfile()<CR>

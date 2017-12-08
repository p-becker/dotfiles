git clone https://github.com/bhilburn/powerlevel9k.git zsh/plugins/oh-my-zsh/custom/themes/powerlevel9k
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim  -c "PluginInstall" -c "qa"

declare -a formulas=("zsh" "fzf" "tmux" "rbenv" "vim" "Ack")

## now loop through the above array
for f in "${formulas[@]}"; do
	if ! command -v "$f" >/dev/null; then
	       while true; do
		read -p "Do you wish to install $f? [Yy/Nn]: " yn
		case $yn in
			[Yy]* ) brew install "$f"; break;;
			[Nn]* ) exit;;
			* ) echo "Please answer yes [Yy] or no [Nn].";;
		esac
		done
	else
		echo "$f is already installed."
	fi
done

mkdir -p ~/.vim/colors

git config --global core.editor $(which vim)
git config --global core.excludesfile "$PWD"/.gitignore

# Vim colors
cp color-schemes/railscasts/base16-railscasts.vim ~/.vim/colors/
cp color-schemes/lucius/lucius.vim ~/.vim/colors/

# Iterm colors
open color-schemes/railscasts/base16-railscasts.dark.itermcolors
open color-schemes/lucius/LuciusLight.itermcolors

# Iterm preferences
# http://stratus3d.com/blog/2015/02/28/sync-iterm2-profile-with-dotfiles-repository/
# Specify the preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$PWD"
# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true


npm install -g eslint
npm install -g webpack
npm install -g babel-eslint
npm install -g eslint-plugin-react
npm install -g eslint-plugin-import

echo "---"
echo "Please replace the contents of your ~/.zshrc with this:"
printf "source $PWD/zsh/.zshrc\n"
echo "Please replace the contents of your ~/.tmux.conf with this:"
printf "source-file $PWD/.tmux.conf"
echo "Please replace the contents of your ~/.tigrc with this:"
printf "source $PWD/.tigrc"
echo "---"
echo "If your shell looks weird, install_powerline_fonts.sh is your friend."

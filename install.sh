git clone https://github.com/bhilburn/powerlevel9k.git zsh/plugins/oh-my-zsh/custom/themes/powerlevel9k

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim  -c "PlugInstall" -c "qa"

declare -a formulas=("zsh" "fzf" "tmux" "rbenv")

## now loop through the above array
for f in "${formulas[@]}"; do
	if ! command -v "$f" >/dev/null; then
	       while true; do
		read -p "Do you wish to install $f?" yn
		case $yn in
			[Yy]* ) brew install "$f"; break;;
			[Nn]* ) exit;;
			* ) echo "Please answer yes or no.";;
		esac
		done
	else
		echo "$f is already installed."
	fi
done
echo "Please replace the contents of your ~/.zshrc with this:"
printf "source $PWD/zsh/.zshrc\n"
echo "If your shell looks weird, install_powerline_fonts.sh is your friend."

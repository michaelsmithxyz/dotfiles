.PHONY: all vim nvim

all: vim nvim

vim:
	@mkdir -p ~/.vim/bundle
	@cp vim/* ~/.vim/
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim -u ~/.vim/plugins.vim +PlugInstall +qall

nvim:
	@mkdir -p ~/.config/nvim/
	@cp -r nvim/* ~/.config/nvim/
	
clean:
	@rm -rf ~/.vim
	@rm -rf ~/.config/nvim

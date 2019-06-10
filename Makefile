.PHONY: vim

vim:
	@mkdir -p ~/.vim/bundle
	@cp vim/* ~/.vim/
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim -u ~/.vim/plugins.vim +PlugInstall +qall
	
clean:
	@rm -rf ~/.vim

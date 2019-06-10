.PHONY: vim

vim:
	@mkdir -p ~/.vim/bundle
	@cp vim/* ~/.vim/
	git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
	vim -u ~/.vim/plugins.vim +PluginInstall +qall
	
clean:
	@rm -rf ~/.vim

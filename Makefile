.PHONY: all nvim

all: nvim

nvim:
	@mkdir -p ~/.config/nvim/
	@cp -r nvim/* ~/.config/nvim/
	
clean:
	@rm -rf ~/.vim
	@rm -rf ~/.config/nvim

.PHONY: all
all:
	@echo "Choose a target"

.PHONY: tmux
tmux:
	@git submodule update --init
	@mkdir -p ~/.config/
	@ln -s $(realpath tmux/) ~/.config/tmux

.PHONY: nvim
nvim:
	@mkdir -p ~/.config/
	@ln -s $(realpath nvim/) ~/.config/nvim

.PHONY: ghostty
ghostty:
	@mkdir -p ~/.config/
	@ln -s $(realpath ghostty/) ~/.config/ghostty
	
.PHONY: clean
clean:
	@unlink ~/.config/tmux/
	@unlink ~/.config/nvim/

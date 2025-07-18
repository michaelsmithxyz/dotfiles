.PHONY: all
all:
	@echo "Choose a target"

.PHONY: submodules
submodules:
	@git submodule update --init

.PHONY: tmux
tmux: submodules
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

.PHONY: zsh
zsh: submodules
	@mkdir -p ~/.config/
	@ln -s $(realpath .zshenv) ~/.zshenv
	@ln -s $(realpath zsh/) ~/.config/zsh

BAT_CONFIG_DIR := $(shell bat --config-dir)

.PHONY: bat
bat:
	@ln -s $(realpath bat/) "$(BAT_CONFIG_DIR)"
	@bat cache --build
	
.PHONY: clean
clean:
	@unlink ~/.config/tmux/
	@unlink ~/.config/nvim/

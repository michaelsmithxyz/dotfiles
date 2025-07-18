BAT_CONFIG_DIR := `bat --config-dir`

[private]
default:
    @just --list

[private]
submodules:
    git submodule update --init --recursive

tmux: submodules
    @mkdir -p ~/.config/
    @ln -snf "{{`realpath tmux/`}}" ~/.config/tmux

nvim:
    @mkdir -p ~/.config/
    @ln -snf "{{`realpath nvim/`}}" ~/.config/nvim

ghostty:
    @mkdir -p ~/.config/
    @ln -snf "{{`realpath ghostty/`}}" ~/.config/ghostty

zsh: submodules
    @mkdir -p ~/.config/
    @ln -s "{{`realpath .zshenv`}}" ~/.zshenv
    @ln -snf "{{`realpath zsh/`}}" ~/.config/zsh

bat:
    @ln -snf "{{`realpath bat/`}}" "{{BAT_CONFIG_DIR}}"
    @bat cache --build

clean:
    @unlink ~/.config/tmux
    @unlink ~/.config/nvim
    @unlink ~/.config/ghostty
    @unlink ~/.zshenv
    @unlink ~/.config/zsh
    @unlink "{{BAT_CONFIG_DIR}}"


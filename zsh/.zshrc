autoload -Uz compinit


typeset -U path PATH
path=(
  $HOME/bin
  ${ASDF_DATA_DIR:-$HOME/.asdf}/shims
  ~/.local/bin 
  /opt/homebrew/bin
  $path
)
export PATH


HISTFILE="$HOME/.zsh_history"
setopt share_history
setopt hist_ignore_all_dups


ZSH_CACHE_DIR="$HOME/.cache/zsh"
if [ ! -d "$ZSH_CACHE_DIR" ]; then
  mkdir -p "$ZSH_CACHE_DIR"
fi

ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"
compinit -C -d "$ZSH_COMPDUMP"
zstyle ':completion:*:*:*:default' menu yes select search
bindkey '^[[Z' reverse-menu-complete # Shift-Tab to go backwards


source <(fzf --zsh)


alias vim="nvim"
export EDITOR="nvim"


alias ls='ls --color=auto'


if command -v starship &> /dev/null; then
  export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"
  eval "$(starship init zsh)"
fi


local_zshrc="${ZDOTDIR}/.zshrc.local"
if [ -f "${local_zshrc}" ]; then
  source "${local_zshrc}"
fi


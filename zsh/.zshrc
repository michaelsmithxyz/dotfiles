autoload -Uz compinit


if [ -d "/opt/homebrew/share/zsh/site-functions/" ]; then
  fpath+=(/opt/homebrew/share/zsh/site-functions/)
fi


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


bindkey -e


source "$ZDOTDIR/fzf/fzf.zsh"
source "$ZDOTDIR/fzf-tab/fzf-tab.plugin.zsh"


alias vim="nvim"
export EDITOR="nvim"


export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
alias ls='ls --color=auto'


if command -v starship &> /dev/null; then
  export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"
  eval "$(starship init zsh)"
fi


local_zshrc="${ZDOTDIR}/.zshrc.local"
if [ -f "${local_zshrc}" ]; then
  source "${local_zshrc}"
fi


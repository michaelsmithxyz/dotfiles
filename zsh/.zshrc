autoload -Uz compinit


if [ -d "/opt/homebrew/share/zsh/site-functions/" ]; then
  fpath+=(/opt/homebrew/share/zsh/site-functions/)
fi


typeset -U path PATH
path=(
  $HOME/bin
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


bindkey -e


alias vim="nvim"
export EDITOR="nvim"


export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
alias ls='ls --color=auto'


if command -v starship &> /dev/null; then
  export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"

  STARSHIP_INIT_CACHE="$ZSH_CACHE_DIR/starship.zsh"
  if [ ! -f "$STARSHIP_INIT_CACHE" ]; then
    starship init zsh > "$STARSHIP_INIT_CACHE"
  fi
  source "$STARSHIP_INIT_CACHE"
fi


local_zshrc="${ZDOTDIR}/.zshrc.local"
if [ -f "${local_zshrc}" ]; then
  source "${local_zshrc}"
fi


# Initialize completions /after/ sourcing `.zshrc.local` so that
# we can configure `fpath` locally too
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"
compinit -C -d "$ZSH_COMPDUMP"


FZF_INIT_CACHE="$ZSH_CACHE_DIR/fzf.zsh"
if [ ! -f "$FZF_INIT_CACHE" ]; then
  fzf --zsh > "$FZF_INIT_CACHE"
fi
source "$FZF_INIT_CACHE"
source "$ZDOTDIR/fzf-tab/fzf-tab.plugin.zsh"

ATUIN_INIT_CACHE="$ZSH_CACHE_DIR/atuin.zsh"
if [ ! -f "$ATUIN_INIT_CACHE" ]; then
  atuin init zsh > "$ATUIN_INIT_CACHE"
fi
source "$ATUIN_INIT_CACHE"

MISE_INIT_CACHE="$ZSH_CACHE_DIR/mise.zsh"
if [ ! -f "$MISE_INIT_CACHE" ]; then
  mise activate zsh > "$MISE_INIT_CACHE"
fi
source "$MISE_INIT_CACHE"

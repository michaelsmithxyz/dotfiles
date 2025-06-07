typeset -U path PATH
path=(
  /opt/homebrew/bin
  $HOME/bin
  ~/.local/bin
  # ASDF
  ${ASDF_DATA_DIR:-$HOME/.asdf}/shims
  $path
)
export PATH


HISTFILE="$HOME/.zsh_history"


export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"

plugins=(
  git
  asdf
  virtualenv
)

ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"
source $ZSH/oh-my-zsh.sh

SPACESHIP_PROMPT_ORDER=(
  dir
  git
  venv
  line_sep
  char
)


source <(fzf --zsh)


alias vim="nvim"
export EDITOR="nvim"


local_zshrc="${ZDOTDIR}/.zshrc.local"
if [ -f "${local_zshrc}" ]; then
  source "${local_zshrc}"
fi

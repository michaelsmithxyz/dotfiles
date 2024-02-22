export PATH=$HOME/bin:$PATH

export ZSH="/Users/michael/.oh-my-zsh"
ZSH_THEME="spaceship"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

SPACESHIP_PROMPT_ORDER=(
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  kubectl_context
  line_sep
  char          # Prompt character
)
export TERM=xterm-256color


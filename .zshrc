export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="amuse"
plugins=(git sudo zsh-autosuggestions zsh-syntax-highlighting starship history-search-multi-word)

source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"

export STARSHIP_CONFIG=~/.config/starship/starship.toml
#!/usr/bin/env zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
    zsh-autosuggestions
    zsh-syntax-highlighting
    command-not-found
    colored-man-pages
    colorize
    aliases
    git
)
source $ZSH/oh-my-zsh.sh
 
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

#================ exports
export PROMPT='%B%n%{%F{#813d9c}%}@%{%f%}%m%{%F{#813d9c}%}-%{%F{#813d9c}%}[%{%f%}%*%{%F{#813d9c}%}]-%{%F{#813d9c}%}[%{%f%}%~%{%F{#813d9c}%}]%b'$'\n''%{%F{#813d9c}%}[%{%f%}%?%{%F{#813d9c}%}]$(if [[ $EUID -eq 0 ]]; then echo "#"; else echo "$"; fi) %{%f%}'

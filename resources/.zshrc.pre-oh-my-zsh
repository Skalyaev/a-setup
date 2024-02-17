#!/usr/bin/env zsh
#   _________  _   _ ____   ____ 
#  |__  / ___|| | | |  _ \ / ___|
#    / /\___ \| |_| | |_) | |    
# _ / /_ ___) |  _  |  _ <| |___ 
#(_)____|____/|_| |_|_| \_\\____|
#
autoload -U compinit
compinit
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:sudo:*' command-path \
    /usr/local/sbin /usr/local/bin /usr/sbin \
    /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache
zmodload zsh/complist
setopt extendedglob
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"
 
setopt correctall
 
#================ exports
export GREP_COLOR=31
export EDITOR=/usr/bin/vim
export PROMPT='%n%{%F{red}%}@%{%f%}%m%{%F{red}%}-[%{%f%}%*%{%F{red}%}]-[%{%f%}%~%{%F{red}%}]'$'\n''$%{%f%} '

#================ aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

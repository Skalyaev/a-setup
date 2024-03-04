#!/bin/bash
alias l='ls'
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -lA'
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias l='ls --color=auto'
    alias ls='ls --color=auto'
    alias ll='ls -l --color=auto'
    alias la='ls -A --color=auto'
    alias lla='ls -lA --color=auto'
    alias dir='dir --color=auto'
    alias grep='grep --color=auto'
   
    alias colors='for i in {0..256};do o=00$i;echo -ne "${o:${#o}-3:3} "$(tput setaf $i;tput setab $i)"   "$(tput sgr0);done; echo'
fi
alias c='cp'
alias cr='cp -r'
alias m='mv'

alias r='rm'
alias rr='rm -r'
alias rf='rm -f'
alias rrf='rm -rf'

alias x='xargs'

alias vi='vim'
alias python='python3'

alias aptfull='sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y'

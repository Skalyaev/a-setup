#!/bin/bash
if [[ -x "/usr/bin/dircolors" ]]; then
    test -r "$HOME/.dircolors"\
        && eval "$(dircolors -b "$HOME/.dircolors")"\
        || eval "$(dircolors -b)"
fi

#============== FILE SYSTEM
alias f='find'
alias fd='find . -type d'
alias ff='find . -type f'
alias fl='find . -type l'
alias fdn='find . -type d -name'
alias ffn='find . -type f -name'
alias fln='find . -type l -name'
alias fdp='find . -type d -perm'
alias ffp='find . -type f -perm'
alias flp='find . -type l -perm'

alias l='ls'
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -lA'
alias lF='ls -F'
if [[ -x "/usr/bin/dircolors" ]]; then
    alias ls='ls --color=auto'
    alias l='ls --color=auto'
    alias ll='ls -l --color=auto'
    alias la='ls -A --color=auto'
    alias lla='ls -lA --color=auto'
    alias lF='ls -F --color=auto'
fi

alias t='touch'
alias md='mkdir -p'

alias cm='chmod'
alias cmx='chmod +x'

alias r='rm'
alias rr='rm -r'
alias rf='rm -f'
alias rrf='rm -rf'

#============== STRING MANIPULATION
alias e='echo'
alias en='echo -n'
alias ee='echo -e'
alias ene='echo -ne'

alias g='grep'
alias gv='grep -v'
alias gi='grep -i'
alias gvi='grep -vi'
if [[ -x "/usr/bin/dircolors" ]]; then
    alias grep='grep --color=auto'
    alias g='grep --color=auto'
    alias gv='grep -v --color=auto'
    alias gi='grep -i --color=auto'
    alias gvi='grep -vi --color=auto'
fi

alias x='xargs'
alias xi='xargs -I {}'

#============== APPLICATIONS
alias v='vim'
alias py='python3'
alias pyc='python3 -c'
alias msf='msfconsole -L'

alias gits='git status'
alias gita='git add'
alias gitc='git commit -m'
alias gitp='git push'

#============== MISC
alias fullapt='sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y'

if [[ -x "/usr/bin/dircolors" ]]; then
    alias colors='for i in {0..256};do o=00$i;echo -ne "${o:${#o}-3:3} "$(tput setaf $i;tput setab $i)"   "$(tput sgr0);done; echo'
fi

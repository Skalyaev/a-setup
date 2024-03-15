#!/bin/bash
case $- in
*i*) ;;
*) return ;;
esac

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s cdspell
shopt -s dirspell
shopt -s autocd
shopt -s cmdhist

HISTCONTROL=erasedups
HISTSIZE=1000
HISTFILESIZE=2000

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

if [ -f ~/.bash_env ]; then
    . ~/.bash_env
fi
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
PS1='${debian_chroot:+($debian_chroot)\[\033[38;5;240m\]-\[\033[00m\]}\u\[\033[38;5;240m\]@\[\033[00m\]\h\[\033[38;5;240m\]-[\[\033[00m\]\t\[\033[38;5;240m\]]-[\[\033[00m\]\w\[\033[38;5;240m\]]\[\033[00m\]\n\[\033[38;5;240m\][\[\033[00m\]$?\[\033[38;5;240m\]]\$\[\033[00m\] '

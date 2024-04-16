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
gray='\[\033[38;5;240m\]'
nc='\[\033[00m\]'
PS1="${debian_chroot:+($debian_chroot)$gray-$nc}\u$gray@$nc\h$gray-[$nc\t$gray]-[$nc\w$gray]$nc\n$gray[$nc\$?$gray]\$$nc "
eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

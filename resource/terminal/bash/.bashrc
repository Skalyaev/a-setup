#!/bin/bash
case "$-" in
*"i"*) ;;
*) return ;;
esac

shopt -s "histappend"
shopt -s "checkwinsize"
shopt -s "globstar"
shopt -s "cdspell"
shopt -s "dirspell"
shopt -s "autocd"
shopt -s "cmdhist"

HISTCONTROL="erasedups"
HISTSIZE=1000
HISTFILESIZE=2000
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

[[ -e "$HOME/.local/share/pyenv" ]]\
    && . "$HOME/.local/share/pyenv/bin/activate"
if ! shopt -oq "posix"; then
    if [[ -e "/usr/share/bash-completion/bash_completion" ]]; then
        . "/usr/share/bash-completion/bash_completion"
    elif [[ -e "/etc/bash_completion" ]]; then
        . "/etc/bash_completion"
    fi
fi
[[ -e "$HOME/.bash_env" ]] && . "$HOME/.bash_env"
[[ -e "$HOME/.bash_aliases" ]] && . "$HOME/.bash_aliases"

gray="\[\033[38;5;240m\]"
nc="\[\033[00m\]"
p1="\u$gray@$nc\h$gray"
p2="-[$nc\t$gray]"
p3="-[$nc\w$gray]$nc"
p4="$gray[$nc\$?$gray]\$$nc "
PS1="$p1$p2$p3\n$p4"
unset gray nc p1 p2 p3 p4

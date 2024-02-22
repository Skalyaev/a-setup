#!/bin/bash
PATH='/bin:/sbin:/usr/bin:/usr/sbin'
root="$1"
backup="$2"
list="$root/list"
shells="$(cat "$list/terminal/shell.md" | grep -v "^#" | grep -v "^$")"

mkdir -p "$backup"
while IFS= read -r shell; do

    if [ -e "$HOME/$shell" ]; then
	    mv "$HOME/$shell" "$backup"
    fi
    if [ "$shell" = '.zshrc' ]; then
        if [ -e "$HOME/.oh-my-zsh" ]; then
            mv "$HOME/.oh-my-zsh" "$backup"
        fi
        sh -c "$(curl -fsSL \
            'https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh')"
        git clone 'https://github.com/zsh-users/zsh-autosuggestions' \
            "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
        git clone 'https://github.com/zsh-users/zsh-syntax-highlighting.git' \
            "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    fi
    cp "$root/resources/$shell" "$HOME"

	exports=$(cat "$list/terminal/env.md" | grep -v "^#" | grep -v "^$")
	pattern='#================ exports'
    while IFS= read -r export; do
        export="$(echo "$export" | sed 's/&/\\&/g')"
        export="export $export"
        sed -i "s;$pattern;$pattern\n$export;" "$HOME/$shell"
    done <<< "$exports"

    aliases=$(cat "$list/terminal/alias.md" | grep -v "^#" | grep -v "^$")
    case "$shell"  in
        '.bashrc') alias_file='.bash_aliases';;
        '.zshrc') alias_file='.zsh_aliases';;
    esac
    if [ -e "$HOME/$alias_file" ]; then
        mv "$HOME/$alias_file" "$backup"
    fi
    while IFS= read -r alias; do
        echo "alias $alias" >> "$HOME/$alias_file"
    done <<< "$aliases"

done <<< "$shells"


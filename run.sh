#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

root=$(dirname $(realpath $0))
backup="$root/backup/$(date +%Y-%m-%d-%H-%M-%S)"
resources="$root/resources"
list="$root/list"
files=$(find "$resources" -type f)

echo $root
echo $resources
echo $HOME

echo "================================ Copying resources..."
mkdir -p "$backup"
for src in "$files"; do

    echo -n "$src..."
    dst=$(echo "$src" | sed "s=$resources=$HOME=")
    dir=$(dirname "$dst")
    if [ -e "$dst" ]; then

        backup_dir=$(echo "$dir" | sed "s=$HOME=$backup=")
        mkdir -p "$backup_dir"
        cp "$dst" "$backup_dir"
    else
        mkdir -p "$dir"
    fi
    cp "$src" "$dst"
    echo -e "[$GREEN OK $NC]"
done

echo "================================ Terminal config..."
shells=$(cat "$list/terminal/shell.md" | grep -v "^#" | grep -v "^$")
exports=$(cat "$list/terminal/env.md" | grep -v "^#" | grep -v "^$")
aliases=$(cat "$list/terminal/alias.md" | grep -v "^#" | grep -v "^$")
while IFS= read -r shell; do

    if [ -e "$HOME/$shell" ]; then
        cp "$HOME/$shell" "$backup"
    fi

    pattern="#================================ exports"
    if ! grep -q "$pattern" "$HOME/$shell"; then
        echo -e "\n$pattern" >> "$HOME/$shell"
    fi
    while IFS= read -r export; do

        b_export=$(echo $export | cut -d = -f 1)
        if ! grep -q "$b_export" "$HOME/$shell"; then
            # Caractères d'échappement ici
            export=$(echo $export | sed 's/;/\\;/g')
            export=$(echo $export | sed 's/&/\\&/g')
            sed -i "s;$pattern;$pattern\n$export;" "$HOME/$shell"
        fi
    done <<< "$exports"
    echo -e "enironment variables [$GREEN OK $NC]"

    pattern="#================================ aliases"
    if ! grep -q "$pattern" "$HOME/$shell"; then
        echo -e "\n$pattern" >> "$HOME/$shell"
    fi
    while IFS= read -r alias; do

        b_alias=$(echo $alias | cut -d = -f 1)
        if ! grep -q "alias $b_alias=" "$HOME/$shell"; then
            # Caractères d'échappement ici
            alias=$(echo $alias | sed 's/;/\\;/g')
            alias=$(echo $alias | sed 's/&/\\&/g')
            alias="alias $alias"
            sed -i "s;$pattern;$pattern\n$alias;" "$HOME/$shell"
        fi
    done <<< "$aliases"
    echo -e "aliases [$GREEN OK $NC]"

done <<< "$shells"

#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

root=$(dirname $(realpath $0))
backup="$root/backup/$(date +%Y-%m-%d-%H-%M-%S)"
resources="$root/resources"
list="$root/list"
files=$(find "$resources" -type f)

echo "================================ Copying resources..."
mkdir -p "$backup"
for src in "$files"; do

    dst=$(echo "$src" | sed "s/$resources/$HOME/")
    dir=$(dirname "$dst")
    echo -n "$dst..."
    if [ -e "$dst" ]; then

        backup_dir=$(echo "$dir" | sed "s/$HOME/$backup/")
        mkdir -p "$backup_dir"
        cp "$dst" "$backup_dir"
    else
        mkdir -p "$dir"
    fi
    cp "$src" "$dst"
    echo -e "[$GREEN OK $NC]"
done

echo "================================ Terminal config..."
shells=$(cat "$list/shell.md" | grep -v "^#")
exports=$(cat "$list/env.md" | grep -v "^#")
aliases=$(cat "$list/alias.md" | grep -v "^#")
for shell in "$shells"; do

    if [ -e "$HOME/$shell" ]; then
        cp "$HOME/$shell" "$backup"
    fi

    pattern="================================ exports"
    if ! grep -q "$pattern" "$HOME/$shell"; then
        echo -e "\n$pattern" >> "$HOME/$shell"
    fi
    for export in "$exports"; do
        if ! grep -q "$export" "$HOME/$shell"; then
            sed -i "s/$pattern/$pattern\n$export/" "$HOME/$shell"
        fi
    done
    echo -e "enironment variables [$GREEN OK $NC]"

    pattern="================================ aliases"
    if ! grep -q "$pattern" "$HOME/$shell"; then
        echo -e "\n$pattern" >> "$HOME/$shell"
    fi
    for alias in "$aliases"; do
        if ! grep -q "$alias" "$HOME/$shell"; then
            sed -i "s/$pattern/$pattern\n$alias/" "$HOME/$shell"
        fi
    done
    echo -e "aliases [$GREEN OK $NC]"
done

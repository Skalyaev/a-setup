#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "Copy resources?"
do_resources=false
select answ in "Yes" "No"; do
    case $answ in
        Yes ) do_resources=true; break;;
        No ) break;;
    esac
done

echo "Edit terminal config?"
do_term_conf=false
select answ in "Yes" "No"; do
    case $answ in
        Yes ) do_term_conf=true; break;;
        No ) break;;
    esac
done
do_env=false
do_aliases=false
if [ $do_term_conf = true ]; then

    echo "Terminal config: Environment variables?"
    select answ in "Yes" "No"; do
        case $answ in
            Yes ) do_env=true; break;;
            No ) break;;
        esac
    done
    echo "Terminal config: Aliases?"
    select answ in "Yes" "No"; do
        case $answ in
            Yes ) do_aliases=true; break;;
            No ) break;;
        esac
    done
fi

root=$(dirname $(realpath $0))
backup="$root/backup/$(date +%Y-%m-%d-%H-%M-%S)"

if [ $do_resources = true ]; then
    echo -n "================ Copying resources..."
    mkdir -p "$backup"
    resources="$root/resources"
    ignore=$(cat "$resources/ignore")
    files=$(find "$resources" -type f)
    for x in $ignore; do
        files=$(echo "$files" | grep -v "$x")
    done
    for src in "$files"; do

        dst=$(echo "$src" | sed "s;$resources;$HOME;")
        dir=$(dirname "$dst")
        if [ -e "$dst" ]; then

            backup_dir=$(echo "$dir" | sed "s;$HOME;$backup;")
            mkdir -p "$backup_dir"
            cp "$dst" "$backup_dir"
        else
            mkdir -p "$dir"
        fi
        cp "$src" "$dst"
        echo -e "[$GREEN OK $NC]"
    done
fi

if [ $do_term_conf = true ]; then
    echo -n "================ Terminal config..."
    mkdir -p "$backup"
    list="$root/list"
    shells=$(cat "$list/terminal/shell.md" | grep -v "^#" | grep -v "^$")
    while IFS= read -r shell; do

        if [ -e "$HOME/$shell" ]; then
            cp "$HOME/$shell" "$backup"
        fi
        if [ $do_env = true ]; then

            exports=$(cat "$list/terminal/env.md" | grep -v "^#" | grep -v "^$")
            pattern="#================ exports"
            if ! grep -q "$pattern" "$HOME/$shell"; then
                echo -e "\n$pattern" >> "$HOME/$shell"
            fi
            while IFS= read -r export; do

                b_export=$(echo "$export" | cut -d = -f 1)
                if ! grep -q "$b_export" "$HOME/$shell"; then
                    # Échappements ici
                    export=$(echo "$export" | sed 's/&/\\&/g')
                    export=$(echo "$export" | sed 's=/=\\/=g')
                    sed -i "s/$pattern/$pattern\n$export/" "$HOME/$shell"
                fi
            done <<< "$exports"
        fi
        if [ $do_aliases = true ]; then

            aliases=$(cat "$list/terminal/alias.md" | grep -v "^#" | grep -v "^$")
            pattern="#================ aliases"
            if ! grep -q "$pattern" "$HOME/$shell"; then
                echo -e "\n$pattern" >> "$HOME/$shell"
            fi
            while IFS= read -r alias; do

                b_alias=$(echo "$alias" | cut -d = -f 1)
                if ! grep -q "alias $b_alias=" "$HOME/$shell"; then
                    # Échappements ici
                    alias=$(echo "$alias" | sed 's/&/\\&/g')
                    alias=$(echo "$alias" | sed 's=/=\\/=g')
                    alias="alias $alias"
                    sed -i "s/$pattern/$pattern\n$alias/" "$HOME/$shell"
                fi
            done <<< "$aliases"
        fi
        echo -e "[$GREEN OK $NC]"
    done <<< "$shells"
fi

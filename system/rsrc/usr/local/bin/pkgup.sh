#!/bin/bash
pacman -Syu --noconfirm
pkgfile -u

ORPHANS="$(pacman -Qdtq)"
[[ -n "$ORPHANS" ]] && pacman -Rns "$ORPHANS" --noconfirm

GIT_DIR="/usr/local/src/github"
while read DIR; do

    cd "$(dirname "$DIR")" || continue

    git fetch || continue
    if git status | grep -q 'git pull'; then

        git pull || continue
    fi
    ./.install.sh

done < <(find "$1" -maxdepth "1" -mindepth "1" -type "d" -name ".git")

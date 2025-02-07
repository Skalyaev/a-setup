#!/bin/bash
#set -e
set -u

pacman -Syu --noconfirm
ORPHANS="$(pacman -Qdtq)"
[[ -n "$ORPHANS" ]] && pacman -Rns "$ORPHANS" --noconfirm

USERS="$(getent group "wheel" | cut -d ":" -f "4")"
USR="$(cut -d ":" -f "1" <<<"$USERS")"

GIT_DIR="/usr/local/src/github"
while read DIR; do

    sudo -u "$USR" bash -c "

        set -e
        cd '$DIR' && git fetch 2>'$HOME/error.log'
        git status | grep -q 'git pull'

        git pull 2>'$HOME/error.log'
        echo '$DIR' >'$HOME/update.log'
    "
done < <(find "$GIT_DIR" -maxdepth "1" -mindepth "1" -type "d")

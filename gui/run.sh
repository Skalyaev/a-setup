#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u
sudo echo >"/dev/null"

DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

while read PKG; do

    echo -ne "[$YELLOW * $NC] Installing '$PKG'..."

    sudo pacman -S --noconfirm --needed "$PKG" &>"/dev/null"
    echo -e "\r[$GREEN + $NC] '$PKG' installed    "

done <"$DIR/pacman.list"

while read SRC; do

    DST="$HOME/$(sed "s=$DIR/home/==" <<<"$SRC")"

    mkdir -p "$(dirname "$DST")"
    ln -sf "$SRC" "$DST"

done < <(find "$DIR/home" -type "f")

# TODO: Fix VM GUI installation
# systemctl enable "gdm" &>"/dev/null"
# https://github.com/lahwaacz/Scripts/blob/master/rmshit.py
# https://aur.archlinux.org/packages/rmlint-git
# intel-gpu-tools

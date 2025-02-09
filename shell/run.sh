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

    sudo pacman -S --noconfirm --needed "$PKG" >"/dev/null"
    echo -e "\r[$GREEN + $NC] '$PKG' installed    "

done <"$DIR/pacman.list"

while read SRC; do

    DST="$HOME/$(sed "s=$DIR/home/==" <<<"$SRC")"

    mkdir -p "$(dirname "$DST")"
    ln -sf "$SRC" "$DST"

done < <(find "$DIR/home" -type "f")

sudo sed -i 's/#Color/Color/g' "/etc/pacman.conf"
echo -e "[$GREEN + $NC] Updating package database..."

sudo pkgfile -u >"/dev/null"
echo -e "[$GREEN + $NC] Package database updated    "

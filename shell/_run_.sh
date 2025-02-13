#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

echo
sudo sed -i 's/#Color/Color/g' "/etc/pacman.conf"
DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

RSRC="$DIR/rsrc"
while read SRC; do

    DST="$(sed "s=$RSRC=$HOME=" <<<"$SRC")"
    DIRNAME="$(dirname "$DST")"

    [[ -e "$DIRNAME" ]] || mkdir -p "$DIRNAME"
    ln -sf "$SRC" "$DST"

done < <(find "$RSRC" -type "f")

echo -ne "[$YELLOW * $NC] Updating 'pacman' database..."

sudo pacman -Syu --noconfirm &>"/dev/null"
echo -e "\r[$GREEN + $NC] 'pacman' database updated    "

while read PKG; do

    pacman -Qi "$PKG" &>"/dev/null" && continue
    echo -ne "[$YELLOW * $NC] Installing '$PKG'..."

    sudo pacman -S --noconfirm --needed "$PKG" &>"/dev/null"
    echo -e "\r[$GREEN + $NC] '$PKG' installed    "

done <"$DIR/pacman.list"

echo -ne "[$YELLOW * $NC] Updating 'pkgfile' database..."

sudo pkgfile -u &>"/dev/null"
echo -e "\r[$GREEN + $NC] 'pkgfile' database updated    "

echo -e "[$GREEN + $NC] Installation complete"

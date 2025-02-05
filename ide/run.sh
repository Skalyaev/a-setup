#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[0;35m'
GRAY='\033[0;37m'
NC='\033[0m'
set -e

DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

sudo echo &>/dev/null
readarray -t PKGS <"$DIR/package.list"
for pkg in "${PKGS[@]}"; do

    echo -ne "[$YELLOW * $NC] Installing '$pkg'..."

    sudo pacman -S --noconfirm --needed "$pkg" &>"/dev/null"
    echo -e "\r[$GREEN + $NC] '$pkg' installed    "
done
set +e
cp -r "$DIR/home/"* "$DIR/home/."* "$HOME/." &>"/dev/null"
set -e

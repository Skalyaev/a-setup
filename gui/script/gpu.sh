#!/bin/bash
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
NC="\033[0m"
set -e
set -u

GPU="$(lspci -k -d "::03xx")"
PKGS=()

grep -iq "intel" <<<"$GPU" && PKGS+=("mesa")
grep -iq "nvidia" <<<"$GPU" && PKGS+=("nvidia-open")

for PKG in "${PKGS[@]}"; do

    pacman -Qi "$PKG" &>"/dev/null" && continue
    echo -ne "[$YELLOW * $NC] Installing '$PKG'..."

    sudo pacman -S --noconfirm --needed "$PKG" &>"/dev/null"
    echo -e "\r[$GREEN + $NC] '$PKG' installed    "
done

#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

DIR="$1"
readarray -t PKGS <"$DIR/pacman.list"

if grep -iq "intel" "/proc/cpuinfo"; then
    PKGS+=("intel-ucode")

elif grep -iq "amd" "/proc/cpuinfo"; then
    PKGS+=("amd-ucode")
fi
echo
for pkg in "${PKGS[@]}"; do

    echo -ne "[$YELLOW * $NC] Installing '$pkg'..."

    pacstrap -K "/mnt" "$pkg" &>"/dev/null"
    echo -e "\r[$GREEN + $NC] '$pkg' installed    "
done

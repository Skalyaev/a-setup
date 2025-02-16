#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

loadkeys "fr-latin1"
DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

"$DIR"/run/partition.sh

while ! ping -c 1 "archlinux.org" &>"/dev/null"; do

    echo -e "\n[$RED - $NC] Connection required"
    echo -e "[$YELLOW * $NC] Running 'iwctl'"
    iwctl
done
readarray -t pkgs <"$DIR/pacstrap.list"

if grep -iq "intel" "/proc/cpuinfo"; then
    pkgs+=("intel-ucode")

elif grep -iq "amd" "/proc/cpuinfo"; then
    pkgs+=("amd-ucode")
fi
echo
for pkg in "${pkgs[@]}"; do

    echo -ne "[$YELLOW * $NC] Installing '$pkg'..."

    pacstrap -K "/mnt" "$pkg" &>"/dev/null"
    echo -e "\r[$GREEN + $NC] '$pkg' installed    "
done

DST="/root/.local/src"
mkdir -p "/mnt$DST"
cp -r "$DIR/.." "/mnt/$DST/setup"

echo -ne "[$YELLOW * $NC] Generating 'fstab'..."

genfstab -U "/mnt" >>"/mnt/etc/fstab"
echo -e "\r[$GREEN + $NC] 'fstab' generated    "

echo -e "[$GREEN + $NC] Chrooting\n"
arch-chroot "/mnt" "$DST/setup/system/run/chroot/_run_.sh"

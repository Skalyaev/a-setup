#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

loadkeys "fr-latin1" >"/dev/null"
DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

"$DIR"/script/partition.sh

while ! ping -c 1 "archlinux.org" &>"/dev/null"; do

    echo -e "\n[$RED - $NC] Connection required"
    echo -e "\n[$YELLOW * $NC] Running 'iwctl'"
    iwctl
done
readarray -t PKGS <"$DIR/pacman.list"

if grep -iq "intel" "/proc/cpuinfo"; then
    PKGS+=("intel-ucode")

elif grep -iq "amd" "/proc/cpuinfo"; then
    PKGS+=("amd-ucode")
fi
echo
for pkg in "${PKGS[@]}"; do

    echo -ne "[$YELLOW * $NC] Installing '$pkg'..."

    pacstrap -K "/mnt" "$pkg" >"/dev/null"
    echo -e "\r[$GREEN + $NC] '$pkg' installed    "
done
genfstab -U "/mnt" >>"/mnt/etc/fstab" # TODO: Check for '>' instead of '>>'
cp -r "$DIR/.." "/mnt/root/setup"

echo -e "[$GREEN + $NC] Installation successful, chrooting"
arch-chroot "/mnt" /root/setup/system/script/chroot.sh

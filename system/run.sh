#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[0;35m'
GRAY='\033[0;37m'
NC='\033[0m'
set -e

KEYBOARD="fr-latin1"
PKGS=(
    "base" "base-devel" "linux" "linux-firmware"
    "lvm2" "intel-ucode" "grub" "efibootmgr"
    "git" "networkmanager" "openssh"
)
DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

loadkeys "$KEYBOARD"
"$DIR"/partition.sh

while ! ping -c 1 "archlinux.org" &>"/dev/null"; do

    echo -e "\n[$RED - $NC] Connection required"
    echo -e "\n[$YELLOW * $NC] Running 'iwctl', CTRL+D to resume"
    iwctl
done
echo
for pkg in "${PKGS[@]}"; do

    echo -ne "[$YELLOW * $NC] Installing '$pkg'..."

    pacstrap -K "/mnt" "$pkg" &>"/dev/null"
    echo -e "\r[$GREEN + $NC] '$pkg' installed    "
done

genfstab -U "/mnt" >>"/mnt/etc/fstab"
echo -e "[$GREEN + $NC] Installation successful, chrooting"

cp -r "$DIR/.." "/mnt/root/setup"
arch-chroot "/mnt" /root/setup/system/chroot.sh

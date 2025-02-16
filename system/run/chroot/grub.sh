#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

echo -ne "[$YELLOW * $NC] Installing GRUB..."

grub-install \
    --target="x86_64-efi" \
    --efi-directory="/boot/efi" \
    --bootloader-id="GRUB" &>"/dev/null"

grub-mkconfig -o "/boot/grub/grub.cfg" &>"/dev/null"

sed -i 's#^\(GRUB_PRELOAD_MODULES=".*part_msdos\)"#\1 lvm"#' "/etc/default/grub"
echo -e "\r[$GREEN + $NC] GRUB installed    "

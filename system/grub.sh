#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[0;35m'
GRAY='\033[0;37m'
NC='\033[0m'
set -e

SECURE_BOOT="$(find "/sys/firmware/efi/efivars" -name "SecureBoot-*" 2>"/dev/null")"
SECURE_BOOT="$(hexdump -ve '1/1 "%.2x"' "$SECURE_BOOT")"

echo -ne "[$YELLOW * $NC] Installing GRUB..."

#if [[ "$SECURE_BOOT" == *"00" ]]; then
#else
#fi  # TODO: Secure Boot handling

grub-install \
    --target="x86_64-efi" \
    --efi-directory="/boot/efi" \
    --bootloader-id="GRUB" &>"/dev/null"

grub-mkconfig -o "/boot/grub/grub.cfg" &>"/dev/null"
sed -i 's#^\(GRUB_PRELOAD_MODULES=".*part_msdos\)"#\1 lvm"#' "/etc/default/grub"

echo -e "\r[$GREEN + $NC] GRUB installed    "

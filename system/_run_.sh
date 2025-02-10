#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

loadkeys "fr-latin1"
DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

"$DIR"/script/partition.sh
"$DIR"/script/network.sh
"$DIR"/script/pacstrap.sh "$DIR"

DST="/root/.local/src"
mkdir -p "/mnt$DST"
cp -r "$DIR/.." "/mnt/$DST/setup"

echo -ne "[$YELLOW * $NC] Generating 'fstab'..."

genfstab -U "/mnt" >>"/mnt/etc/fstab"
echo -e "\r[$GREEN + $NC] 'fstab' generated    "

echo -e "[$GREEN + $NC] Chrooting"
arch-chroot "/mnt" "$DST/setup/system/script/chroot/_run_.sh"

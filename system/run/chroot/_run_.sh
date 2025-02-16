#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m'
set -e
set -u
grep -q "chroot" < <(systemctl list-units 2>&1) || exit

DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

"$DIR"/local.sh
"$DIR"/user.sh
"$DIR"/initramfs.sh
"$DIR"/grub.sh

RSRC="$(realpath "$DIR/tocopy")"
for src in $(find "$RSRC" -type "f"); do

    DST="$(sed "s=$RSRC==" <<<"$src")"

    mkdir -p "$(dirname "$DST")"
    cp "$src" "$DST"
done
systemctl enable "NetworkManager" &>"/dev/null"
systemctl enable "systemd-timesyncd" &>"/dev/null"
systemctl enable "paccache.timer" &>"/dev/null"
systemctl enable "cronie" &>"/dev/null"

echo -e "[$GREEN + $NC] Chroot set"
echo "You can 'umount -R /mnt && shutdown now'"

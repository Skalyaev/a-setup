#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
GRAY='\033[0;37m'
NC='\033[0m'
set -e
set -u
grep -q "chroot" < <(systemctl list-units 2>&1) || exit

DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

"$DIR"/local.sh
"$DIR"/user.sh
"$DIR"/initramfs.sh
"$DIR"/grub.sh
"$DIR"/systemctl.sh

RSRC="$(realpath "$DIR/../../rsrc")"
while read SRC; do

    DST="$(sed "s=$RSRC==" <<<"$SRC")"

    mkdir -p "$(dirname "$DST")"
    cp "$SRC" "$DST"

done < <(find "$RSRC" -type "f")

echo -e "[$GREEN + $NC] Installation complete"
echo -n "You can 'umount -R /mnt && shutdown now'"
echo " and remove the installation media"

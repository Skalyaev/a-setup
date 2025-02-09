#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
GRAY='\033[0;37m'
NC='\033[0m'
set -e
set -u

CHARSET="UTF-8"
LOCALLANG="fr_FR.$CHARSET"
LOCALTIME="/usr/share/zoneinfo/Europe/Paris"

KEYMAP="fr-latin1"
FONT="lat9w-16"

grep -q "chroot" < <(systemctl list-units 2>&1) || exit

ln -sf "$LOCALTIME" "/etc/localtime"
hwclock --systohc >"/dev/null"

sed -i "s/#$LOCALLANG/$LOCALLANG/" "/etc/locale.gen"
locale-gen >"/dev/null"

echo "LANG=$LOCALLANG" >"/etc/locale.conf"
echo "KEYMAP=$KEYMAP" >"/etc/vconsole.conf"
echo "FONT=$FONT" >>"/etc/vconsole.conf"
echo
while true; do

    echo -ne "[$GRAY \$ $NC] Hostname: "
    read ANSWER

    [[ -n "$ANSWER" && "$ANSWER" =~ ^[a-z0-9_-]+$ ]] && break
    echo -e "[$RED - $NC] Invalid hostname"
done
echo "$ANSWER" >"/etc/hostname"

echo -e "[$GRAY \$ $NC] Root password: "
passwd
echo
while true; do

    echo -ne "[$GRAY \$ $NC] User login: "
    read ANSWER

    [[ -n "$ANSWER" && "$ANSWER" =~ ^[a-z_][a-z0-9_-]*$ ]] && break
    echo -e "[$RED - $NC] Invalid login"
done
USERNAME="$ANSWER"

id "$USERNAME" &>"/dev/null" ||
    useradd -m -g "users" -G "wheel" "$USERNAME" >"/dev/null"

echo -e "[$GRAY \$ $NC] User password: "
passwd "$USERNAME"

DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

"$DIR"/initramfs.sh
"$DIR"/grub.sh

cp "$DIR/../sudoers.d/"* "/etc/sudoers.d/".

systemctl enable "NetworkManager" >"/dev/null"
systemctl enable "systemd-timesyncd" >"/dev/null"
systemctl enable "paccache.timer" >"/dev/null"
systemctl enable "cronie" >"/dev/null"

echo -e "[$GREEN + $NC] Installation complete"
echo "You can 'umount -R /mnt && shutdown now' and remove the installation media"

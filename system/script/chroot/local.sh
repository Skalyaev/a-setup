#!/bin/bash
set -e
set -u

LOCALLANG="fr_FR.UTF-8"
LOCALTIME="/usr/share/zoneinfo/Europe/Paris"

KEYMAP="fr-latin1"
FONT="lat9w-16"

ln -sf "$LOCALTIME" "/etc/localtime"
hwclock --systohc >"/dev/null"

sed -i "s/#$LOCALLANG/$LOCALLANG/" "/etc/locale.gen"
locale-gen >"/dev/null"

echo "LANG=$LOCALLANG" >"/etc/locale.conf"
echo "KEYMAP=$KEYMAP" >"/etc/vconsole.conf"
echo "FONT=$FONT" >>"/etc/vconsole.conf"

#!/bin/bash
pkg="pulseaudio"
dpkg-query -W -f='${Status}' "$pkg" 2>"/dev/null"\
    | grep -q "install ok installed" && exit 0

apt install -y "$pkg" &>"/dev/null" || exit 1
[[ "$NO_BACKUP" ]] || echo "apt:$pkg" >> "$BACKUP/diff"
[[ "$NO_BACKUP" ]]\
    || echo "add:$HOME/.config/pulse" >> "$BACKUP/diff"

pkg="pulseaudio-module-bluetooth"
apt install -y "$pkg" &>"/dev/null" || exit 1
[[ "$NO_BACKUP" ]] || echo "apt:$pkg" >> "$BACKUP/diff"

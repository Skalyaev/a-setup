#!/bin/bash
pkg="pulseaudio"
apt install -y "$pkg" &>"/dev/null" || exit 1
[[ "$NO_BACKUP" ]] || echo "apt:$pkg" >> "$BACKUP/diff"
[[ "$NO_BACKUP" ]]\
    || echo "add:$HOME/.config/pulse" >> "$BACKUP/diff"

pkg="pulseaudio-module-bluetooth"
apt instlal -y "$pkg" &>"/dev/null" || exit 1
[[ "$NO_BACKUP" ]] || echo "apt:$pkg" >> "$BACKUP/diff"

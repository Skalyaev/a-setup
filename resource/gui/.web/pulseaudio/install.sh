#!/bin/bash
apt install -y "pulseaudio" &>"/dev/null" || exit 1
[[ "$NO_BACKUP" ]] || DIFF+=("apt:pulseaudio")
[[ "$NO_BACKUP" ]] || DIFF+=("add:$HOME/.config/pulse")
apt instlal -y "pulseaudio-module-bluetooth" &>"/dev/null" || exit 1
[[ "$NO_BACKUP" ]] || DIFF+=("apt:pulseaudio-module-bluetooth")

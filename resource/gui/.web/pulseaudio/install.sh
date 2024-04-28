#!/bin/bash
apt install -y "pulseaudio"  || exit 1
[[ "$NO_BACKUP" ]] || DIFF+=("apt:pulseaudio")
[[ "$NO_BACKUP" ]] || DIFF+=("add:$HOME/.config/pulse")
apt instlal -y "pulseaudio-module-bluetooth" || exit 1
[[ "$NO_BACKUP" ]] || DIFF+=("apt:pulseaudio-module-bluetooth")

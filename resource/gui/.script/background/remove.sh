#!/bin/bash
FILES=(
    "/usr/share/images/backgrounds/background.jpg"
    "/usr/share/images/desktop-base/default"
    "/usr/share/images/desktop-base/desktop-background"
    "/usr/share/images/desktop-base/desktop-grub.png"
    "/usr/share/images/desktop-base/login-background.svg"
    "/usr/share/images/backgrounds/background.xml"
    "/usr/share/images/desktop-base/desktop-background.xml"
    "/usr/share/images/desktop-base/desktop-lockscreen.xml"
    "/boot/grub/black.png"
    "/etc/default/grub"
)
for file in "${FILES[@]}";do
    if [[ -e "$file.ft.bak" ]];then
        mv "$file.ft.bak" "$file"
    elif [[ -e "$file" ]];then
        rm -f "$file"
    fi
done

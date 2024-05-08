#!/bin/bash
FILES=(
    "/usr/local/share/backgrounds/ft_background.jpg"
    "/usr/local/share/backgrounds/ft_background.xml"
    "/usr/share/images/desktop-base/default"
    "/usr/share/images/desktop-base/desktop-background"
    "/usr/share/images/desktop-base/desktop-grub.png"
    "/usr/share/images/desktop-base/login-background.svg"
    "/usr/share/images/desktop-base/desktop-background.xml"
    "/usr/share/images/desktop-base/desktop-lockscreen.xml"
    "/boot/grub/ft_black.png"
    "/etc/default/grub"
)
for file in "${FILES[@]}";do
    if [[ -e "$file.ft.bak" ]];then mv "$file.ft.bak" "$file"
    elif [[ -e "$file" ]];then rm -rf "$file";fi
done
sudo update-grub &>"/dev/null"

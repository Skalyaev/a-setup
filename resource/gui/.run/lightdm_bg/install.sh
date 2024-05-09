#!/bin/bash
cd "$(mktemp -d)" || exit 1

from='/usr/share/images/desktop-base'
to="/usr/local/share/backgrounds"
[[ -e "$to" ]] || mkdir -p "$to" || exit 1

#======================================JPG
name="background.jpg"
p1="https://github.com/Skalyaeve"
p2="/images-1/blob/main/background/background.jpg?raw=true"
curl -kL "$p1$p2" -o "$name" &>"/dev/null" || exit 1
mv "$name" "$to/$name" || exit 1

files=(
    "default"
    "desktop-background"
    "desktop-grub.png"
    "login-background.svg"
)
for file in "${files[@]}";do
    [[ -e "$from/$file" ]] && rm "$from/$file" || exit 1
    ln -s "$to/$name" "$from/$file" || exit 1
done

#======================================XML
name="background.xml"
p1="https://raw.githubusercontent.com/Skalyaeve"
p2="/images-1/main/background/background.xml"
curl -kL "$p1$p2" -o "$name" &>"/dev/null" || exit 1
mv "$name" "$to/$name" || exit 1

files=(
    "desktop-background.xml"
    "desktop-lockscreen.xml"
)
for file in "${files[@]}";do
    [[ -e "$from/$file" ]] && rm "$from/$file" || exit 1
    ln -s "$to/$name" "$from/$file" || exit 1
done

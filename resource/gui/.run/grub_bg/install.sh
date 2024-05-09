#!/bin/bash
cd "$(mktemp -d)" || exit 1

name="background.png"
p1="https://github.com/Skalyaeve"
p2="/images-1/blob/main/background/black.png?raw=true"
url="$p1$p2"
curl -kL "$url" -o "$name" &>"/dev/null" || exit 1

dst="/boot/grub"
mv "$name" "$dst/$name" || exit 1
sudo update-grub &>"/dev/null"

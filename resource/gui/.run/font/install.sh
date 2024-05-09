#!/bin/bash
apt install -y "unzip" &>"/dev/null" || exit 1
cd "$(mktemp -d)" || exit 1

name="Terminus"
mkdir "$name" && cd "$name"

p1="https://github.com/ryanoasis"
p2="/nerd-fonts/releases/download/v3.1.1/$name.zip"
curl -kL "$p1$p2" -o "$name.zip" &>"/dev/null" || exit 1
unzip "$name.zip" >"/dev/null" || exit 1

dst="/usr/local/share/fonts/$name"
mkdir -p "$dst" || exit 1
mv *".ttf" "$dst" || exit 1
fc-cache -fv >"/dev/null"

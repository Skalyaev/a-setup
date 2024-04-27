#!/bin/bash
NAME="Terminus"
TMP="$(mktemp -d)" || exit 1
cd "$TMP" || exit 1
mkdir "$NAME" && cd "$NAME"

P1="https://github.com/ryanoasis"
P2="/nerd-fonts/releases/download/v3.1.1/$NAME.zip"
URL="$P1$P2"
curl -kL "$URL" -o "$NAME.zip" || exit 1
unzip "$NAME.zip" >"/dev/null" || exit 1
rm -rf "$NAME.zip"

DST="/usr/share/fonts/$NAME"
mkdir "$DST" || exit 1
mv * "$DST" || exit 1
fc-cache -f -v >"/dev/null"

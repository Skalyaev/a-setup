#!/bin/bash
NAME="Terminus"
DST="/usr/share/fonts/$NAME"
[[ -e "$DST" ]] && exit -1

P1="https://github.com/ryanoasis"
P2="/nerd-fonts/releases/download/v3.1.1/$NAME.zip"
URL="$P1$P2"
TMP="$(mktemp -d)" || exit 1
cd "$TMP" || exit 1
mkdir "$NAME" && cd "$NAME"
curl -kL "$URL" -o "$NAME.zip" || exit 1
unzip "$NAME.zip" || exit 1
rm -f "$NAME.zip"
mkdir "$DST" || exit 1
mv * "$DST" || exit 1
fc-cache -f -v
exit 0

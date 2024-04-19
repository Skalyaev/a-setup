#!/bin/bash
NAME="Terminus"
P1="https://github.com/ryanoasis"
P2="/nerd-fonts/releases/download/v3.1.1/$NAME.zip"
URL="$P1$P2"
TMP="$(mktemp -d)" || exit 1
bye() {
   rm -rf "$TMP"
   exit "$1"
}
cd "$TMP" || bye 1
mkdir "$NAME" && cd "$NAME"
curl -kL "$URL" -o "$NAME.zip" || bye 1
unzip "$NAME.zip" || bye 1
rm -f "$NAME.zip"
DST="/usr/share/fonts/$NAME"
if [[ -e "$DST" ]];then
    diff -r "../$NAME" "$DST" && bye 0
    rm -rf "$DST" || bye 1
fi
mkdir "$DST" || bye 1
mv * "$DST" || bye 1
fc-cache -f -v
bye 0

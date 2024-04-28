#!/bin/bash
bye(){
    chown -r "$user:$user" "$home/.cache"
    chown -r "$user:$user" "$home/.wget-hsts"
    rm -rf "$TMP"
    exit "$1"
}
NAME="Terminus"
TMP="$(mktemp -d)" || bye 1
cd "$TMP" || bye 1
mkdir "$NAME" && cd "$NAME"

P1="https://github.com/ryanoasis"
P2="/nerd-fonts/releases/download/v3.1.1/$NAME.zip"
URL="$P1$P2"
curl -kL "$URL" -o "$NAME.zip" || bye 1
unzip "$NAME.zip" >"/dev/null" || bye 1
rm -rf "$NAME.zip"

DST="/usr/local/share/fonts/$NAME"
mkdir "$DST" || bye 1
mv * "$DST" || bye 1
fc-cache -f -v >"/dev/null"
bye 0

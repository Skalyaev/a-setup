#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

echo
sudo localectl "set-x11-keymap" "fr"
DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

RSRC="$DIR/rsrc"
while read SRC; do

    DST="$(sed "s=$RSRC=$HOME=" <<<"$SRC")"
    DIRNAME="$(dirname "$DST")"

    [[ -e "$DIRNAME" ]] || mkdir -p "$DIRNAME"
    ln -sf "$SRC" "$DST"

done < <(find "$RSRC" -type "f")

echo -ne "[$YELLOW * $NC] Updating 'pacman' database..."

sudo pacman -Syu --noconfirm &>"/dev/null"
echo -e "\r[$GREEN + $NC] 'pacman' database updated    "

while read PKG; do

    pacman -Qi "$PKG" &>"/dev/null" && continue
    echo -ne "[$YELLOW * $NC] Installing '$PKG'..."

    sudo pacman -S --noconfirm --needed "$PKG" &>"/dev/null"
    echo -e "\r[$GREEN + $NC] '$PKG' installed    "

done <"$DIR/pacman.list"

GIT_DIR="/usr/local/src/github"
AUR_URL="https://aur.archlinux.org"
while read PKG; do

    [[ -e "$GIT_DIR/$PKG" ]] && continue || cd "$GIT_DIR"

    echo -ne "[$YELLOW * $NC] Cloning '$PKG'..."
    git clone "$AUR_URL/$PKG.git" &>"/dev/null"

    echo -e "\r[$GREEN + $NC] '$PKG' cloned, runing 'makepkg'"
    cd "$PKG"
    if [[ ! -x ".install.sh" ]]; then

        echo 'makepkg -si --noconfirm' >.install.sh
        chmod +x .install.sh
    fi
    ./.install.sh >"/dev/null"

done <"$DIR/aur.list"

SRC="$DIR/zip"
while read ENTRY; do

    IFS=" " read NAME DST <<<"$ENTRY"

    SRC="$DIR/zip/$NAME.zip"
    DST="$HOME/$DST"

    [[ -e "$DST" ]] && rm -rf "$DST"
    DST="$(dirname "$DST")"

    echo -ne "[$YELLOW * $NC] Unzipping '$NAME'..."
    unzip -o "$SRC" -d "$DST" &>"/dev/null"
    echo -e "\r[$GREEN + $NC] '$NAME' unzipped    "

done <"$DIR/zip.list"

"$DIR"/script/user.sh
"$DIR"/script/font.sh
"$DIR"/script/gui.sh
"$DIR"/script/gsetting/_run_.sh

FONT="redhat"
SRC="$HOME/.local/src/$FONT"
DST="/usr/share/fonts/$FONT"
sudo ln -sf "$SRC" "$DST"

systemctl enable "gdm"
echo -e "[$GREEN + $NC] Installation complete"
echo "VM might need to install 'xorg-server' & 'xclip'"

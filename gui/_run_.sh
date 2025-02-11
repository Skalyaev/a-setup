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

    mkdir -p "$(dirname "$DST")"
    ln -sf "$SRC" "$DST"

done < <(find "$RSRC" -type "f")

sudo echo >"/dev/null"
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

"$DIR"/script/font.sh
"$DIR"/script/gsetting/_run_.sh

systemctl enable "gdm"
echo -e "[$GREEN + $NC] Installation complete"
echo "You can reboot now, VM might need 'xorg-server' pacman package"

# https://github.com/lahwaacz/Scripts/blob/master/rmshit.py
# https://aur.archlinux.org/packages/rmlint-git
# INTEL & NVIDIA GPU

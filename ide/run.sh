#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u
sudo echo >"/dev/null"

DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

while read PKG; do

    echo -ne "[$YELLOW * $NC] Installing '$PKG'..."

    sudo pacman -S --noconfirm --needed "$PKG" &>"/dev/null"
    echo -e "\r[$GREEN + $NC] '$PKG' installed    "

done <"$DIR/pacman.list"

while read SRC; do

    DST="$HOME/$(sed "s=$DIR/home/==" <<<"$SRC")"

    mkdir -p "$(dirname "$DST")"
    ln -sf "$SRC" "$DST"

done < <(find "$DIR/home" -type "f")

PYENV="$HOME/.local/share/pyenv"
echo -ne "[$YELLOW * $NC] Creating local python environment..."

python -m venv "$PYENV" >"/dev/null"
echo -e "\r[$GREEN + $NC] Local python environment created    "

while read PKG; do

    echo -ne "[$YELLOW * $NC] Installing pip '$PKG'..."

    "$PYENV"/bin/pip install --no-cache-dir "$PKG" >"/dev/null"
    echo -e "\r[$GREEN + $NC] pip '$PKG' installed    "

done <"$DIR/pip.list"

while read PKG; do

    echo -ne "[$YELLOW * $NC] Installing npm '$PKG'..."

    npm install -g "$PKG" >"/dev/null"
    echo -e "\r[$GREEN + $NC] npm '$PKG' installed    "

done <"$DIR/npm.list"

while read PKG; do

    echo -ne "[$YELLOW * $NC] Installing gem '$PKG'..."

    gem install "$PKG" >"/dev/null"
    echo -e "\r[$GREEN + $NC] gem '$PKG' installed    "

done <"$DIR/gem.list"

while read PKG; do

    echo -ne "[$YELLOW * $NC] Installing perl '$PKG'..."

    cpanm "$PKG" >"/dev/null"
    echo -e "\r[$GREEN + $NC] perl '$PKG' installed    "

done <"$DIR/cpanm.list"

GIT_DIR="/usr/local/src/github"
while read PKG; do

    cd "$GIT_DIR"
    echo -ne "[$YELLOW * $NC] Cloning '$PKG'..."

    [[ -e "$PKG" ]] ||
        git clone "https://aur.archlinux.org/$PKG" &>"/dev/null"

    echo -e "\r[$GREEN + $NC] '$PKG' cloned, runing 'makepkg'..."
    cd "$PKG"
    if [[ ! -x ".install.sh" ]]; then

        echo 'makepkg -si --noconfirm' >.install.sh
        chmod +x .install.sh
    fi
    ./.install.sh &>"/dev/null"

done <"$DIR/aur.list"

while read SCRIPT; do

    "$SCRIPT"

done < <(find "$DIR/script" -name "*.sh")

#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

RSRC="$DIR/rsrc"
while read SRC; do

    DST="$(sed "s=$RSRC=$HOME=" <<<"$SRC")"
    DIRNAME="$(dirname "$DST")"

    [[ -e "$DIRNAME" ]] || mkdir -p "$DIRNAME"
    ln -sf "$SRC" "$DST"

done < <(find "$RSRC" -type "f")
echo
sudo echo &>"/dev/null"

echo -ne "[$YELLOW * $NC] Updating 'pacman' database..."

sudo pacman -Syu --noconfirm &>"/dev/null"
echo -e "\r[$GREEN + $NC] 'pacman' database updated    "

while read PKG; do

    pacman -Qi "$PKG" &>"/dev/null" && continue
    echo -ne "[$YELLOW * $NC] Installing '$PKG'..."

    sudo pacman -S --noconfirm --needed "$PKG" &>"/dev/null"
    echo -e "\r[$GREEN + $NC] '$PKG' installed    "

done <"$DIR/pacman.list"

PYENV="$HOME/.local/share/pyenv"
if [[ ! -e "$PYENV" ]]; then

    echo -ne "[$YELLOW * $NC] Creating local python environment..."

    python -m venv "$PYENV" &>"/dev/null"
    echo -e "\r[$GREEN + $NC] Local python environment created    "
fi
while read PKG; do

    pip show "$PKG" &>"/dev/null" && continue
    echo -ne "[$YELLOW * $NC] Installing pip '$PKG'..."

    "$PYENV"/bin/pip install --no-cache-dir "$PKG" &>"/dev/null"
    echo -e "\r[$GREEN + $NC] pip '$PKG' installed    "

done <"$DIR/pip.list"

GIT_DIR="/usr/local/src/github"
AUR_URL="https://aur.archlinux.org"
while read PKG; do

    [[ -e "$GIT_DIR/$PKG" ]] && continue || cd "$GIT_DIR"

    echo -ne "[$YELLOW * $NC] Cloning '$PKG'..."
    git clone "$AUR_URL/$PKG.git" &>"/dev/null"

    echo -e "\r[$GREEN + $NC] '$PKG' cloned, runing 'makepkg'"
    cd "$PKG"
    if [[ ! -x ".install.sh" ]]; then

        echo 'makepkg -si --noconfirm' >".install.sh"
        chmod +x ".install.sh"
    fi
    set +e
    ./.install.sh >"/dev/null"
    [[ "$?" -ne 0 ]] && echo -e "[$RED - $NC] '$PKG' makepkg returned non-zero"
    set -e

done <"$DIR/aur.list"

while read SCRIPT; do

    "$SCRIPT"

done < <(find "$DIR/script" -name "*.sh")

echo -e "[$GREEN + $NC] Installation complete"

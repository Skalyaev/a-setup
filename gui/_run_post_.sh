#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

echo
DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

echo -ne "[$YELLOW * $NC] Setting custom keybinds..."
"$DIR"/script/gsetting/custom_keybind.sh &>"/dev/null"
echo -e "\r[$GREEN + $NC] Custom keybinds set       "

cat <<EOF | tee "$HOME/.config/user-dirs.dirs" &>/dev/null
XDG_DOWNLOAD_DIR="\$HOME/download"
XDG_DOCUMENTS_DIR="\$HOME/document"
XDG_PUBLICSHARE_DIR="\$HOME/document"
XDG_DESKTOP_DIR="\$HOME/document"
XDG_TEMPLATES_DIR="\$HOME/document/template"
XDG_PICTURES_DIR="\$HOME/document/media/image"
XDG_MUSIC_DIR="\$HOME/document/media/music"
XDG_VIDEOS_DIR="\$HOME/document/media/video"
EOF
echo -e "[$GREEN + $NC] Installation complete"

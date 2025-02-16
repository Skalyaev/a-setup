#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

sudo localectl "set-x11-keymap" "fr"
DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

"$DIR"/run/user.sh
"$DIR"/run/gpu.sh
"$DIR"/run/font.sh
"$DIR"/run/gsetting/_run_.sh

systemctl enable "gdm"

echo -e "[$GREEN + $NC] GNOME GUI installed"
echo "VM might need to install 'xorg-server' & 'xclip'"

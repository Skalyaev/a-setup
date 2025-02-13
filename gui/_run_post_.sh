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

"$DIR"/script/userdir.sh &>"/dev/null"
echo -e "[$GREEN + $NC] Installation complete"

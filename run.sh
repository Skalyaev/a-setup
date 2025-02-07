#!/bin/bash
RED='\033[0;31m'
PINK='\033[0;35m'
GRAY='\033[0;37m'
NC='\033[0m'
set -e
set -u

DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

echo -e "[$PINK 1 $NC] Base system installation"
echo -e "[$PINK 2 $NC] GUI installation (GNOME)"
echo -e "[$PINK 3 $NC] Shell installation (Bash)"
echo -e "[$PINK 4 $NC] IDE installation (Neovim)"
echo -e "[$PINK 0 $NC] Exit"
while true; do

    echo -ne "[$GRAY \$ $NC]: "
    read SELECTION
    case "$SELECTION" in

    1) "$DIR"/system/run.sh && exit ;;
    2) "$DIR"/gui/run.sh && exit ;;
    3) "$DIR"/shell/run.sh && exit ;;
    4) "$DIR"/ide/run.sh && exit ;;
    0) exit ;;
    *) echo -e "[$RED - $NC] Invalid selection" ;;
    esac
done

#!/bin/bash
RED='\033[0;31m'
PINK='\033[0;35m'
GRAY='\033[0;37m'
NC='\033[0m'
set -e
set -u

DIR="$(dirname "$(realpath "$BASH_SOURCE")")"
. "$DIR/routine.sh"

echo -e "[$PINK 1 $NC] Base system installation"
echo -e "[$PINK 2 $NC] Shell installation (Bash)"
echo -e "[$PINK 3 $NC] IDE installation (Neovim)"
echo -e "[$PINK 4 $NC] GUI installation (GNOME)"
echo -e "[$PINK 5 $NC] Red Team starter pack"
echo -e "[$PINK 6 $NC] Blue Team starter pack"
echo -e "[$PINK 0 $NC] Exit"
while true; do

    echo -ne "[$GRAY \$ $NC]: "
    read selection
    case "$selection" in

        1) process "$DIR/system" && exit ;;
        2) process "$DIR/shell" && exit ;;
        3) process "$DIR/ide" && exit ;;
        4) process "$DIR/gui" && exit ;;
        5) process "$DIR/redteam" && exit ;;
        6) process "$DIR/blueteam" && exit ;;
        0) exit ;;
        *) echo -e "[$RED - $NC] Invalid selection" ;;
    esac
    [[ "$?" -ne 0 ]] && exit "$?"
done

#!/bin/bash
RED='\033[0;31m'
PINK='\033[0;35m'
GRAY='\033[0;37m'
NC='\033[0m'
set -e
set -u

DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

echo -e "[$PINK 1 $NC] Base system installation"
echo -e "[$PINK 2 $NC] Shell installation (Bash)"
echo -e "[$PINK 3 $NC] IDE installation (Neovim)"
echo -e "[$PINK 4 $NC] GUI installation (GNOME)"
echo -e "[$PINK 5 $NC] GUI post installation"
echo -e "[$PINK 0 $NC] Exit"
while true; do

    echo -ne "[$GRAY \$ $NC]: "
    read SELECTION
    case "$SELECTION" in

        1) "$DIR"/system/_run_.sh && exit ;;
        2) "$DIR"/shell/_run_.sh && exit ;;
        3) "$DIR"/ide/_run_.sh && exit ;;
        4) "$DIR"/gui/_run_.sh && exit ;;
        5) "$DIR"/gui/_run_post_.sh && exit ;;
        0) exit ;;
        *) echo -e "[$RED - $NC] Invalid selection" ;;
    esac
    [[ "$?" -ne 0 ]] && exit "$?"
done

#!/bin/bash
RED='\033[0;31m'
GRAY='\033[0;37m'
NC='\033[0m'
set -e
set -u

echo
while true; do

    echo -ne "[$GRAY \$ $NC] Hostname: "
    read ANSWER

    [[ -n "$ANSWER" && "$ANSWER" =~ ^[a-z0-9_-]+$ ]] && break
    echo -e "[$RED - $NC] Invalid hostname"
done
echo "$ANSWER" >"/etc/hostname"

echo -e "[$GRAY \$ $NC] Root password: "
passwd
echo
while true; do

    echo -ne "[$GRAY \$ $NC] User login: "
    read ANSWER

    [[ -n "$ANSWER" && "$ANSWER" =~ ^[a-z_][a-z0-9_-]*$ ]] && break
    echo -e "[$RED - $NC] Invalid login"
done
USERNAME="$ANSWER"

id "$USERNAME" &>"/dev/null" ||
    useradd -m -g "users" -G "wheel" "$USERNAME" >"/dev/null"

echo -e "[$GRAY \$ $NC] User password: "
passwd "$USERNAME"

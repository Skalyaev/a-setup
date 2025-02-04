#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[0;35m'
GRAY='\033[0;37m'
NC='\033[0m'
set -e

echo -ne "\n[$GREEN + $NC] Installing GNOME..."

pacman -S --noconfirm gnome &>"/dev/null"
systemctl enable gdm &>"/dev/null"

echo -e "\r[$GREEN + $NC] GNOME installed    "

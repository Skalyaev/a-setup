#!/bin/bash
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

while ! ping -c 1 "archlinux.org" &>"/dev/null"; do

    echo -e "\n[$RED - $NC] Connection required"
    echo -e "[$YELLOW * $NC] Running 'iwctl'"
    iwctl
done

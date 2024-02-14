#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

root=$(dirname $(realpath $0))
list="$root/list"

echo "================ Apt packages..."
packages=$(
    cat "$list/install/apt.md" \
    | grep -v "^#" \
    | grep -v '^$' \
    | awk -F ': ' '{print $2}' \
    | tr "\n" " " \
    | uniq
)
sudo apt update -y
sudo apt install -y $packages

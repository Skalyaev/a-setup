#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

PKG="xsstrike"

GIT_URL="https://github.com/s0md3v"
DST="/usr/local/src/github/$PKG"

if [[ ! -e "$DST" ]]; then

    echo -ne "[$YELLOW * $NC] Cloning '$PKG'..."
    git clone "$GIT_URL/$PKG.git" "$DST" &>"/dev/null"

    echo -e "\r[$GREEN + $NC] '$PKG' cloned    "
    cd "$DST"
else
    cd "$DST"
    echo -ne "[$YELLOW * $NC] Checking '$PKG'..."
    FETCH="$(git fetch)"

    echo -ne "\r$(python -c "print(' ' * $(tput cols), end='')")\r"
    [[ -z "$FETCH" ]] && continue
fi
cat <<EOF >".install.sh"
pip install -r requirements.txt
chmod +x xsstrike.py
sudo ln -sf $PWD/xsstrike.py /usr/local/bin/xsstrike
EOF
echo -ne "[$GREEN + $NC] Installing '$PKG'..."

chmod +x ".install.sh" && bash ".install.sh" &>"/dev/null"
echo -e "\r[$GREEN + $NC] '$PKG' installed    "

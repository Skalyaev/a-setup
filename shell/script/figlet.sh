#!/bin/bash
set -e
set -u

rm -rf "/usr/share/figlet/fonts/*"
cd "/usr/local/src/github/figlet-fonts"
bash ".install.sh" &>"/dev/null"

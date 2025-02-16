#!/bin/bash
set -e
set -u

FONT="redhat"

SRC="$HOME/.local/src/$FONT"
DST="/usr/share/fonts/$FONT"

[[ -e "$DST" ]] && sudo rm -rf "$DST"
sudo ln -sf "$SRC" "$DST"

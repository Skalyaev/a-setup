#!/bin/bash
set -e
set -u

FONT="redhat"

SRC="$HOME/.local/src/$FONT"
DST="/usr/share/fonts/$FONT"

sudo ln -sf "$SRC" "$DST"

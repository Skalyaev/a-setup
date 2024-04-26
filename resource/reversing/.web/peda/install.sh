#!/bin/bash
URL="https://github.com/longld/peda"
DST="$HOME/.local/src/peda"

git clone "$URL" "$DST"
chown -R "$USER:$USER" "$DST"

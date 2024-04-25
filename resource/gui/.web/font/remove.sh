#!/bin/bash
DST="/usr/share/fonts/Terminus"
[[ -e "$DST" ]] || exit 0
rm -rf "$DST" || exit 1
fc-cache -f -v
exit 0

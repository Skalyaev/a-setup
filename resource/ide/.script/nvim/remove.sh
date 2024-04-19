#!/bin/bash
DST="$HOME/.local/src/neovim"
cd "$DST" || exit 1
cmake --build "build/" --target "uninstall"
rm -rf "$DST"
rm "$HOME/.config/nvim"
exit 0

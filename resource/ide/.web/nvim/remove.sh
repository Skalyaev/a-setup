#!/bin/bash
DST="$HOME/.local/src/nvim"
cd "$DST" || exit 1
cmake --build "build/" --target "uninstall" >"/dev/null"
rm -rf "$DST"
rm -rf "$HOME/.config/nvim"
rm -rf "$HOME/state/nvim"
rm -rf "$HOME/lib/nvim"
rm -rf "$HOME/share/nvim"
rm -rf "$HOME/.local/src/a-neovim-theme"

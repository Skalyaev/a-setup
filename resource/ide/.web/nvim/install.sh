#!/bin/bash
DEPS=(
    "ninja-build"
    "gettext"
    "cmake"
    "unzip"
    "curl"
    "build-essential"
)
for dep in "${DEPS[@]}";do
    dpkg-query -W -f='${Status}' "$dep" 2>"/dev/null"\
        | grep -q "install ok installed"\
        && continue
    apt install -y "$dep" &>"/dev/null" || exit 1
    [[ "$NO_BACKUP" ]] || DIFF+=("apt:$dep")
done
URL="https://github.com/neovim/neovim"
DST="$HOME/.local/src/nvim"

git clone "$URL" "$DST" && cd "$DST" || exit 1
chown -R "$USER:$USER" "$DST"
git checkout "stable" || exit 1
make CMAKE_BUILD_TYPE="RelWithDebInfo"\
    CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local"\
    >"/dev/null" || exit 1
make install >"/dev/null"
make clean >"/dev/null"
chown -R "$USER:$USER" "$HOME/.cache"
chown -R "$USER:$USER" "$HOME/.local"

CONFIG="$HOME/.config/nvim"
[[ ! -e "$CONFIG" ]] && ! mkdir "$CONFIG" && exit 1
chown "$USER:$USER" "$CONFIG"
[[ ! -e "$CONFIG/colors" ]] && ! mkdir "$CONFIG/colors" && exit 1
chown "$USER:$USER" "$CONFIG/colors"

URL="https://github.com/Skalyaeve/a-nvim-theme.git"
SRC="$HOME/.local/src/a-nvim-theme"
[[ ! -e "$SRC" ]] && ! git clone "$URL" "$SRC" && exit 1
chown -R "$USER:$USER" "$SRC"

[[ ! -e "$CONFIG/colors/neon" ]]\
    && ln -s "$SRC/colors/neon.lua" "$CONFIG/colors/neon.lua"\
    && chown -h "$USER:$USER" "$CONFIG/colors/neon.lua"

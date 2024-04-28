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
chown -R "$USER:$USER" "$DST"
chown -R "$USER:$USER" "$HOME/.cache"
chown -R "$USER:$USER" "$HOME/.local"

if [[ ! "NO_BACKUP" ]]; then
    [[ ! -e "$HOME/.local/state" ]]\
        && DIFF+=("add:$HOME/.local/state")
    [[ ! -e "$HOME/.local/lib" ]]\
        && DIFF+=("add:$HOME/.local/lib")
    [[ ! -e "$HOME/.local/share/applications" ]]\
        && DIFF+=("add:$HOME/.local/share/applications")
    [[ ! -e "$HOME/.local/share/icons" ]]\
        && DIFF+=("add:$HOME/.local/share/icons")
    [[ ! -e "$HOME/.local/share/man" ]]\
        && DIFF+=("add:$HOME/.local/share/man")
    [[ ! -e "$HOME/.local/share/locale" ]]\
        && DIFF+=("add:$HOME/.local/share/locale")
fi

CONFIG="$HOME/.config/nvim"
if [[ ! -e "$CONFIG" ]]; then
    ! mkdir "$CONFIG" && exit 1
    chown "$USER:$USER" "$CONFIG"
fi
if [[ ! -e "$CONFIG/colors" ]]; then
    ! mkdir "$CONFIG/colors" && exit 1
    chown "$USER:$USER" "$CONFIG/colors"
fi

URL="https://github.com/Skalyaeve/a-nvim-theme.git"
SRC="$HOME/.local/src/a-nvim-theme"
if [[ ! -e "$SRC" ]]; then
    ! git clone "$URL" "$SRC" && exit 1
    chown -R "$USER:$USER" "$SRC"
fi
[[ ! -e "$CONFIG/colors/neon" ]]\
    && ln -s "$SRC/colors/neon.lua" "$CONFIG/colors/neon.lua"\
    && chown -h "$USER:$USER" "$CONFIG/colors/neon.lua"

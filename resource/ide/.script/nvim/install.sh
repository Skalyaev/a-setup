#!/bin/bash
PKGS=(
    "ninja-build"
    "gettext"
    "cmake"
    "unzip"
    "curl"
    "build-essential"
)
for pkg in "${PKGS[@]}";do
    dpkg-query -W -f='${Status}' "$pkg" 2>"/dev/null"\
        | grep -q "install ok installed"\
        && continue
    apt install -y "$pkg" &>"/dev/null" || exit 1
    [[ "$NO_BACKUP" ]] || DIFF+=("apt:$pkg")
done
NAME="neovim"
URL="https://github.com/$NAME/$NAME"
DST="$HOME/.local/src/$NAME"
if [[ -e "$DST" ]];then
    cd "$DST" || exit 1
    make distclean
    git checkout "master" || exit 1
    ret="$(git pull)"
    [[ "$ret" == "Déjà à jour."\
        || "$ret" == "Already up to date." ]]\
        && exit -1
    [[ "$?" -ne 0 ]] && exit 1
else
    git clone "$URL" "$DST" && cd "$DST" || exit 1
fi

chown -R "$USER:$USER" "."
git checkout "stable" || exit 1
make CMAKE_BUILD_TYPE="RelWithDebInfo"\
    CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local"\
    || exit 1
make install
make clean
chown -R "$USER:$USER" "$HOME/.cache"
chown -R "$USER:$USER" "$HOME/.local"

CONFIG="$HOME/.config/nvim"
[[ ! -e "$CONFIG" ]] && ! mkdir "$CONFIG" && exit 1

URL="https://github.com/Skalyaeve/a-nvim-theme.git"
SRC="$HOME/.local/src/a-nvim-theme"
[[ ! -e "$SRC" ]] && ! git clone "$URL" "$SRC" && exit 1
mkdir -p "$CONFIG/colors" || exit 1
[[ -e "$CONFIG/colors/neon" ]]\
    || ln -s "$SRC/colors/neon.lua" "$CONFIG/colors/neon.lua"
chown -R "$USER:$USER" "$CONFIG"
chown -R "$USER:$USER" "$SRC"
exit 0

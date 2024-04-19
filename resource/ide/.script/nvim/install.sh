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
    if dpkg-query -W -f='${Status}' "$pkg"\
        | grep -q "install ok installed"
    then
        continue
    fi
    if ! apt install -y "$pkg" &>"/dev/null";then
        exit 1
    fi
    [[ "$NO_BACKUP" ]] || DIFF+=("apt:$pkg")
done
NAME="neovim"
URL="https://github.com/$NAME/$NAME"
DST="$HOME/.local/src/$NAME"
if [[ -e "$DST" ]];then
    cd "$DST" || exit 1
    make distclean
    git checkout "master" || exit 1
    if [[ "$(git pull)" == "Déjà à jour."\
        || "$(git pull)" == "Already up to date." ]]
    then
        exit 0
    fi
    [[ "$?" != 0 ]] && exit 1
else
    git clone "$URL" "$DST" && cd "$DST" || exit 1
fi
git checkout "stable" || exit 1
make CMAKE_BUILD_TYPE="RelWithDebInfo"\
    CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local"\
    || exit 1
make install
make clean

CONFIG="$HOME/.config/nvim"
if [[ ! -e "$CONFIG" ]];then
    mkdir "$CONFIG" || exit 1
fi
URL="https://raw.githubusercontent.com/Skalyaeve/a-neovim-theme"
SRC="$HOME/.local/src/a-neovim-theme"
if [[ ! -e "$SRC" ]];then
    git clone "$URL" "$SRC" || exit 1
fi
[[ -e "$CONFIG/colors" ]] || ln -s "$SRC/colors" "$CONFIG/colors"
exit 0

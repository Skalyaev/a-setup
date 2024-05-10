#!/bin/bash
dst="$HOME/.local/src/nvim"
if [[ ! -e "$dst" ]];then
    echo -e\
        "\r[$YELLOW WRN $NC] $dst not found,$BLUE installing$NC..."
    bash "install.sh"
    exit 0
fi
cd "$dst" || exit 1
echo -ne "\r${BLUE}updating$NC $pkg..."

git checkout "master" || exit 1
ret="$(git pull)"
if [[ "$?" -ne 0 ]];then
    git checkout "stable"
    exit 1
fi
if grep -q "Already up to date" <<< "$ret"\
    || grep -q "Déjà à jour" <<< "$ret"
then
    git checkout "stable"
    echo -ne "\r$pkg "
    exit 0
fi
git checkout "stable"
make distclean >"/dev/null" || exit 1
make CMAKE_BUILD_TYPE="RelWithDebInfo"\
    CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local"\
    >"/dev/null" || exit 1
make install >"/dev/null"
make clean >"/dev/null"

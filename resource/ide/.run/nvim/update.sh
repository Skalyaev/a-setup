#!/bin/bash
dst="$HOME/.local/src/nvim"
if [[ ! -e "$dst" ]];then
    echo -e\
        "\r[$YELLOW WRN $NC] $dst not found,$BLUE installing$NC..."
    bash "install.sh"
    exit 0
fi
cd "$dst" || exit 1

git checkout "master" >"/dev/null" || exit 1
ret="$(git status)"
if [[ "$?" -ne 0 ]];then
    git checkout "stable" >"/dev/null"
    exit 1
fi
if grep -q "Votre branche est à jour" <<< "$ret"\
    || grep -q "Your branch is up to date" <<< "$ret"
then
    git checkout "stable" >"/dev/null" || exit 1
    exit 0
fi
echo -e "\r${BLUE}updating$NC $pkg..."
git pull || exit 1

git checkout "stable" >"/dev/null"
make distclean >"/dev/null" || exit 1
make CMAKE_BUILD_TYPE="RelWithDebInfo"\
    CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local"\
    >"/dev/null" || exit 1
make install >"/dev/null"
make clean >"/dev/null"

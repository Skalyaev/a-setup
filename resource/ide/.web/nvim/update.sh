#!/bin/bash
DST="$HOME/.local/src/nvim"
if [[ ! -e "$DST" ]];then
    echo -e "\r[$RED WRN $NC] $DST not found,$BLUE installing$NC..."
    bash "install.sh"
    exit 0
fi
cd "$DST" || exit 1

git checkout "master" >"/dev/null" || exit 1
ret="$(git status)"
if [[ "$?" -ne 0 ]];then
    git checkout "stable" >"/dev/null"
    exit 1
fi
if grep -q "Votre branche est à jour" <<< "$ret"\
    || grep -q "Your branch is up to date" <<< "$ret"
then
    git checkout "stable" >"/dev/null"
    exit 0
fi
echo -e "\r${BLUE}updating$NC $pkg..."
make distclean >"/dev/null"
git pull
make CMAKE_BUILD_TYPE="RelWithDebInfo"\
    CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local"\
    >"/dev/null" || exit 1
make install >"/dev/null"
make clean >"/dev/null"
chown -R "$USER:$USER" "$HOME/.cache"
chown -R "$USER:$USER" "$HOME/.local"

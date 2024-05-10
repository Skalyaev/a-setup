#!/bin/bash
dst="/usr/share/themes/a-linux-theme"
if [[ ! -e "$dst" ]];then
    echo -e\
        "\r[$YELLOW WRN $NC] $dst not found,$BLUE installing$NC..."
    bash "install.sh"
    exit 0
fi
cd "$dst" || exit 1
echo -ne "\r${BLUE}updating$NC $pkg..."

rm -rf *
ret="$(git pull)"
if [[ "$?" -ne 0 ]];then
    git restore *
    exit 1
fi
if grep -q "Already up to date" <<< "$ret"\
    || grep -q "Déjà à jour" <<< "$ret"
then
    git restore *
    unzip "theme.zip" || exit 1
    echo -ne "\r$pkg "
    exit 0
fi
unzip "theme.zip" || exit 1

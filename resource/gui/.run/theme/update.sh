#!/bin/bash
dst="/usr/share/themes/a-linux-theme"
if [[ ! -e "$dst" ]];then
    echo -e\
        "\r[$YELLOW WRN $NC] $dst not found,$BLUE installing$NC..."
    bash "install.sh"
    exit 0
fi
cd "$dst" || exit 1

ret="$(git status)"
[[ "$?" -ne 0 ]] && exit 1
if grep -q "Votre branche est à jour" <<< "$ret"\
    || grep -q "Your branch is up to date" <<< "$ret"
then
    exit 0
fi
echo -e "\r${BLUE}updating$NC $pkg..."
rm -rf "$dst/*"
git pull || exit 1
unzip theme.zip || exit 1

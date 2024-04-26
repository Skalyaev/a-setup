#!/bin/bash
DST="$HOME/.local/src/peda"
if [[ ! -e "$DST" ]];then
    echo -e "\r[$RED WRN $NC] $DST not found,$BLUE installing$NC..."
    bash "install.sh"
    exit 0
fi
cd "$DST" || exit 1

ret="$(git status)"
[[ "$?" -ne 0 ]] && exit 1

if grep -q "Votre branche est à jour" <<< "$ret"\
    || grep -q "Your branch is up to date" <<< "$ret"
then
    exit 0
fi
echo -e "\r${BLUE}updating$NC $pkg..."
git pull
chown -R "$USER:$USER" "$DST"

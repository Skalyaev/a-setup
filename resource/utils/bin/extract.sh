#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
GRAY='\033[0;37m'
NC='\033[0m'

USAGE="$GRAY===================USAGE
$YELLOW$(basename "$0") $BLUE<archive(s)>$NC
"
if [[ "$#" -eq 0 ]];then
    echo -e "$USAGE"
    exit 1
fi
is_installed(){
    local pkg="$1"
    dpkg-query -W -f='${Status}' "$pkg" 2>"/dev/null"\
        | grep -q "install ok installed"\
        && return 0
    echo -e "$pkg needed, install ?"
    read -p "y/n: " -n 1 -r
    echo
    [[ "$REPLY" != 'y' ]] && return 1
    sudo apt install -y "$pkg" || return 1
    return 0
}
do_extract(){
    local app="$1"
    local cmd="$2"
    is_installed "$app" || return 1
    echo -e "${BLUE}extracting$NC $FILE..."
    eval "$cmd"
    echo -e "[$GREEN OK $NC] $FILE"
    return 0
}
while [[ "$#" -gt 0 ]];do
    FILE="$1"
    shift
    if [[ ! -e "$FILE" ]];then
        echo -e "[$RED ERR $NC] not found: $FILE"
        continue
    fi
    case "$FILE" in
    # <package name> <extract command>
    *'.zip') do_extract 'unzip' "unzip -q $FILE";;
    *'.rar') do_extract 'unrar' "unrar x -o- $FILE";;
    *'.iso') do_extract 'p7zip-full' "7z x $FILE";;
    *'.tar') do_extract 'tar' "tar xf $FILE";;
    *'.tar.gz') do_extract 'tar' "tar xzf $FILE";;
    *'.tar.xz') do_extract 'tar' "tar xJf $FILE";;
    *'.tar.bz2') do_extract 'tar' "tar xjf $FILE";;
    *'.gz') do_extract 'gzip' "gunzip $FILE";;
    *'.tgz') do_extract 'tar' "tar xzf $FILE";;
    *) echo -e "[$RED ERR $NC] unknown type: $FILE";;
    esac
done

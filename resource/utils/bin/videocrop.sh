#!/bin/bash
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
GRAY='\033[0;37m'
NC='\033[0m'

USAGE="$GRAY===================USAGE
$YELLOW$(basename "$0") $BLUE<file> <width> <height> <x> <y>$NC
"
if [[ "$#" -lt 5 ]];then
    echo -e "$USAGE"
    exit 1
fi
ffmpeg -i "$1" -filter:v "crop=$2:$3:$4:$5" "crop_${1%.*}.${1##*.}"

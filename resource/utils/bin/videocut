#!/bin/bash
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
GRAY='\033[0;37m'
NC='\033[0m'

USAGE="$GRAY===================USAGE
$YELLOW$(basename "$0") $BLUE<file> <start> <end>$NC
"
if [[ "$#" -lt 3 ]];then
    echo -e "$USAGE"
    exit 1
fi
ffmpeg -i "$1"\
    -ss "$2"\
    -to "$3"\
    "cut_${1%.*}.${1##*.}"

#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m'

USAGE="$GRAY===================USAGE
$YELLOW$(basename "$0") $BLUE<target> $GREEN[options]$NC

$BLUE<target>$NC:
    $RED*$NC description

$GREEN[options]$NC:
-h, --help
    $RED*$NC Print this message
"
if (( "$#" < 1 )); then
    echo -e "$USAGE"
    exit 1
fi

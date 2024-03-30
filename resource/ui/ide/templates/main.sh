#!/bin/bash
PATH='/bin:/sbin:/usr/bin:/usr/sbin'

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
GRAY='\033[0;37m'
NC='\033[0m'

USAGE="$GRAY===================USAGE$NC
$YELLOW$(basename "$0") $BLUE<command> $GREEN[options]$NC

<command>:
\t${BLUE}command$NC:
\t* description

[options]:
\t$GREEN-o, --option$NC
\t* description"
#
#
#==================================PARSE
if [ "$#" -lt 1 ]; then
    echo -e "$USAGE"
    exit 1
fi

#!/bin/bash
PATH='/bin:/sbin:/usr/bin:/usr/sbin'

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
GRAY='\033[0;37m'
NC='\033[0m'

USAGE="${GRAY}===================usage${NC}
${YELLOW}$(basename "$0") ${BLUE}<command> ${GREEN}[options]${NC}

<command>:
${BLUE}install${NC}:
\t* From a resource directory.
\t* Install or update targets specified in *.list files.
\t* Swap targets specified in .swap files.
${BLUE}restore${NC}:
\t* From a backup directory.
\t* Perform backup using diff file.

[options]:
${GREEN}-u, --user USER${NC}
\t* Setup for the specified user's home directory.
${GREEN}-p, --path PATH${NC}
\t* Specify a path to the resource or backup directory.
\t* Default is ~/.local/share/setup/(resource|backup)
${GREEN}-e, --exclude DIR[S]${NC}
\t* When ${BLUE}install${NC}, exclude the specified directories.
${GREEN}-s, --silent${NC}
\t* Run in silent mode.
${GREEN}-n, --ninja${NC}
\t* When ${BLUE}install${NC}, do not read *.list files.
${GREEN}--no-apt${NC}
\t* When ${BLUE}install${NC}, do not read apt.list files.
${GREEN}--no-web${NC}
\t* When ${BLUE}install${NC}, do not read web.list files.
${GREEN}--no-swap${NC}
\t* When ${BLUE}install${NC}, do not read .swap files.
"

ft_echo() {
    if [ -z "$SILENT" ]; then
        echo -ne "$@"
    fi
}

#!/bin/bash
PATH='/bin:/sbin:/usr/bin:/usr/sbin'

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
GRAY='\033[0;37m'
NC='\033[0m'

USAGE="${GRAY}===================usage${NC}
${YELLOW}$(basename $0) ${BLUE}<command> ${GREEN}[options]${NC}

<command>:
\t${BLUE}install${NC}:
\t\t* From a resource directory.
\t\t* Install or update targets specified in *.list files.
\t\t* Swap targets specified in .swap files.
\t${BLUE}restore${NC}:
\t\t* From a backup directory.
\t\t* Perform backup using diff file.

[options]:
\t${GREEN}-u, --user USER${NC}
\t\t* Setup for the specified user's home directory.
\t${GREEN}-p, --path PATH${NC}
\t\t* Specify a path to the resource or backup directory.
\t\t* Default is ~/.local/share/setup/(resource|backup)
\t${GREEN}-e, --exclude DIR[S]${NC}
\t\t* When ${BLUE}install${NC}, exclude the specified directories.
\t${GREEN}-s, --silent${NC}
\t\t* Run in silent mode.
\t${GREEN}-n, --ninja${NC}
\t\t* When ${BLUE}install${NC}, do not read *.list files.
\t${GREEN}--no-apt${NC}
\t\t* When ${BLUE}install${NC}, do not read apt.list files.
\t${GREEN}--no-web${NC}
\t\t* When ${BLUE}install${NC}, do not read web.list files.
\t${GREEN}--no-local${NC}
\t\t* When ${BLUE}install${NC}, do not read .swap files.
"

ft_echo() {
    if [ -z "$SILENT" ]; then
        echo -ne "$@"
    fi
}

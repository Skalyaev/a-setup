#!/bin/bash
PATH='/bin:/sbin:/usr/bin:/usr/sbin'

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
GRAY='\033[0;37m'
NC='\033[0m'

USAGE="${GRAY}===================${NC}usage
${YELLOW}setup ${BLUE}<command> ${GREEN}[options]${NC}

<command>:
    ${BLUE}install${NC}:
    - From a resource directory.
    - Install or update targets specified in *.list files.
    - Swap targets specified in .swap files.
    ${BLUE}restore${NC}:
    - From a backup directory.
    - Perform backup using diff file.

[options]:
    ${GREEN}-u, --user USER${NC}
    Setup for the specified user's home directory.
    ${GREEN}-p, --path PATH${NC}
    Specify a path to the resource or backup directory.
    Default is ~/.local/share/setup/(resource|backup)
    ${GREEN}-e, --exclude DIR[S]${NC}
    When ${BLUE}install${NC}, exclude the specified directories.
    ${GREEN}-s, --silent${NC}
    Run in silent mode.
    ${GREEN}-n, --ninja${NC}
    When ${BLUE}install${NC}, do not read *.list files.
    ${GREEN}--no-apt${NC}
    When ${BLUE}install${NC}, do not read apt.list files.
    ${GREEN}--no-web${NC}
    When ${BLUE}install${NC}, do not read web.list files.
    ${GREEN}--no-local${NC}
    When ${BLUE}install${NC}, do not read .swap files.
"

ft_echo() {
    if [ -z "$SILENT" ]; then
        echo -ne "$@"
    fi
}

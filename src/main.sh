#!/bin/bash
PATH='/bin:/sbin:/usr/bin:/usr/sbin'

BLUE='\033[0;34m'
GRAY='\033[0;37m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

USAGE="
${GRAY}===================${NC}usage\n
${YELLOW}setup ${BLUE}COMMAND ${GREEN}[options]${NC}\n
\n
COMMAND:\n
\t  ${BLUE}install${NC}:\n
\t  - Navigate through the resource directory.\n
\t  - Install or update targets specified in *.list files.\n
\t  - * = apt, git, curl
\t  - Swap targets specified in .swap files.\n
\t  ${BLUE}restore${NC}\n
\t  - Navigate to a backup directory.\n
\t  - Perform backup using diff file.\n
\n
[options]:\n
\t  ${GREEN}-p, --path PATH${NC}\n
\t  Specify a path to a resource or backup directory.\n
\t  Default is ~/.local/share/setup/(resource|backup)\n
\t  ${GREEN}-t, --target DIRS${NC}\n
\t  Target only the specified directories.\n
\t  ${GREEN}-e, --exclude DIRS${NC}\n
\t  Exclude the specified directories.\n
\t  ${GREEN}-s, --silent${NC}\n
\t  Run in silent mode.\n
\t  ${GREEN}-n, --ninja${NC}\n
\t  Do not read *.list files.\n
\t  ${GREEN}--no-apt${NC}\n
\t  Do not read apt.list files.\n
\t  ${GREEN}--no-git${NC}\n
\t  Do not read git.list files.\n
\t  ${GREEN}--no-curl${NC}\n
\t  Do not read curl.list files.\n
\t  ${GREEN}--no-backup${NC}\n
\t  Do not create backup directory.\n
\n
"

if [ "$EUID" -eq 0 ]; then
    IS_ROOT=1
fi

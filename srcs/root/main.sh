#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin

GREEN='\033[0;32m'
RED='\033[0;31m'
GRAY='\033[0;37m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

UI_GROUP=(
    gui
    terminal
    ide
    tools
)
PENTEST_GROUP=(
    info_gathering
    web_analysis
    db_assessment
    passw_atk
    exploitation
    prives
    sniff_spoof
    wireless_atk
    vuln_analysis
    reverse
    report
)

CONFIG_FILE=~/.config/setup/config
DO_APT=1
DO_GIT=1
DO_CURL=1

ft_echo() {
    if [ $SILENT != 1 ]; then
        echo -e "$1"
    fi
}

is_inside() {
    local tab=("${@:1:$#-1}")
    local item="${@: -1}"
    for x in "${tab[@]}"; do
        if [ "$x" = "$item" ]; then
            return 0
        fi
    done
    return 1
}

USAGE="
${GRAY}===================${NC}usage\n
${YELLOW}setup ${GREEN}COMMAND GROUP ${BLUE}[targets] [options]${NC}\n
\n
COMMAND:\n
\t  ${GREEN}install${NC}:\n
\t\t    - Install targets if not already installed.\n
\t\t    - Configure targets anyway.\n
\t  ${GREEN}update${NC}\n
\t\t    - Update targets if already installed.\n
\t  ${GREEN}restore${NC}\n
\t\t    - Remove targets we installed.\n
\t\t    - Undo the configurations we made.\n
GROUP:\n
\t  ${GREEN}all ${GRAY}| ${GREEN}ui ${GRAY}| ${GREEN}pentest${NC}\n
\n
${GRAY}===================${NC}targets\n
${GREEN}ui${NC} group:\n
\t  ${BLUE}gui${NC}\n
\t  ${BLUE}terminal${NC}\n
\t  ${BLUE}ide${NC}\n
\t  ${BLUE}tools${NC}\n
\n
${GREEN}pentest${NC} group:\n
\t  ${BLUE}info_gathering${NC}\n
\t  ${BLUE}web_analysis${NC}\n
\t  ${BLUE}db_assessment${NC}\n
\t  ${BLUE}passw_atk${NC}\n
\t  ${BLUE}exploitation${NC}\n
\t  ${BLUE}privesc${NC}\n
\t  ${BLUE}sniff_spoof${NC}\n
\t  ${BLUE}wireless_atk${NC}\n
\t  ${BLUE}vuln_analysis${NC}\n
\t  ${BLUE}reverse${NC}\n
\t  ${BLUE}report${NC}\n
\n
${GRAY}===================${NC}options\n
\t  ${BLUE}-c, --config PATH${NC}\n
\t\t    Use a specific config file.\n
\t  ${BLUE}-e, --exclude TARGETS${NC}\n
\t\t    Exclude specific ${BLUE}targets${NC}.\n
\t  ${BLUE}-s, --silent${NC}\n
\t\t    Run in silent mode.\n
\t  ${BLUE}-n, --ninja${NC}\n
\t\t    Do not install any external resources.\n
\t  ${BLUE}--no-apt${NC}\n
\t\t    Do not install apt packages.\n
\t  ${BLUE}--no-git${NC}\n
\t\t    Do not install git repositories.\n
\t  ${BLUE}--no-curl${NC}\n
\t\t    Do not install other external resources.\n
\n
${GRAY}===================${NC}exemples\n
${YELLOW}setup ${GREEN}install all ${BLUE}terminal privesc report -c ~/exemple -s${NC}\n
${YELLOW}setup ${GREEN}install pentest ${BLUE}-e reverse vuln_analysis${NC}\n
${YELLOW}setup ${GREEN}install ui ${BLUE}terminal tools -n${NC}\n
${YELLOW}setup ${GREEN}update all ${BLUE}--no-apt${NC}\n
"

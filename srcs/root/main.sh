#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin

BLUE='\033[0;34m'
GRAY='\033[0;37m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

USAGE="
${GRAY}===================${NC}usage\n
${YELLOW}setup ${GREEN}COMMAND GROUP ${BLUE}[targets] [options]${NC}\n
\n
COMMAND:\n
\t  ${GREEN}install${NC}:\n
\t  - Install targets if not installed.\n
\t  - Update targets if already installed.\n
\t  - Configure targets anyway.\n
\t  ${GREEN}restore${NC}\n
\t  - Remove targets we installed.\n
\t  - Undo the configurations we made.\n
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
\t  Use a specific config file.\n
\t  ${BLUE}-e, --exclude TARGETS${NC}\n
\t  Exclude specific ${BLUE}targets${NC}.\n
\t  ${BLUE}-s, --silent${NC}\n
\t  Run in silent mode.\n
\t  ${BLUE}-n, --ninja${NC}\n
\t  Do not install any external resources.\n
\t  ${BLUE}--no-apt${NC}\n
\t  Do not install apt packages.\n
\t  ${BLUE}--no-git${NC}\n
\t  Do not install git repositories.\n
\t  ${BLUE}--no-curl${NC}\n
\t  Do not install other external resources.\n
\t  ${BLUE}--no-backup${NC}\n
\t  Do not create backup for this ${YELLOW}install${NC}.\n
\t  Backups are used for ${YELLOW}restore${NC}.\n
\n
${GRAY}===================${NC}exemples\n
${YELLOW}setup ${GREEN}install all ${BLUE}terminal privesc report -c ~/exemple -s${NC}\n
${YELLOW}setup ${GREEN}install all ${BLUE}-e gui reverse${NC}\n
${YELLOW}setup ${GREEN}install ui ${BLUE}terminal tools -n -s${NC}\n
${YELLOW}setup ${GREEN}update all ${BLUE}--no-apt${NC}\n
"

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

if [ "$EUID" -eq 0 ]; then
    IS_ROOT=1
fi

ft_echo() {
    if [ -z $SILENT ]; then
        echo -e "$@"
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

ft_apt() {
    local package="$1"
    if [ -z $NO_APT ]; then
        if ! dpkg -s "$package" >/dev/null; then
            ft_echo "installing $package..."
            apt install -y "$package" >/dev/null
            if [ $? -eq 0 ]; then
                ft_echo "$package ${GREEN}installed${NC}"
                DIFF+=("apt:$package")
            else
                ft_echo "[$RED ERROR $NC] Non-zero returned from apt."
                ft_echo "You may need to run this command with sudo."
                ft_echo "Dont forget to specify your config file with ${BLUE}-c${NC} option."
                exit 1
            fi
        fi
    fi
}

ft_git() {
    local src="$1"
    local dirname=$(basename "$src")
    local dst="$ROOT/resources/git/$dirname"
    if [ -z $NO_GIT ]; then
        if [ ! -e "$dst" ]; then
            ft_echo "cloning $src..."
            git clone "$src" "$dst" >/dev/null
            if [ $? -eq 0 ]; then
                ft_echo "$dirname ${GREEN}cloned${NC}"
            else
                ft_echo "[$RED ERROR $NC] Non-zero returned from git."
                exit 1
            fi
        else
            ft_echo "updating $src..."
            cd "$dst" && git pull >/dev/null
            if [ $? -eq 0 ]; then
                ft_echo "$dirname ${GREEN}updated${NC}"
            else
                ft_echo "[$RED ERROR $NC] Non-zero returned from git."
                exit 1
            fi
        fi
    fi
}

ft_curl() {
    local src="$1"
    local dst="$ROOT/resources/curl/$repo"
    if [ -z $NO_CURL ]; then
        if [ ! -e "$dst" ]; then
            ft_echo "downloading $src..."
            curl -sL "$src" -o "$dst" >/dev/null
            if [ $? -eq 0 ]; then
                ft_echo "$src ${GREEN}downloaded${NC}"
            else
                ft_echo "[$RED ERROR $NC] Non-zero returned from curl."
                exit 1
            fi
        fi
    fi
}

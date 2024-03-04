#================================== USAGE
USAGE="
${GRAY}===================${NC}usage\n
${YELLOW}setup ${GREEN}COMMAND GROUP ${BLUE}[targets] [options]${NC}\n
\n
COMMAND:\n
\t  ${GREEN}install ${GRAY}| ${GREEN}update ${GRAY}| ${GREEN}remove${NC}\n
GROUP:\n
\t  ${GREEN}all ${GRAY}| ${GREEN}ui ${GRAY}| ${GREEN}pentest${NC}\n
\n
${GRAY}===================${NC}targets\n
${GREEN}ui${NC} group:\n
\t  ${BLUE}terminal${NC}\n
\t  ${BLUE}ide${NC}\n
\t  ${BLUE}gui${NC}\n
\t  ${BLUE}tools${NC}\n
\n
${GREEN}pentest${NC} group:\n
\t  ${BLUE}info${GRAY}[_gathering]${NC}\n
\t  ${BLUE}vuln${GRAY}[_analysis]${NC}\n
\t  ${BLUE}web${GRAY}[_analysis]${NC}\n
\t  ${BLUE}db${GRAY}[_assessment]${NC}\n
\t  ${BLUE}pass${GRAY}[w_atk]${NC}\n
\t  ${BLUE}exploit${GRAY}[ation]${NC}\n
\t  ${BLUE}privesc${NC}\n
\t  ${BLUE}sniff${GRAY}[_spoof]${NC}\n
\t  ${BLUE}wire${GRAY}[less_atk]${NC}\n
\t  ${BLUE}rev${GRAY}[erse]${NC}\n
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
${YELLOW}setup ${GREEN}install pentest ${BLUE}-e rev wire${NC}\n
${YELLOW}setup ${GREEN}install ui ${BLUE}terminal tools -n${NC}\n
${YELLOW}setup ${GREEN}update all ${BLUE}--no-apt${NC}\n
"


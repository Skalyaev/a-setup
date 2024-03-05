#
#
#================================== START
case $COMMAND in
"install") ft_echo "===============Installing:" ;;
"update") ft_echo "===============Updating:" ;;
"restore") ft_echo "===============Restoring:" ;;
esac
ft_echo "${BLUE}$TARGETS${NC}" | column
ft_echo "================>"

#======== UI GROUP - GUI
if ! is_inside $EXCLUDES gui; then
    ft_echo "====Target: ${BLUE}gui${NC}..."

    if [ DO_I3 = 1 ]; then
        ft_echo "On i3..."
        do_i3
        ft_echo "i3 [$GREEN OK $NC]"
    fi
    if [ DO_PICOM = 1 ]; then
        ft_echo "On picom..."
        do_picom
        ft_echo "picom [$GREEN OK $NC]"
    fi
    if [ DO_LIGHTDM = 1 ]; then
        ft_echo "On lightdm..."
        do_lightdm
        ft_echo "lightdm [$GREEN OK $NC]"
    fi
    if [ DO_USER_DIRS = 1 ]; then
        ft_echo "On user dirs..."
        do_user_dirs
        ft_echo "user dirs [$GREEN OK $NC]"
    fi

    ft_echo "====Target: ${BLUE}gui${NC} [$GREEN OK $NC]"
fi

#======== UI GROUP - TERMINAL
if ! is_inside $EXCLUDES terminal; then
    ft_echo "====Target: ${BLUE}terminal${NC}..."

    if [ DO_BASH = 1 ]; then
        ft_echo "On bash..."
        do_bash
        ft_echo "bash [$GREEN OK $NC]"
    fi
    if [ DO_XTERM = 1 ]; then
        ft_echo "On xterm..."
        do_xterm
        ft_echo "xterm [$GREEN OK $NC]"
    fi
    if [ DO_TERMINATOR = 1 ]; then
        ft_echo "On terminator..."
        do_terminator
        ft_echo "terminator [$GREEN OK $NC]"
    fi

    ft_echo "====Target: ${BLUE}terminal${NC} [$GREEN OK $NC]"
fi

#======== UI GROUP - IDE
if ! is_inside $EXCLUDES ide; then
    ft_echo "====Target: ${BLUE}ide${NC}..."

    if [ DO_VIM = 1 ]; then
        ft_echo "On vim..."
        do_vim
        ft_echo "vim [$GREEN OK $NC]"
    fi
    if [ DO_GIT = 1 ]; then
        ft_echo "On git..."
        do_git
        ft_echo "git [$GREEN OK $NC]"
    fi

    ft_echo "====Target: ${BLUE}ide${NC} [$GREEN OK $NC]"
fi

#======== UI GROUP - TOOLS
if ! is_inside $EXCLUDES tools; then
    ft_echo "====Target: ${BLUE}tools${NC}..."

    if [ DO_MISCS_TOOLS = 1 ]; then
        ft_echo "On miscs tools..."
        do_misc_tools
        ft_echo "miscs tools [$GREEN OK $NC]"
    fi

    ft_echo "====Target: ${BLUE}tools${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - INFO_GATHERING
if ! is_inside $EXCLUDES info_gathering; then
    ft_echo "====Target: ${BLUE}info_gathering${NC}..."

    if [ DO_LIVE_HOST_IDENTIFIERS = 1 ]; then
        ft_echo "On live host identifiers..."
        do_live_host_identifiers
        ft_echo "live host identifiers [$GREEN OK $NC]"
    fi
    if [ DO_NETWORK_SCANNERS = 1 ]; then
        ft_echo "On network scanners..."
        do_network_scanners
        ft_echo "network scanners [$GREEN OK $NC]"
    fi
    if [ DO_DNS_ANALYSERS = 1 ]; then
        ft_echo "On dns analysers..."
        do_dns_analysers
        ft_echo "dns analysers [$GREEN OK $NC]"
    fi
    if [ DO_SSL_ANALYSERS = 1 ]; then
        ft_echo "On ssl analysers..."
        do_ssl_analysers
        ft_echo "ssl analysers [$GREEN OK $NC]"
    fi
    if [ DO_SMB_ANALYSERS = 1 ]; then
        ft_echo "On smb analysers..."
        do_smb_analysers
        ft_echo "smb analysers [$GREEN OK $NC]"
    fi
    if [ DO_OSINT_ANALYSERS = 1 ]; then
        ft_echo "On osint analysers..."
        do_osint_analysers
        ft_echo "osint analysers [$GREEN OK $NC]"
    fi

    ft_echo "====Target: ${BLUE}info_gathering${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - WEB_ANALYSIS
if ! is_inside $EXCLUDES web_analysis; then
    ft_echo "====Target: ${BLUE}web_analysis${NC}..."

    if [ DO_WEB_CRAWLERS = 1 ]; then
        ft_echo "On web crawlers..."
        do_web_crawlers
        ft_echo "web crawlers [$GREEN OK $NC]"
    fi
    if [ DO_WEB_PROXIES = 1 ]; then
        ft_echo "On web proxies..."
        do_web_proxies
        ft_echo "web proxies [$GREEN OK $NC]"
    fi
    if [ DO_WEB_VULN_SCANNERS = 1 ]; then
        ft_echo "On web vuln scanners..."
        do_web_vuln_scanners
        ft_echo "web vuln scanners [$GREEN OK $NC]"
    fi
    if [ DO_CMS_IDENTIFIERS = 1 ]; then
        ft_echo "On cms identifiers..."
        do_cms_identifiers
        ft_echo "cms identifiers [$GREEN OK $NC]"
    fi
    if [ DO_WORDPRESS_ANALYSERS = 1 ]; then
        ft_echo "On wordpress analysers..."
        do_wordpress_analysers
        ft_echo "wordpress analysers [$GREEN OK $NC]"
    fi

    ft_echo "====Target: ${BLUE}web_analysis${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - DB_ASSESSMENT
if ! is_inside $EXCLUDES db_assessment; then
    ft_echo "====Target: ${BLUE}db_assessment${NC}..."

    if [ DO_MISC_DB_ASSESSMENT_TOOLS = 1 ]; then
        ft_echo "On misc db assessment tools..."
        do_misc_db_assessment_tools
        ft_echo "misc db assessment tools [$GREEN OK $NC]"
    fi

    ft_echo "====Target: ${BLUE}db_assessment${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - PASSW_ATK
if ! is_inside $EXCLUDES passw_atk; then
    ft_echo "====Target: ${BLUE}passw_atk${NC}..."

    if [ DO_ONLINE_ATK_TOOLS = 1 ]; then
        ft_echo "On online atk tools..."
        do_online_atk_tools
        ft_echo "online atk tools [$GREEN OK $NC]"
    fi
    if [ DO_OFFLINE_ATK_TOOLS = 1 ]; then
        ft_echo "On offline atk tools..."
        do_offline_atk_tools
        ft_echo "offline atk tools [$GREEN OK $NC]"
    fi
    if [ DO_PROFILERS = 1 ]; then
        ft_echo "On profilers..."
        do_profilers
        ft_echo "profilers [$GREEN OK $NC]"
    fi

    ft_echo "====Target: ${BLUE}passw_atk${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - EXPLOITATION
if ! is_inside $EXCLUDES exploitation; then
    ft_echo "====Target: ${BLUE}exploitation${NC}..."

    if [ DO_MISC_EXPLOITATION_TOOLS = 1 ]; then
        ft_echo "On misc exploitation tools..."
        do_misc_exploitation_tools
        ft_echo "misc exploitation tools [$GREEN OK $NC]"
    fi

    ft_echo "====Target: ${BLUE}exploitation${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - PRIVESC
if ! is_inside $EXCLUDES privesc; then
    ft_echo "====Target: ${BLUE}privesc${NC}..."

    if [ DO_LINUX_PRIVESC_TOOLS = 1 ]; then
        ft_echo "On linux privesc tools..."
        do_linux_privesc_tools
        ft_echo "linux privesc tools [$GREEN OK $NC]"
    fi
    if [ DO_WINDOWS_PRIVESC_TOOLS = 1 ]; then
        ft_echo "On windows privesc tools..."
        do_windows_privesc_tools
        ft_echo "windows privesc tools [$GREEN OK $NC]"
    fi

    ft_echo "====Target: ${BLUE}privesc${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - SNIFF_SPOOF
if ! is_inside $EXCLUDES sniff_spoof; then
    ft_echo "====Target: ${BLUE}sniff_spoof${NC}..."

    if [ DO_MISC_SNIFFING_TOOLS = 1 ]; then
        ft_echo "On misc sniffing tools..."
        do_misc_sniffing_tools
        ft_echo "misc sniffing tools [$GREEN OK $NC]"
    fi
    if [ DO_MISC_SPOOFING_TOOLS = 1 ]; then
        ft_echo "On misc spoofing tools..."
        do_misc_spoofing_tools
        ft_echo "misc spoofing tools [$GREEN OK $NC]"
    fi

    ft_echo "====Target: ${BLUE}sniff_spoof${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - WIRELESS_ATK
if ! is_inside $EXCLUDES wireless_atk; then
    ft_echo "====Target: ${BLUE}wireless_atk${NC}..."

    if [ DO_MISC_WIRELESS_ATK_TOOLS = 1 ]; then
        ft_echo "On misc wireless atk tools..."
        do_misc_wireless_atk_tools
        ft_echo "misc wireless atk tools [$GREEN OK $NC]"
    fi

    ft_echo "====Target: ${BLUE}wireless_atk${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - VULN_ANALYSIS
if ! is_inside $EXCLUDES vuln_analysis; then
    ft_echo "====Target: ${BLUE}vuln_analysis${NC}..."

    if [ DO_STRESS_TESTERS = 1 ]; then
        ft_echo "On stress testers..."
        do_stress_testers
        ft_echo "stress testers [$GREEN OK $NC]"
    fi
    if [ DO_CISCO_TESTERS = 1 ]; then
        ft_echo "On cisco testers..."
        do_cisco_testers
        ft_echo "cisco testers [$GREEN OK $NC]"
    fi
    if [ DO_VOIP_TESTERS = 1 ]; then
        ft_echo "On voip testers..."
        do_voip_testers
        ft_echo "voip testers [$GREEN OK $NC]"
    fi

    ft_echo "====Target: ${BLUE}vuln_analysis${NC}..."
fi

#======== PENTEST GROUP - REVERSE
if ! is_inside $EXCLUDES reverse; then
    ft_echo "====Target: ${BLUE}reverse${NC}..."

    if [ DO_MISC_REVERSE_TOOLS = 1 ]; then
        ft_echo "On misc reverse tools..."
        do_misc_reverse_tools
        ft_echo "misc reverse tools [$GREEN OK $NC]"
    fi

    ft_echo "====Target: ${BLUE}reverse${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - REPORT
if ! is_inside $EXCLUDES report; then
    ft_echo "====Target: ${BLUE}report${NC}..."

    if [ DO_MISC_REPORTING_TOOLS = 1 ]; then
        ft_echo "On misc reporting tools..."
        do_misc_reporting_tools
        ft_echo "misc reporting tools [$GREEN OK $NC]"
    fi

    ft_echo "====Target: ${BLUE}report${NC} [$GREEN OK $NC]"
fi

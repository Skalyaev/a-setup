#
#
#================================== RUN
BACKUP_DIR="$ROOT/backups"

case $COMMAND in
install)
    if [ -z $NO_BACKUP ]; then
        BACKUP_DIR="$BACKUP_DIR"/$(date +%Y%m%d_%H%M%S)
        mkdir -p "$BACKUP_DIR"
        DIFF=()
    fi
    if [ -z $NO_GIT ]; then
        mkdir -p "$ROOT/resources/git"
    fi
    if [ -z $NO_CURL ]; then
        mkdir -p "$ROOT/resources/curl"
    fi
    if [ -z $NO_APT ]; then
        ft_echo "Updating apt..."
        apt update -y
    fi
    ft_echo "${GRAY}===============${NC}Installing:"
    ;;

restore)
    readarray -t BACKUPS < <(
        find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d
    )
    if [ "${#BACKUPS[@]}" -eq 0 ]; then
        ft_echo "[$RED ERROR $NC] No backup found in $BACKUP_DIR"
        exit 1
    fi
    if [ "${#BACKUPS[@]}" -gt 1 ]; then
        echo -e "[$YELLOW WARNING $NC] Multiple backups found in $BACKUP_DIR:"
        for x in "${!BACKUPS[@]}"; do
            echo -e "[$BLUE $x $NC] ${BACKUPS[$x]}"
        done
        read -p "Select a backup to restore: " input
        if [[ ! "$input" =~ ^[0-9]+$ ]] ||
            [ $input -ge "${#BACKUPS[@]}" ]; then
            ft_echo "[$RED ERROR $NC] Invalid input"
            exit 1
        fi
        BACKUP_DIR="${BACKUPS[$input]}"
    else
        BACKUP_DIR="${BACKUPS[0]}"
    fi
    ft_echo "${GRAY}===============${NC}Restoring:"
    ;;
esac

ft_echo "${BLUE}${TARGETS[@]}${NC}" | tr " " "\n"
ft_echo "${GRAY}================>${NC}"

#======== UI GROUP - GUI
if is_inside ${TARGETS[@]} gui &&
    ! is_inside ${EXCLUDES[@]} gui; then
    ft_echo "\n${GRAY}====${NC}Target: ${BLUE}gui${NC}..."

    if [ ! -z $DO_I3 ]; then
        ft_echo "on i3..."
        do_i3
        ft_echo "i3 [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_PICOM ]; then
        ft_echo "on picom..."
        do_picom
        ft_echo "picom [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_LIGHTDM ]; then
        ft_echo "on lightdm..."
        do_lightdm
        ft_echo "lightdm [$GREEN OK $NC]"
    fi

    ft_echo "${GRAY}====${NC}Target: ${BLUE}gui${NC} [$GREEN OK $NC]"
fi

#======== UI GROUP - TERMINAL
if is_inside ${TARGETS[@]} terminal &&
    ! is_inside ${EXCLUDES[@]} terminal; then
    ft_echo "\n${GRAY}====${NC}Target: ${BLUE}terminal${NC}..."

    if [ ! -z $DO_BASH ]; then
        ft_echo "on bash..."
        do_bash
        ft_echo "bash [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_XTERM ]; then
        ft_echo "on xterm..."
        do_xterm
        ft_echo "xterm [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_TERMINATOR ]; then
        ft_echo "on terminator..."
        do_terminator
        ft_echo "terminator [$GREEN OK $NC]"
    fi

    ft_echo "${GRAY}====${NC}Target: ${BLUE}terminal${NC} [$GREEN OK $NC]"
fi

#======== UI GROUP - IDE
if is_inside ${TARGETS[@]} ide &&
    ! is_inside ${EXCLUDES[@]} ide; then
    ft_echo "\n${GRAY}====${NC}Target: ${BLUE}ide${NC}..."

    if [ ! -z $DO_VIM ]; then
        ft_echo "on vim..."
        do_vim
        ft_echo "vim [$GREEN OK $NC]"
    fi

    ft_echo "${GRAY}====${NC}Target: ${BLUE}ide${NC} [$GREEN OK $NC]"
fi

#======== UI GROUP - TOOLS
if is_inside ${TARGETS[@]} tools &&
    ! is_inside ${EXCLUDES[@]} tools; then
    ft_echo "\n${GRAY}====${NC}Target: ${BLUE}tools${NC}..."

    if [ ! -z $DO_MISCS_TOOLS ]; then
        ft_echo "on miscs tools..."
        do_misc_tools
        ft_echo "miscs tools [$GREEN OK $NC]"
    fi

    ft_echo "${GRAY}====${NC}Target: ${BLUE}tools${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - INFO_GATHERING
if is_inside ${TARGETS[@]} info_gathering &&
    ! is_inside ${EXCLUDES[@]} info_gathering; then
    ft_echo "\n${GRAY}====${NC}Target: ${BLUE}info_gathering${NC}..."

    if [ ! -z $DO_LIVE_HOST_IDENTIFIERS ]; then
        ft_echo "on live host identifiers..."
        do_live_host_identifiers
        ft_echo "live host identifiers [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_NETWORK_SCANNERS ]; then
        ft_echo "on network scanners..."
        do_network_scanners
        ft_echo "network scanners [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_DNS_ANALYSERS ]; then
        ft_echo "on dns analysers..."
        do_dns_analysers
        ft_echo "dns analysers [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_SSL_ANALYSERS ]; then
        ft_echo "on ssl analysers..."
        do_ssl_analysers
        ft_echo "ssl analysers [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_SMB_ANALYSERS ]; then
        ft_echo "on smb analysers..."
        do_smb_analysers
        ft_echo "smb analysers [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_OSINT_ANALYSERS ]; then
        ft_echo "on osint analysers..."
        do_osint_analysers
        ft_echo "osint analysers [$GREEN OK $NC]"
    fi

    ft_echo "${GRAY}====${NC}Target: ${BLUE}info_gathering${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - WEB_ANALYSIS
if is_inside ${TARGETS[@]} web_analysis &&
    ! is_inside ${EXCLUDES[@]} web_analysis; then
    ft_echo "\n${GRAY}====${NC}Target: ${BLUE}web_analysis${NC}..."

    if [ ! -z $DO_WEB_CRAWLERS ]; then
        ft_echo "on web crawlers..."
        do_web_crawlers
        ft_echo "web crawlers [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_WEB_PROXIES ]; then
        ft_echo "on web proxies..."
        do_web_proxies
        ft_echo "web proxies [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_WEB_VULN_SCANNERS ]; then
        ft_echo "on web vuln scanners..."
        do_web_vuln_scanners
        ft_echo "web vuln scanners [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_CMS_IDENTIFIERS ]; then
        ft_echo "on cms identifiers..."
        do_cms_identifiers
        ft_echo "cms identifiers [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_WORDPRESS_ANALYSERS ]; then
        ft_echo "on wordpress analysers..."
        do_wordpress_analysers
        ft_echo "wordpress analysers [$GREEN OK $NC]"
    fi

    ft_echo "${GRAY}====${NC}Target: ${BLUE}web_analysis${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - DB_ASSESSMENT
if is_inside ${TARGETS[@]} db_assessment &&
    ! is_inside ${EXCLUDES[@]} db_assessment; then
    ft_echo "\n${GRAY}====${NC}Target: ${BLUE}db_assessment${NC}..."

    if [ ! -z $DO_MISC_DB_ASSESSMENT_TOOLS ]; then
        ft_echo "on misc db assessment tools..."
        do_misc_db_assessment_tools
        ft_echo "misc db assessment tools [$GREEN OK $NC]"
    fi

    ft_echo "${GRAY}====${NC}Target: ${BLUE}db_assessment${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - PASSW_ATK
if is_inside ${TARGETS[@]} passw_atk &&
    ! is_inside ${EXCLUDES[@]} passw_atk; then
    ft_echo "\n${GRAY}====${NC}Target: ${BLUE}passw_atk${NC}..."

    if [ ! -z $DO_ONLINE_ATK_TOOLS ]; then
        ft_echo "on online atk tools..."
        do_online_atk_tools
        ft_echo "online atk tools [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_OFFLINE_ATK_TOOLS ]; then
        ft_echo "on offline atk tools..."
        do_offline_atk_tools
        ft_echo "offline atk tools [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_PROFILERS ]; then
        ft_echo "on profilers..."
        do_profilers
        ft_echo "profilers [$GREEN OK $NC]"
    fi

    ft_echo "${GRAY}====${NC}Target: ${BLUE}passw_atk${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - EXPLOITATION
if is_inside ${TARGETS[@]} exploitation &&
    ! is_inside ${EXCLUDES[@]} exploitation; then
    ft_echo "\n${GRAY}====${NC}Target: ${BLUE}exploitation${NC}..."

    if [ ! -z $DO_MISC_EXPLOITATION_TOOLS ]; then
        ft_echo "on misc exploitation tools..."
        do_misc_exploitation_tools
        ft_echo "misc exploitation tools [$GREEN OK $NC]"
    fi

    ft_echo "${GRAY}====${NC}Target: ${BLUE}exploitation${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - PRIVESC
if is_inside ${TARGETS[@]} privesc &&
    ! is_inside ${EXCLUDES[@]} privesc; then
    ft_echo "\n${GRAY}====${NC}Target: ${BLUE}privesc${NC}..."

    if [ ! -z $DO_LINUX_PRIVESC_TOOLS ]; then
        ft_echo "on linux privesc tools..."
        do_linux_privesc_tools
        ft_echo "linux privesc tools [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_WINDOWS_PRIVESC_TOOLS ]; then
        ft_echo "on windows privesc tools..."
        do_windows_privesc_tools
        ft_echo "windows privesc tools [$GREEN OK $NC]"
    fi

    ft_echo "${GRAY}====${NC}Target: ${BLUE}privesc${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - SNIFF_SPOOF
if is_inside ${TARGETS[@]} sniff_spoof &&
    ! is_inside ${EXCLUDES[@]} sniff_spoof; then
    ft_echo "\n${GRAY}====${NC}Target: ${BLUE}sniff_spoof${NC}..."

    if [ ! -z $DO_MISC_SNIFFING_TOOLS ]; then
        ft_echo "on misc sniffing tools..."
        do_misc_sniffing_tools
        ft_echo "misc sniffing tools [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_MISC_SPOOFING_TOOLS ]; then
        ft_echo "on misc spoofing tools..."
        do_misc_spoofing_tools
        ft_echo "misc spoofing tools [$GREEN OK $NC]"
    fi

    ft_echo "${GRAY}====${NC}Target: ${BLUE}sniff_spoof${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - WIRELESS_ATK
if is_inside ${TARGETS[@]} wireless_atk &&
    ! is_inside ${EXCLUDES[@]} wireless_atk; then
    ft_echo "\n${GRAY}====${NC}Target: ${BLUE}wireless_atk${NC}..."

    if [ ! -z $DO_MISC_WIRELESS_ATK_TOOLS ]; then
        ft_echo "on misc wireless atk tools..."
        do_misc_wireless_atk_tools
        ft_echo "misc wireless atk tools [$GREEN OK $NC]"
    fi

    ft_echo "${GRAY}====${NC}Target: ${BLUE}wireless_atk${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - VULN_ANALYSIS
if is_inside ${TARGETS[@]} vuln_analysis &&
    ! is_inside ${EXCLUDES[@]} vuln_analysis; then
    ft_echo "\n${GRAY}====${NC}Target: ${BLUE}vuln_analysis${NC}..."

    if [ ! -z $DO_STRESS_TESTERS ]; then
        ft_echo "on stress testers..."
        do_stress_testers
        ft_echo "stress testers [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_CISCO_TESTERS ]; then
        ft_echo "on cisco testers..."
        do_cisco_testers
        ft_echo "cisco testers [$GREEN OK $NC]"
    fi
    if [ ! -z $DO_VOIP_TESTERS ]; then
        ft_echo "on voip testers..."
        do_voip_testers
        ft_echo "voip testers [$GREEN OK $NC]"
    fi

    ft_echo "${GRAY}====${NC}Target: ${BLUE}vuln_analysis${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - REVERSE
if is_inside ${TARGETS[@]} reverse &&
    ! is_inside ${EXCLUDES[@]} reverse; then
    ft_echo "\n${GRAY}====${NC}Target: ${BLUE}reverse${NC}..."

    if [ ! -z $DO_MISC_REVERSE_TOOLS ]; then
        ft_echo "on misc reverse tools..."
        do_misc_reverse_tools
        ft_echo "misc reverse tools [$GREEN OK $NC]"
    fi

    ft_echo "${GRAY}====${NC}Target: ${BLUE}reverse${NC} [$GREEN OK $NC]"
fi

#======== PENTEST GROUP - REPORT
if is_inside ${TARGETS[@]} report &&
    ! is_inside ${EXCLUDES[@]} report; then
    ft_echo "\n${GRAY}====${NC}Target: ${BLUE}report${NC}..."

    if [ ! -z $DO_MISC_REPORTING_TOOLS ]; then
        ft_echo "on misc reporting tools..."
        do_misc_reporting_tools
        ft_echo "misc reporting tools [$GREEN OK $NC]"
    fi

    ft_echo "${GRAY}====${NC}Target: ${BLUE}report${NC} [$GREEN OK $NC]"
fi

#======== DONE
if [ $COMMAND = install && -z $NO_BACKUP ]; then
    if [ ${#DIFF[@]} -gt 0 ]; then
        echo ${DIFF[@]} | tr " " "\n" >"$BACKUP_DIR/diff.txt"
    else
        rm -rf "$BACKUP_DIR"
    fi
fi

chown -R "$USER":"$USER" "$ROOT"
ft_echo "${GRAY}================[$GREEN DONE $NC]"

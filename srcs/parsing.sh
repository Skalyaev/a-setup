#
#
#================================== PARSING

#======================== ARGUMENTS
if [ $# -lt 2 ]; then
    echo -e $USAGE
    exit 1
fi

COMMAND="$1"
if [ "$COMMAND" != install \
    -a "$COMMAND" != restore ]; then
    echo -e "[$RED ERROR $NC] Unknown command:$GREEN $1${NC}"
    exit 1
fi

GROUP="$2"
if [ "$GROUP" != all \
    -a "$GROUP" != ui \
    -a "$GROUP" != pentest ]; then
    echo -e "[$RED ERROR $NC] Unknown group:$GREEN $2${NC}"
    exit 1
fi

shift 2

TARGETS=()
EXCLUDES=()

find_it() {
    local found=1
    if [ $GROUP = all -o $GROUP = ui ]; then
        is_inside ${UI_GROUP[@]} "$1"
        found=$?
    fi
    if [ $found -eq 1 ] && [ $GROUP = all -o $GROUP = pentest ]; then
        is_inside ${PENTEST_GROUP[@]} "$1"
        found=$?
    fi
    return $found
}

while [ $# -gt 0 ]; do
    if [ "${1:0:1}" = - ]; then
        break
    fi
    if ! find_it "$1"; then
        echo -e "[$RED ERROR $NC] ${BLUE}$1${NC} not found in group ${GREEN}$GROUP${NC}."
        exit 1
    fi
    TARGETS+=("$1")
    shift
done
if [ ${#TARGETS[@]} -eq 0 ]; then
    if [ $GROUP = all -o $GROUP = ui ]; then
        TARGETS+=(${UI_GROUP[@]})
    fi
    if [ $GROUP = all -o $GROUP = pentest ]; then
        TARGETS+=(${PENTEST_GROUP[@]})
    fi
fi

while [ $# -gt 0 ]; do
    case "$1" in
    -c | --config)
        if [ $# -lt 2 ]; then
            echo -e "[$RED ERROR $NC] Missing argument for ${BLUE}--config${NC}."
            exit 1
        fi
        CONFIG_FILE="$2"
        shift 2
        ;;
    -e | --exclude)
        shift
        while [ $# -gt 0 ]; do
            if [ "${1:0:1}" = - ]; then
                break
            fi
            if ! find_it "$1"; then
                echo -e "[$RED ERROR $NC] ${BLUE}$1${NC} not found in group ${GREEN}$GROUP${NC}."
                exit 1
            fi
            EXCLUDES+=("$1")
            shift
        done
        if [ ${#EXCLUDES[@]} -eq 0 ]; then
            echo -e "[$RED ERROR $NC] Missing argument for ${BLUE}--exclude${NC}."
            exit 1
        fi
        ;;
    -s | --silent)
        SILENT=1
        shift
        ;;
    -n | --ninja)
        NO_APT=1
        NO_GIT=1
        NO_CURL=1
        shift
        ;;
    --no-apt)
        NO_APT=1
        shift
        ;;
    --no-git)
        NO_GIT=1
        shift
        ;;
    --no-curl)
        NO_CURL=1
        shift
        ;;
    --no-backup)
        NO_BACKUP=1
        shift
        ;;
    *)
        echo -e "[$RED ERROR $NC] Unknown option:$BLUE $1${NC}"
        exit 1
        ;;
    esac
done

#======================== CONFIG
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "[$RED ERROR $NC] Config file not found: $CONFIG_FILE"
    if [ ! -z $IS_ROOT ]; then
        echo "If you used sudo, you might want to use -c option to specify your config file."
    fi
    exit 1
fi

in_block=0
while IFS= read -r line; do
    if [ "${line:0:10}" = '#======== ' ]; then
        in_block=0
        for target in ${TARGETS[@]}; do
            if echo "$line" | grep -iq $target; then
                in_block=1
                break
            fi
        done
    elif [ $in_block -eq 1 ]; then
        if [ -z "$line" -o "${line:0:1}" = '#' ]; then
            continue
        fi
        case "$line" in
        'USER='*) USER=$(echo "$line" | cut -d= -f2) ;;
        'HOME='*) HOME=$(echo "$line" | cut -d= -f2) ;;
        'DO_I3=1') DO_I3=1 ;;
        'DO_PICOM=1') DO_PICOM=1 ;;
        'DO_LIGHTDM=1') DO_LIGHTDM=1 ;;
        'DO_BASH=1') DO_BASH=1 ;;
        'DO_XTERM=1') DO_XTERM=1 ;;
        'DO_TERMINATOR=1') DO_TERMINATOR=1 ;;
        'DO_VIM=1') DO_VIM=1 ;;
        'DO_MISCS_TOOLS=1') DO_MISCS_TOOLS=1 ;;
        'DO_LIVE_HOST_IDENTIFIERS=1') DO_LIVE_HOST_IDENTIFIERS=1 ;;
        'DO_NETWORK_SCANNERS=1') DO_NETWORK_SCANNERS=1 ;;
        'DO_DNS_ANALYSERS=1') DO_DNS_ANALYSERS=1 ;;
        'DO_SSL_ANALYSERS=1') DO_SSL_ANALYSERS=1 ;;
        'DO_SMB_ANALYSERS=1') DO_SMB_ANALYSERS=1 ;;
        'DO_OSINT_ANALYSERS=1') DO_OSINT_ANALYSERS=1 ;;
        'DO_WEB_CRAWLERS=1') DO_WEB_CRAWLERS=1 ;;
        'DO_WEB_PROXIES=1') DO_WEB_PROXIES=1 ;;
        'DO_WEB_VULN_SCANNERS=1') DO_WEB_VULN_SCANNERS=1 ;;
        'DO_CMS_IDENTIFIERS=1') DO_CMS_IDENTIFIERS=1 ;;
        'DO_WORDPRESS_ANALYSERS=1') DO_WORDPRESS_ANALYSERS=1 ;;
        'DO_MISC_DB_ASSESSMENT_TOOLS=1') DO_MISC_DB_ASSESSMENT_TOOLS=1 ;;
        'DO_ONLINE_ATK_TOOLS=1') DO_ONLINE_ATK_TOOLS=1 ;;
        'DO_OFFLINE_ATK_TOOLS=1') DO_OFFLINE_ATK_TOOLS=1 ;;
        'DO_PROFILERS=1') DO_PROFILERS=1 ;;
        'DO_MISC_EXPLOITATION_TOOLS=1') DO_MISC_EXPLOITATION_TOOLS=1 ;;
        'DO_LINUX_PRIVESC_TOOLS=1') DO_LINUX_PRIVESC_TOOLS=1 ;;
        'DO_WINDOWS_PRIVESC_TOOLS=1') DO_WINDOWS_PRIVESC_TOOLS=1 ;;
        'DO_MISC_SNIFFING_TOOLS=1') DO_MISC_SNIFFING_TOOLS=1 ;;
        'DO_MISC_SPOOFING_TOOLS=1') DO_MISC_SPOOFING_TOOLS=1 ;;
        'DO_MISC_WIRELESS_ATK_TOOLS=1') DO_MISC_WIRELESS_ATK_TOOLS=1 ;;
        'DO_BLUETHOOTH_ATK_TOOLS=1') DO_BLUETHOOTH_ATK_TOOLS=1 ;;
        'DO_STRESS_TESTERS=1') DO_STRESS_TESTERS=1 ;;
        'DO_CISCO_TESTERS=1') DO_CISCO_TESTERS=1 ;;
        'DO_VOIP_TESTERS=1') DO_VOIP_TESTERS=1 ;;
        'DO_MISC_REVERSE_TOOLS=1') DO_MISC_REVERSE_TOOLS=1 ;;
        'DO_MISC_REPORTING_TOOLS=1') DO_MISC_REPORTING_TOOLS=1 ;;
        *)
            echo -e "[$RED ERROR $NC] Unknown config input: $line"
            exit 1
            ;;
        esac
    fi
done <"$CONFIG_FILE"

if [ -z "$USER" -o -z "$HOME" ]; then
    echo -e "[$RED ERROR $NC] user and/or home not found in config file."
    exit 1
fi

if [ ! $(stat -c %U "$HOME") = "$USER" ]; then
    echo -e "[$RED ERROR $NC] $HOME is not owned by $USER."
    exit 1
fi

ROOT=$(dirname "$CONFIG_FILE")

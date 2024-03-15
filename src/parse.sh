#
#
#================================== PARSE
if [ "$#" -lt 1 ]; then
    echo -e "$USAGE"
    exit 1
fi

COMMAND="$1"
if [ "$COMMAND" != 'install' -a "$COMMAND" != 'restore' ]; then
    echo -e "[$RED ERROR $NC] Unknown command: ${GREEN}$1${NC}"
    exit 1
fi
shift

while [ "$#" -gt 0 ]; do
    case "$1" in
    '-u' | '--user')
        shift
        if [ "$#" -eq 0 ]; then
            echo -e "[$RED ERROR $NC] Missing argument for ${GREEN}--user${NC}."
            exit 1
        fi
        USER="$1"
        shift
        if ! getent passwd "$USER" &>/dev/null; then
            echo -e "[$RED ERROR $NC] Can not set home for $USER."
            exit 1
        fi
        HOME="$(getent passwd "$USER" | cut -d: -f6)"
        if [ ! -e "$HOME" ]; then
            echo -e "[$RED ERROR $NC] Can not set home for $USER."
            exit 1
        fi
        ;;
    '-p' | '--path')
        shift
        if [ "$#" -eq 0 ]; then
            echo -e "[$RED ERROR $NC] Missing argument for ${GREEN}--path${NC}."
            exit 1
        fi
        ROOT="$1"
        shift
        if [ -e "$ROOT" ]; then
            ROOT="$(realpath "$ROOT")"
        else
            echo -e "[$RED ERROR $NC] Path not found: $ROOT"
            exit 1
        fi
        ;;
    '-e' | '--exclude')
        shift
        EXCLUDES=()
        while [ "$#" -gt 0 ]; do
            if [ "${1:0:1}" = '-' ]; then
                break
            fi
            EXCLUDES+=(! -path "*/$1/*")
            shift
        done
        if [ "${#EXCLUDES[@]}" -eq 0 ]; then
            echo -e "[$RED ERROR $NC] Missing argument for ${GREEN}--exclude${NC}."
            exit 1
        fi
        ;;
    '-s' | '--silent')
        SILENT=1
        shift
        ;;
    '-n' | '--ninja')
        NO_APT=1
        NO_WEB=1
        shift
        ;;
    '--no-apt')
        NO_APT=1
        shift
        ;;
    '--no-web')
        NO_WEB=1
        shift
        ;;
    '--no-local')
        NO_SWAP=1
        shift
        ;;
    '--no-backup')
        NO_BACKUP=1
        shift
        ;;
    *)
        echo -e "[$RED ERROR $NC] Unknown option: ${GREEN}$1${NC}"
        exit 1
        ;;
    esac
done

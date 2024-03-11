#
#
#================================== PARSING
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
    '-p' | '--path')
        shift
        if [ "$#" -eq 0 ]; then
            echo -e "[$RED ERROR $NC] Missing argument for ${GREEN}--path${NC}."
            exit 1
        fi
        if [ -d "$1" ]; then
            ROOT="$1"
        else
            echo -e "[$RED ERROR $NC] path not found: ${GREEN}$1${NC}"
            exit 1
        fi
        ;;
    '-t' | '--target')
        shift
        TARGETS=()
        while [ "$#" -gt 0 ]; do
            if [ "${1:0:1}" = - ]; then
                break
            fi
            TARGETS+=("$1")
            shift
        done
        if [ "${#TARGETS[@]}" -eq 0 ]; then
            echo -e "[$RED ERROR $NC] Missing argument for ${GREEN}--target${NC}."
            exit 1
        fi
        ;;
    '-e' | '--exclude')
        shift
        EXCLUDES=()
        while [ "$#" -gt 0 ]; do
            if [ "${1:0:1}" = - ]; then
                break
            fi
            EXCLUDES+=("$1")
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
        NO_GIT=1
        NO_CURL=1
        shift
        ;;
    '--no-apt')
        NO_APT=1
        shift
        ;;
    '--no-git')
        NO_GIT=1
        shift
        ;;
    '--no-curl')
        NO_CURL=1
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

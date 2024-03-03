#================================== PARSING - ARGUMENTS
if [ $# -lt 2 ]; then
    echo -e $USAGE
    exit 1
fi

COMMAND="$1"
if [ "$COMMAND" != install \
    -a "$COMMAND" != update \
    -a "$COMMAND" != remove ]; then
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

while [ $# -gt 0 ]; do
    case "$1" in
    -c | --config)
        if [ $# -lt 2 ]; then
            echo -e [$RED ERROR $NC] Missing argument for ${BLUE}--config${NC}.
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
            EXCLUDED+=("$1")
            shift
        done
        if [ ${#EXCLUDED[@]} -eq 0 ]; then
            echo -e [$RED ERROR $NC] Missing argument for ${BLUE}--exclude${NC}.
            exit 1
        fi
        ;;
    -s | --silent)
        SILENT=1
        shift
        ;;
    -n | --ninja)
        DO_APT=0
        DO_GIT=0
        DO_CURL=0
        shift
        ;;
    --no-apt)
        DO_APT=0
        shift
        ;;
    --no-git)
        DO_GIT=0
        shift
        ;;
    --no-curl)
        DO_CURL=0
        shift
        ;;
    *)
        echo -e "[$RED ERROR $NC] Unknown option:$BLUE $1${NC}"
        exit 1
        ;;
    esac
done

#================================== PARSING - CONFIG
CONFIG_FILE=$CONFIG_FILE


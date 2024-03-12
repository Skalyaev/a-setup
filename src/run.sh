#
#
#================================== RUN
case "$COMMAND" in
'install')
    if [ -z "$ROOT" ]; then
        ROOT='~/.local/share/setup/resource'
    fi
    if [ -z "$NO_BACKUP" ]; then
        DIFF=()
        BACKUP="$(dirname $ROOT)/backup/$(date +%Y%m%d%H%M%S)"
        mkdir -p "$BACKUP"
    fi
    ft_apt
    ft_web
    ft_swap
    if [ -z "$NO_BACKUP" ]; then
        if [ ${#DIFF[@]} -gt 0 ]; then
            echo "${DIFF[@]}" >"$BACKUP/diff"
        else
            rm -r "$BACKUP"
        fi
    fi
    ;;
'restore')
    if [ -z "$ROOT" ]; then
        ROOT=$(ls -t '~/.local/share/setup/backup' |
            head -n 1)
    fi
    ft_restore
    ;;
esac

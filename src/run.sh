#
#
#================================== RUN
if [ "$EUID" -eq 0 -a "$USER" != 'root' ]; then
    is_sudo='(sudo) '
fi
ft_echo "${GRAY}================ Running as $is_sudo$USER$NC\n"
case "$COMMAND" in
'install')
    if [ -z "$ROOT" ]; then
        ROOT="$HOME/.local/share/setup/resource"
        if [ ! -e "$ROOT" ]; then
            ft_echo "[$RED ERROR $NC] $ROOT not found.\n"
            ft_echo "If run as sudo, please use -u to specify target user.\n"
            ft_echo "Aborting.\n"
            exit 1
        fi
    fi
    if [ -z "$NO_BACKUP" ]; then
        DIFF=()
        BACKUP="$(dirname "$ROOT")/backup/$(date +%Y%m%d%H%M%S)"
        if [ ! -e "$(dirname "$ROOT")/backup" ]; then
            if ! mkdir "$(dirname "$ROOT")/backup" >/dev/null 2>&1; then
                ft_echo "[$RED ERROR $NC] Cannot create backup directory: $BACKUP\n"
                ft_echo "Aborting.\n"
                exit 1
            else
                chown "$USER:$USER" "$(dirname "$ROOT")/backup" \
                    >/dev/null 2>&1
            fi
        fi
        if ! mkdir "$BACKUP" >/dev/null 2>&1; then
            ft_echo "[$RED ERROR $NC] Cannot create backup directory: $BACKUP\n"
            ft_echo "Aborting.\n"
            exit 1
        fi
        chown "$USER:$USER" "$BACKUP" >/dev/null 2>&1
    fi
    ft_apt
    ft_web
    ft_swap
    if [ -z "$NO_BACKUP" ]; then
        if [ "${#DIFF[@]}" -gt 0 ]; then
            for x in "${DIFF[@]}"; do
                echo "$x" >>"$BACKUP/diff"
            done
            chown "$USER:$USER" "$BACKUP/diff" >/dev/null 2>&1
        else
            rm -r "$BACKUP"
        fi
    fi
    ;;
'restore')
    if [ -z "$ROOT" ]; then
        ROOT="$(ls -t "$HOME/.local/share/setup/backup" |
            head -n 1)"
    fi
    if [ ! -e "$ROOT/diff" ]; then
        ft_echo "[$RED ERROR $NC] No diff file found.\n"
        ft_echo "Aborting restore.\n"
        exit 1
    fi
    ft_restore
    ;;
esac

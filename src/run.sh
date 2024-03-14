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
        mkdir -p "$BACKUP"
        chown -R "$USER:$USER" "$(dirname "$ROOT")/backup" \
            >/dev/null 2>&1
    fi
    cd "$ROOT"
    ft_apt
    cd "$ROOT"
    ft_web
    cd "$ROOT"
    ft_swap
    if [ -z "$NO_BACKUP" ]; then
        if [ "${#DIFF[@]}" -gt 0 ]; then
            for x in "${DIFF[@]}"; do
                echo "$x" >>"$BACKUP/diff" 
            done
            chown -R "$USER:$USER" "$BACKUP" >/dev/null 2>&1
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
    ft_restore
    ;;
esac

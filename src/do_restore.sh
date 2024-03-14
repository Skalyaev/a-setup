#
#
#================================== DO_RESTORE
ft_restore() {
    if [ ! -e "$ROOT/diff" ]; then
        ft_echo "[$RED ERROR $NC] No diff file found.\n"
        ft_echo "Aborting restore.\n"
        exit 1
    fi
    ft_echo "${GRAY}================ READING: diff$NC\n"
    while read line; do
        if [ -z "$line" -o ! -z "$skip_it" ]; then
            continue
        fi
        if [ ! -z "$run_it" ]; then
            if [ -z "$dst" ]; then
                ft_echo "[$RED KO $NC]\n"
                ft_echo "[$RED ERROR $NC] Diff file corrupted.\n"
                ft_echo "Aborting restore.\n"
                exit 1
            fi
            if [ "$line" = '$---' ]; then
                unset run_it skip_it dst
                ft_echo "[$GREEN OK $NC]\n"
                continue
            fi
            if ! eval "$line" >/dev/null 2>&1; then
                unset to_run
                local to_skip=1
                ft_echo "[$RED KO $NC]\n"
                ft_echo "[$YELLOW WARNING $NC] Non-zero returned from: $line\n"
                ft_echo "$dst not removed.\n"
            fi
        fi

        local cmd=$(echo "$line" | cut -d: -f1)
        local target=$(echo "$line" | cut -d: -f2)
        case "$cmd" in
        'apt')
            ft_echo "Removing $target..."
            if ! apt remove -y "$target"; then
                ft_echo "[$RED KO $NC]\n"
                ft_echo "[$YELLOW WARNING $NC] Non-zero returned from apt.\n"
                ft_echo "You may need to run this command with sudo.\n"
                ft_echo "$target not removed.\n"
            else
                ft_echo "[$GREEN OK $NC]\n"
            fi
            ;;
        'web')
            ft_echo "Removing $target..."
            local dst="$target"
            local run_it=1
            ;;
        'add')
            ft_echo "Removing $target..."
            if ! rm -rf "$target"; then
                ft_echo "[$RED KO $NC]\n"
                ft_echo "[$YELLOW WARNING $NC] Can not remove $target.\n"
                ft_echo "$target not removed.\n"
            else
                ft_echo "[$GREEN OK $NC]\n"
            fi
            ;;
        'swap')
            ft_echo "Restoring $target..."
            local dir=$(dirname "$target")
            local target=$(basename "$target")
            if ! cp -r "$ROOT/$target" "$dir/$target" >/dev/null 2>&1; then
                ft_echo "[$RED KO $NC]\n"
                ft_echo "[$YELLOW WARNING $NC] Can not copy \
                    $ROOT/$target to $dir/$target.\n"
                ft_echo "$dir/$target not restored.\n"
            else
                ft_echo "[$GREEN OK $NC]\n"
                chown -R "$USER:$USER" "$dir/$target" >/dev/null 2>&1
            fi
            ;;
        esac
    done <"$ROOT/diff"
}

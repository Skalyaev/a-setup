#
#
#================================== DO_SWAP
ft_swap() {
    if [ ! -z "$NO_SWAP" ]; then
        return
    fi
    ft_echo "${GRAY}================ READING: .swap$NC\n"
    local files="$(find "$ROOT" "${EXCLUDES[@]}" -type f -name '.swap')"
    for file in $files; do
        local dir="$(dirname "$file")"
        while read -r line; do
            if [ -z "$line" ]; then
                continue
            fi
            target="$(echo "$line" | cut -d'@' -f1 | xargs)"
            src="$dir/$target"
            target="$(basename "$target")"
            dst="$(echo "$line" | cut -d'@' -f2 | xargs | sed "s:~:$HOME:g")"

            if [ -e "$dst/$target" ]; then
                if ! diff -q "$src" "$dst/$target" &>/dev/null; then
                    ft_echo "$dst/$target [$GREEN OK $NC]\n"
                    continue
                fi
                if [ -z "$NO_BACKUP" ]; then
                    local action='swap'
                fi
            elif [ -z "$NO_BACKUP" ]; then
                local action='add'
            fi
            ft_echo "Setting $dst/$target..."
            if [ ! -e "$dst" ]; then
                if ! mkdir "$dst"; then
                    ft_echo "[$RED KO $NC]\n"
                    ft_echo "[$YELLOW WARNING $NC] Can not create $dst\n"
                    ft_echo "$dst/$target not set.\n"
                    continue
                fi
                DIFF=("${DIFF[@]}" "add:$dst")
                chown "$USER:$USER" "$dst"
            elif [ -e "$dst/$target" -a -z "$NO_BACKUP" ]; then
                if ! mv "$dst/$target" "$BACKUP/$target"; then
                    ft_echo "[$RED KO $NC]\n"
                    ft_echo "[$YELLOW WARNING $NC] Can not backup $dst/$target\n"
                    ft_echo "$dst/$target not set\n"
                    continue
                fi
            fi
            if ! cp -r "$src" "$dst"; then
                ft_echo "[$RED KO $NC]\n"
                ft_echo "[$YELLOW WARNING $NC] Can not set $dst/$target from $src\n"
                if [ -z "$NO_BACKUP" -a "$action" = 'swap' ]; then
                    ft_echo "$dst can/must be restored from $BACKUP"
                    DIFF=("${DIFF[@]}" "$action:$dst/$target")
                fi
                continue
            else
                DIFF=("${DIFF[@]}" "$action:$dst/$target")
                chown -R "$USER:$USER" "$dst/$target"
            fi
            ft_echo "[$GREEN OK $NC]\n"
        done <"$file"
    done
}

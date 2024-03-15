#
#
#================================== DO_SWAP
ft_swap() {
    if [ ! -z "$NO_SWAP" ]; then
        return
    fi
    ft_echo "${GRAY}================ READING: .swap$NC\n"
    local files="$(find "$ROOT" "${EXCLUDES[@]}" \
        -type f -name '.swap')"
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

            ft_echo "Setting $dst/$target..."
            if [ -z "$NO_BACKUP" ]; then
                if [ -e "$dst/$target" ]; then
                    local action='swap'
                else
                    local action='add'
                fi
            fi
            if [ ! -e "$dst" ]; then
                if ! mkdir -p "$dst" >/dev/null 2>&1; then
                    ft_echo "[$RED KO $NC]\n"
                    ft_echo "[$YELLOW WARNING $NC] Can not create $dst\n"
                    ft_echo "$dst/$target not set.\n"
                    continue
                else
                    DIFF=("${DIFF[@]}" "add:$dst")
                    chown "$USER:$USER" "$dst" >/dev/null 2>&1
                fi
            elif [ -e "$dst/$target" -a -z "$NO_BACKUP" ]; then
                if ! cp -r "$dst/$target" "$BACKUP" >/dev/null 2>&1; then
                    ft_echo "[$RED KO $NC]\n"
                    ft_echo "[$YELLOW WARNING $NC] Can not backup $dst/$target\n"
                    ft_echo "$dst/$target not set\n"
                    continue
                fi
            fi
            if ! cp -r "$src" "$dst" >/dev/null 2>&1; then
                ft_echo "[$RED KO $NC]\n"
                ft_echo "[$YELLOW WARNING $NC] Can not set $dst/$target from $src\n"
                continue
            else
                chown -R "$USER:$USER" "$dst/$target" >/dev/null 2>&1
            fi
            if [ -z "$NO_BACKUP" ]; then
                DIFF=("${DIFF[@]}" "$action:$dst/$target")
            fi
            ft_echo "[$GREEN OK $NC]\n"
        done <"$file"
    done
}

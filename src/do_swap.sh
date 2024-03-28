#
#
#================================== DO_SWAP
ft_swap() {
    if [ ! -z "$NO_SWAP" ]; then
        return
    fi
    ft_echo "${GRAY}================ READING: .swap$NC\n"
    local files=$(find . "${EXCLUDES[@]}" -type f -name '.swap')
    for file in $files; do
        local dir=$(dirname "$file")
        if [ ! -z "$nolink" ]; then
            unset nolink
        fi
        while read -r line; do
            if [ ! -z "$nolink" ]; then
                unset nolink
            fi
            if [ -z "$line" ]; then
                continue
            fi
            local target=$(echo "$line" | cut -d'@' -f1 | xargs)
            if [ "${target:0:8}" = 'no-link ' ]; then
                local nolink=1
                target="${target:8}"
            fi
            local src="$dir/$target"
            local target=$(basename "$target")
            local dst=$(echo "$line" | cut -d'@' -f2 | xargs | sed "s:~:$HOME:g")

            if [ -e "$dst/$target" ]; then
                if diff "$src" "$dst/$target" &>'/dev/null'; then
                    ft_echo "$dst/$target [$GREEN OK $NC]\n"
                    continue
                fi
                local action='swap'
            else
                local action='add'
            fi
            ft_echo "${BLUE}Setting${NC} $dst/$target..."
            if [ ! -e "$dst" ]; then
                if ! mkdir "$dst"; then
                    ft_echo "[$RED KO $NC]\n"
                    ft_echo "[$YELLOW WARNING $NC] Can not create $dst\n"
                    ft_echo "$dst/$target not set.\n"
                    continue
                fi
                DIFF=("${DIFF[@]}" "add:$dst")
                chown "$USER:$USER" "$dst"
            elif [ -e "$dst/$target" ]; then
                if ! mv "$dst/$target" "$BACKUP/$target"; then
                    ft_echo "[$RED KO $NC]\n"
                    ft_echo "[$YELLOW WARNING $NC] Can not backup $dst/$target\n"
                    ft_echo "$dst/$target not set\n"
                    continue
                fi
            fi
            if [ -z "$nolink" ]; then
                ln -s $(realpath "$src") "$(realpath "$dst/$target")" &>'/dev/null'
            else
                cp -r "$src" "$dst" &>'/dev/null'
            fi
            if [ ! -e "$dst/$target" ]; then
                ft_echo "[$RED KO $NC]\n"
                ft_echo "[$YELLOW WARNING $NC] Can not set $dst/$target from $src\n"
                if [ "$action" = 'swap' ]; then
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

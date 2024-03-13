#
#
#================================== DO_SWAP
ft_swap() {
    if [ ! -z "$NO_SWAP" ]; then
        return
    fi
    ft_echo "${GRAY}================ READING: .swap$NC\n"
    local files=$(find "$ROOT" "${EXCLUDES[@]}" \
        -type f -name '.swap')
    for file in $files; do
        local dir=$(dirname "$file")

        while read -r line; do
            if [ -z "$line" ]; then
                continue
            fi
            src=$(echo "$line" | cut -d'@' -f1 | xargs)
            src="$dir/$src"
            dst=$(echo "$line" | cut -d'@' -f2 | xargs)
            dst=$(echo "$dst" | sed "s:~:$HOME:g")

            ft_echo "$dst..."
            if [ -e "$dst" -a -z "$NO_BACKUP" ]; then
                if ! cp -r "$dst" "$BACKUP/." >/dev/null 2>&1; then
                    ft_echo "[$RED KO $NC]\n"
                    ft_echo "[$YELLOW WARNING $NC] Can not backup $dst\n"
                    ft_echo "$dst not swapped.\n"
                    continue
                fi
            fi
            if [ ! -e "$(dirname "$dst")" ]; then
                if ! mkdir -p "$(dirname "$dst")" >/dev/null 2>&1; then
                    ft_echo "[$RED KO $NC]\n"
                    ft_echo "[$YELLOW WARNING $NC] Can not create $(dirname "$dst")\n"
                    ft_echo "$dst not swapped.\n"
                    continue
                else
                    chown "$USER:$USER" "$(dirname "$dst")" >/dev/null 2>&1
                fi
            fi
            if ! cp -r "$src" "$dst" >/dev/null 2>&1; then
                ft_echo "[$RED KO $NC]\n"
                ft_echo "[$YELLOW WARNING $NC] Can not swap $dst\n"
                continue
            else
                chown -R "$USER:$USER" "$dst" >/dev/null 2>&1
            fi
            DIFF=("${DIFF[@]}" "swap:$dst")
            ft_echo "[$GREEN OK $NC]\n"
        done < "$file"
    done
}

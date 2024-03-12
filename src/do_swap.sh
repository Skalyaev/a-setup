#
#
#================================== DO_SWAP
ft_swap() {
    local files=$(find $ROOT "${EXCLUDES[@]}" \
        -type f -name '.swap')
    for file in $files; do
        local dir=$(dirname "$file")

        echo "$file" | while read -r line; do
            if [ -z "$line" ]; then
                continue
            fi
            src=$(echo "$line" | cut -d'@' -f1 | xargs)
            src="$dir/$src"
            dst=$(echo "$line" | cut -d'@' -f2 | xargs)

            ft_echo "Replacing $dst..."
            if [ -e "$dst" ]; then
                if ! cp -r "$dst" "$BACKUP/."; then
                    ft_echo "[$RED KO $NC]\n"
                    ft_echo "[$YELLOW WARNING $NC] Can not backup $dst.\n"
                    ft_echo "$dst not swapped.\n"
                    continue
                fi
            fi
            if ! cp -r "$src" "$dst"; then
                ft_echo "[$RED KO $NC]\n"
                ft_echo "[$YELLOW WARNING $NC] Can not swap $dst.\n"
                continue
            fi
            DIFF=("${DIFF[@]}" "swap:$dst")
            ft_echo "[$GREEN OK $NC]\n"
        done
    done
}

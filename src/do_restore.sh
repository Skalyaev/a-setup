#
#
#================================== DO_RESTORE
ft_restore() {
    ft_echo "${GRAY}================ READING: diff$NC\n"
    while read line; do
        if [ -z "$line" ]; then
            continue
        fi
        if [ ! -z "$run_it" -o ! -z "$skip_it" ]; then
            if [ "$line" = '$---' ]; then
                unset run_it skip_it
                ft_echo "[$GREEN OK $NC]\n"
                cd "$ROOT"
                continue
            fi
            if [ ! -z "$skip_it" ]; then
                continue
            fi
            if ! eval "$line" &>/dev/null; then
                unset to_run
                local to_skip=1
                ft_echo "[$RED KO $NC]\n"
                ft_echo "[$YELLOW WARNING $NC] Non-zero returned from: $line\n"
                ft_echo "$target not removed.\n"
            fi
            continue
        fi
        local cmd=$(echo "$line" | cut -d: -f1)
        local target=$(echo "$line" | cut -d: -f2)
        case "$cmd" in
            'apt')
                if [ -z "$apt_clean" ]; then
                    local apt_clean=1
                fi
                ft_echo "${BLUE}Removing${NC} $target..."
                if ! apt purge -y "$target" &>/dev/null; then
                    ft_echo "[$RED KO $NC]\n"
                    ft_echo "[$YELLOW WARNING $NC] Non-zero returned from apt.\n"
                    ft_echo "You may need to run this command with sudo.\n"
                    ft_echo "$target not removed.\n"
                else
                    ft_echo "[$GREEN OK $NC]\n"
                fi
                ;;
            'web')
                ft_echo "${BLUE}Removing${NC} $target..."
                cd "$target"
                local run_it=1
                ;;
            'add')
                ft_echo "${BLUE}Removing${NC} $target..."
                if [ ! -e "$target" ]; then
                    ft_echo "[$GREEN OK $NC]\n"
                    continue
                fi
                if ! rm -rf "$target"; then
                    ft_echo "[$RED KO $NC]\n"
                    ft_echo "[$YELLOW WARNING $NC] Can not remove $target.\n"
                    ft_echo "$target not removed.\n"
                else
                    ft_echo "[$GREEN OK $NC]\n"
                fi
                ;;
            'swap')
                ft_echo "${BLUE}Restoring${NC} $target..."
                local name=$(basename "$target")
                if ! mv "$ROOT/$name" "$target"; then
                    ft_echo "[$RED KO $NC]\n"
                    ft_echo "[$YELLOW WARNING $NC] Can not move $ROOT/$name to $target.\n"
                    ft_echo "$target not restored.\n"
                else
                    ft_echo "[$GREEN OK $NC]\n"
                fi
                ;;
        esac
    done <"$ROOT/diff"
    rm -r "$ROOT"
    if [ ! -z "$apt_clean" ]; then
        ft_echo "${BLUE}Cleaning${NC} apt..."
        apt autoremove -y &>/dev/null
        apt autoclean -y &>/dev/null
        ft_echo "[$GREEN OK $NC]\n"
    fi
}

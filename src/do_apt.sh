#
#
#================================== DO_APT
ft_apt() {
    if [ ! -z "$NO_APT" ]; then
        return
    fi
    ft_echo "${BLUE}Updating${NC} apt..."
    if ! apt update -y &>/dev/null; then
        ft_echo "[$RED KO $NC]\n"
        ft_echo "[$YELLOW WARNING $NC] Non-zero returned from apt.\n"
        ft_echo "You may need to run this command with sudo.\n"
        ft_echo "No apt packages will be installed/updated.\n"
    else
        ft_echo "[$GREEN OK $NC]\n"
        ft_echo "${GRAY}================ READING: apt.list$NC\n"
        local pkgs="$(find . "${EXCLUDES[@]}" \
            -type f -name 'apt.list' |
            xargs cat |
            cut -d: -f1 |
            sort | uniq)"
        local to_clean="$(find . "${EXCLUDES[@]}" \
            -type f -name '.aptclean')"
        while read -r pkg; do
            if ! dpkg-query -W -f='${Status}' $pkg 2>/dev/null |
                grep "install ok installed" &>/dev/null; then
                ft_echo "${BLUE}Installing${NC} $pkg..."
                if ! apt install -y "$pkg" &>/dev/null; then
                    ft_echo "[$RED K0 $NC]\n"
                    ft_echo "[$YELLOW WARNING $NC] Non-zero returned from apt.\n"
                    ft_echo "$pkg will not be installed.\n"
                else
                    DIFF=("${DIFF[@]}" "apt:$pkg")
                    while read -r line; do
                        if echo "$line" | grep -q "^$pkg : "; then
                            local target="$(echo "$line" | cut -d: -f2 | xargs)"
                            DIFF=("${DIFF[@]}" "add:$target")
                        fi
                    done < "$to_clean"
                    ft_echo "[$GREEN OK $NC]\n"
                fi
            else
                ft_echo "$pkg [$GREEN OK $NC]\n"
            fi
        done <<< "$(echo "$pkgs")"
    fi
}

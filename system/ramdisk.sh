#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[0;35m'
GRAY='\033[0;37m'
NC='\033[0m'
set -e

declare -A FIRMWARE_MAP=(

    [aic94xx]="aic94xx-firmware.git"
    [ast]="ast-firmware.git"
    [wd719x]="wd719x-firmware.git"
    [xhci_pci]="upd72020x-fw.git"
    [xhci_pci_renesas]="upd72020x-fw.git"
    [bnx2x]="linux-firmware-bnx2x"
    [liquidio]="linux-firmware-liquidio"
    [mlxsw_spectrum]="linux-firmware-mellanox"
    [nfp]="linux-firmware-nfp"
    [bfa]="linux-firmware-qlogic"
    [qed]="linux-firmware-qlogic"
    [qla1280]="linux-firmware-qlogic"
    [qla2xxx]="linux-firmware-qlogic"
)
sed -i "s/block filesystems/block lvm2 filesystems/" "/etc/mkinitcpio.conf"
echo -ne "\n[$YELLOW * $NC] Creating initial ramdisk..."

PATTERN="(?<=WARNING: Possibly missing firmware for module: ')[^']+"
MISSING="$(grep -oP "$PATTERN" <<<"$(mkinitcpio -P 2>&1)")"

echo -e "\r[$GREEN + $NC] Initial ramdisk created    "
BUFFER=()
while read -r MODULE; do

    LINK="${FIRMWARE_MAP[$MODULE]}"
    if [[ -n "$LINK" ]]; then

        BUFFER+=("$LINK")
    else
        echo -e "[$RED - $NC] Missing firmware: $module"
    fi
done <<<"$MISSING"

MISSING="$(printf "%s\n" "${BUFFER[@]}" | sort -u)"

SUDO_NOPASSWD="%wheel ALL=(ALL:ALL) NOPASSWD: ALL"
SUDO_PASSWD="%wheel ALL=(ALL:ALL) ALL"

USERS="$(getent group "wheel" | cut -d ":" -f "4")"
USER="$(cut -d ":" -f "1" <<<"$USERS")"

sed -i "s/# $SUDO_NOPASSWD/$SUDO_NOPASSWD/" "/etc/sudoers"
set +e
for firmware in ${MISSING[@]}; do # Do not quote ${MISSING[@]} here

    echo -ne "[$YELLOW * $NC] Installing missing firmware: $firmware..."
    if [[ "$firmware" == *".git" ]]; then

        DIR="${firmware%.git}"
        sudo -u "$USER" bash -c "

            cd /tmp
            [[ -e $DIR ]] && rm -rf $DIR
            git clone https://aur.archlinux.org/$firmware &> /dev/null
            cd $DIR && makepkg -si --noconfirm &> /dev/null
        "
    else pacman -S --noconfirm "$firmware" &>"/dev/null"; fi

    echo -e "\r[$GREEN + $NC] Installed missing firmware: $firmware    "
done
sed -i "s/$SUDO_NOPASSWD/# $SUDO_NOPASSWD/" "/etc/sudoers"
set -e
sed -i "s/# $SUDO_PASSWD/$SUDO_PASSWD/" "/etc/sudoers"

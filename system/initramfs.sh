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
sed -i "s/consolefont block/consolefont numlock block/" "/etc/mkinitcpio.conf"

echo -ne "\n[$YELLOW * $NC] Creating initramfs..."

PATTERN="(?<=WARNING: Possibly missing firmware for module: ')[^']+"
MISSING="$(grep -oP "$PATTERN" <<<"$(mkinitcpio -P 2>&1)")"

echo -e "\r[$GREEN + $NC] Created initramfs    "
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

aur_install() {
    local firmware="$1"
    local dir="${firmware%.git}"
    sudo -u "$USER" bash -c "

        cd /tmp
        [[ -e $dir ]] && rm -rf $dir
        git clone https://aur.archlinux.org/$firmware &> /dev/null
        cd $dir && makepkg -si --noconfirm &> /dev/null
    "
    #TODO: Must be able to keep them updated
}
USERS="$(getent group "wheel" | cut -d ":" -f "4")"
USER="$(cut -d ":" -f "1" <<<"$USERS")"

sed -i "s/# $SUDO_NOPASSWD/$SUDO_NOPASSWD/" "/etc/sudoers"
set +e
for firmware in ${MISSING[@]}; do # Do not quote ${MISSING[@]} here

    echo -ne "[$YELLOW * $NC] Installing missing firmware: $firmware..."
    if [[ "$firmware" == *".git" ]]; then

        aur_install "$firmware"
    else pacman -S --noconfirm --needed "$firmware" &>"/dev/null"; fi

    echo -e "\r[$GREEN + $NC] Installed missing firmware: $firmware    "
done

NUMLOCK_PKG="mkinitcpio-numlock"
echo -ne "[$YELLOW * $NC] Installing $NUMLOCK_PKG..."

aur_install "$NUMLOCK_PKG"
echo -e "[$GREEN + $NC] Installed $NUMLOCK_PKG    "

sed -i "s/$SUDO_NOPASSWD/# $SUDO_NOPASSWD/" "/etc/sudoers"
set -e

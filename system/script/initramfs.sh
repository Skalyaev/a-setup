#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

GIT_DIR="/usr/local/src/github"
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
while read MODULE; do

    LINK="${FIRMWARE_MAP[$MODULE]}"
    if [[ -n "$LINK" ]]; then

        BUFFER+=("$LINK")
        continue
    fi
    echo -e "[$RED - $NC] Missing firmware: $module"

done <<<"$MISSING"
MISSING="$(printf "%s\n" "${BUFFER[@]}" | sort -u)"

USERS="$(getent group "wheel" | cut -d ":" -f "4")"
USR="$(cut -d ":" -f "1" <<<"$USERS")"

aur_install() {
    local firmware="$1"
    local dir="${firmware%.git}"

    sudo -u "$USR" bash -c "

        cd '$GIT_DIR'
        echo -ne '[$YELLOW * $NC] Cloning $firmware...'
        [[ -e '$dir' ]] ||
            git clone 'https://aur.archlinux.org/$firmware' &>'/dev/null'

        echo -e '\r[$GREEN + $NC] $firmware cloned, running makepkg...'
        cd '$dir'
        if [[ ! -x .install.sh ]]; then

            echo 'makepkg -si --noconfirm' >.install.sh
            chmod +x .install.sh
        fi
        ./.install.sh
    "
}
mkdir -p "$GIT_DIR" && chown "$USR:$USR" "$GIT_DIR"

SUDO_NOPASSWD="%wheel ALL=(ALL:ALL) NOPASSWD: ALL"
sed -i "s/# $SUDO_NOPASSWD/$SUDO_NOPASSWD/" "/etc/sudoers"
set +e
for firmware in ${MISSING[@]} "mkinitcpio-numlock.git"; do

    if [[ "$firmware" == *".git" ]]; then

        aur_install "$firmware"
    else
        echo -ne "[$YELLOW * $NC] Installing missing firmware: $firmware..."

        pacman -S --noconfirm --needed "$firmware" &>"/dev/null"
        echo -e "\r[$GREEN + $NC] Installed missing firmware: $firmware    "
    fi
done
sed -i "s/$SUDO_NOPASSWD/# $SUDO_NOPASSWD/" "/etc/sudoers"
set -e

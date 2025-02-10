#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

GIT_DIR="/usr/local/src/github"
AUR_URL="https://aur.archlinux.org"

USERS="$(getent group "wheel" | cut -d ":" -f "4")"
USR="$(cut -d ":" -f "1" <<<"$USERS")"
USR="$(cut -d "," -f "1" <<<"$USR")"

aur_install() {
    local firmware="$1"
    local dir="${firmware%.git}"

    sudo -u "$USR" bash <<EOF

cd '$GIT_DIR'
[[ -e '$dir' ]] || git clone '$AUR_URL/$firmware' &>'/dev/null'

cd '$dir'
if [[ ! -x .install.sh ]]; then

    echo 'makepkg -si --noconfirm' >.install.sh
    chmod +x .install.sh
fi
./.install.sh
EOF
}
mkdir -p "$GIT_DIR" && chown "$USR:wheel" "$GIT_DIR"

SUDO_NOPASSWD="%wheel ALL=(ALL:ALL) NOPASSWD: ALL"
sed -i "s/# $SUDO_NOPASSWD/$SUDO_NOPASSWD/" "/etc/sudoers"

echo -ne "\n[$YELLOW * $NC] Creating initial initramfs..."
set +e
PATTERN="(?<=WARNING: Possibly missing firmware for module: ')[^']+"
MISSING="$(grep -oP "$PATTERN" < <(aur_install "mkinitcpio-numlock.git" 2>&1))"

echo -e "\r[$GREEN + $NC] Initial initramfs created    "
sed -i "s/$SUDO_NOPASSWD/# $SUDO_NOPASSWD/" "/etc/sudoers"
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

BUFFER=()
while read MODULE; do

    LINK="${FIRMWARE_MAP[$MODULE]}"
    if [[ -n "$LINK" ]]; then

        BUFFER+=("$LINK")
    else echo -e "[$RED - $NC] Missing firmware: $module"; fi

done <<<"$MISSING"
MISSING="$(printf "%s\n" "${BUFFER[@]}" | sort -u)"

sed -i "s/# $SUDO_NOPASSWD/$SUDO_NOPASSWD/" "/etc/sudoers"
set +e
for firmware in ${MISSING[@]}; do

    echo -ne "[$YELLOW * $NC] Installing missing firmware: $firmware..."

    if [[ "$firmware" == *".git" ]]; then

        aur_install "$firmware" &>"/dev/null"
    else pacman -S --noconfirm --needed "$firmware" &>"/dev/null"; fi

    if [[ "$?" -ne 0 ]]; then

        echo -e "\r[$RED - $NC] Failed to install missing firmware: $firmware"
    else echo -e "\r[$GREEN + $NC] Installed missing firmware: $firmware    "; fi
done
sed -i "s/$SUDO_NOPASSWD/# $SUDO_NOPASSWD/" "/etc/sudoers"
set -e

#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[0;35m'
GRAY='\033[0;37m'
NC='\033[0m'
set -e

VAR_SPACE_PERCENTAGE=30
HOME_SPACE_PERCENTAGE=30

BOOT_SIZE=512
SWAP_SIZE=4096
TMP_SIZE=4096

mapfile -t DISKS < <(lsblk -d -o "NAME,SIZE" | tail -n +2)
NAMES=()
SIZES=()
echo
for disk in "${DISKS[@]}"; do

    read NAME SIZE <<<"$disk"

    SIZE="$(sed 's/,/./g' <<<"$SIZE" | sed 's/G/*1024/' | bc)"
    SIZE="$(cut -d "." -f "1" <<<"$SIZE")"

    [[ "$SIZE" -lt "$((32 * 1024))" ]] && continue
    [[ "$NAME" == *"loop"* ]] && continue
    [[ "$NAME" == *"rom"* ]] && continue
    [[ "$NAME" == *"airootfs"* ]] && continue

    NAMES+=("$NAME")
    SIZES+=("$SIZE")
    echo -e "[$PINK ${#NAMES[@]} $NC] $NAME\t\t($((SIZE / 1024))G)"
done
echo -e "[$PINK 0 $NC] Exit"
while true; do

    echo -ne "[$GRAY \$ $NC] Disk selection: "
    read SELECTION

    if [[ -n "$SELECTION" && "$SELECTION" =~ ^[0-9]+$ && \
        "$SELECTION" -ge 0 && "$SELECTION" -le "${#NAMES[@]}" ]]; then

        [[ "$SELECTION" -eq 0 ]] && exit 1
        break
    fi
    echo -e "[$RED - $NC] Invalid selection"
done
IDX="$((SELECTION - 1))"

DISK="/dev/${NAMES[$IDX]}"
SIZE="${SIZES[$IDX]}"
SIZE_LEFT="$((SIZE - BOOT_SIZE * 2 - TMP_SIZE - SWAP_SIZE))"

VAR_SIZE="$((SIZE_LEFT * VAR_SPACE_PERCENTAGE / 100))"
HOME_SIZE="$((SIZE_LEFT * HOME_SPACE_PERCENTAGE / 100))"

echo -ne "[$YELLOW * $NC] Partitioning..."

PARTITION_TYPES="$(fdisk "$DISK" <<<$'g\nn\n\n\n\nt\nL\nq\n' 2>"/dev/null")"
TO_SED='.*[[:space:]]*([0-9]+)[[:space:]]'

TYPE_EFI="$(sed -nE "s/$TO_SED+EFI System.*/\1/p" <<<"$PARTITION_TYPES")"
TYPE_SWAP="$(sed -nE "s/$TO_SED+Linux swap.*/\1/p" <<<"$PARTITION_TYPES")"
TYPE_LVM="$(sed -nE "s/$TO_SED+Linux LVM.*/\1/p" <<<"$PARTITION_TYPES")"

if [[ -z "$TYPE_EFI" || -z "$TYPE_SWAP" || -z "$TYPE_LVM" ]]; then

    echo -e "[$RED - $NC] Invalid disk, aborted"
    exit 1
fi
fdisk "$DISK" <<EOF >"/dev/null"
g
$(echo -e "n\n\n\n+${BOOT_SIZE}M\nt\n$TYPE_EFI\n")
$(echo -e "n\n\n\n+${BOOT_SIZE}M\n")
$(echo -e "n\n\n\n+${SWAP_SIZE}M\nt\n\n$TYPE_SWAP\n")
$(echo -e "n\n\n\n\nt\n\n$TYPE_LVM\n")
w
EOF

mkfs.fat -F32 "${DISK}1" &>"/dev/null"
mkfs.ext4 "${DISK}2" &>"/dev/null"
mkswap "${DISK}3" &>"/dev/null"

echo -e "\r[$GREEN + $NC] Partitions created"

pvcreate "${DISK}4" >"/dev/null"
vgcreate "vg0" "${DISK}4" >"/dev/null"

lvcreate -L "${VAR_SIZE}M" "vg0" -n "var" >"/dev/null"
lvcreate -L "${HOME_SIZE}M" "vg0" -n "home" >"/dev/null"
lvcreate -L "${TMP_SIZE}M" "vg0" -n "tmp" >"/dev/null"
lvcreate -l "100%FREE" "vg0" -n "root" >"/dev/null"

mkfs.ext4 "/dev/vg0/root" &>"/dev/null"
mkfs.ext4 "/dev/vg0/home" &>"/dev/null"
mkfs.ext4 "/dev/vg0/var" &>"/dev/null"
mkfs.ext4 "/dev/vg0/tmp" &>"/dev/null"

echo -e "[$GREEN + $NC] LVM set"

mount "/dev/vg0/root" "/mnt" >"/dev/null"
mount --mkdir "/dev/vg0/var" "/mnt/var" >"/dev/null"
mount --mkdir "/dev/vg0/home" "/mnt/home" >"/dev/null"
mount --mkdir "/dev/vg0/tmp" "/mnt/tmp" >"/dev/null"
mount --mkdir "${DISK}2" "/mnt/boot" >"/dev/null"
mount --mkdir "${DISK}1" "/mnt/boot/efi" >"/dev/null"
swapon "${DISK}3" >"/dev/null"

echo -e "[$GREEN + $NC] Partitions mounted"

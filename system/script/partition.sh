#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[0;35m'
GRAY='\033[0;37m'
NC='\033[0m'
set -e
set -u

VAR_SIZE_PERCENTAGE=30
HOME_SIZE_PERCENTAGE=30

BOOT_SIZE=512
SWAP_SIZE=4096
TMP_SIZE=4096

LVM_NAME="vg0"

mapfile -t DISKS < <(lsblk -d -o "NAME,SIZE" | tail -n "+2")
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
echo -e "[$PINK 0 $NC] Skip"
while true; do

    echo -ne "[$GRAY \$ $NC] Disk partitioning: "
    read SELECTION

    if [[ -z "$SELECTION" || ! "$SELECTION" =~ ^[0-9]+$ ||
        "$SELECTION" -lt 0 || "$SELECTION" -gt "${#NAMES[@]}" ]]; then

        echo -e "[$RED - $NC] Invalid selection"
        continue
    fi
    [[ "$SELECTION" -eq 0 ]] && exit

    IDX="$((SELECTION - 1))"
    DISK="/dev/${NAMES[$IDX]}"

    PARTITION_TYPES="$(fdisk "$DISK" <<<$'g\nn\n\n\n\nt\nL\nq\n' 2>"/dev/null")"
    TO_SED='.*[[:space:]]*([0-9]+)[[:space:]]'

    TYPE_EFI="$(sed -nE "s/$TO_SED+EFI System.*/\1/p" <<<"$PARTITION_TYPES")"
    TYPE_SWAP="$(sed -nE "s/$TO_SED+Linux swap.*/\1/p" <<<"$PARTITION_TYPES")"
    TYPE_LVM="$(sed -nE "s/$TO_SED+Linux LVM.*/\1/p" <<<"$PARTITION_TYPES")"

    if [[ -z "$TYPE_EFI" || -z "$TYPE_SWAP" || -z "$TYPE_LVM" ]]; then

        echo -e "[$RED - $NC] Invalid disk: $DISK"
        continue
    fi
    echo -ne "\n[$GRAY \$ $NC] Disk $DISK will be erased, continue? (n/y): "
    read ANSWER
    [[ "$ANSWER" == [yY]* ]] && break
done
swapoff -a >"/dev/null"
vgchange -an >"/dev/null"
parted -s "$DISK" mklabel gpt >"/dev/null"

SIZE="${SIZES[$IDX]}"
SIZE_LEFT="$((SIZE - BOOT_SIZE * 2 - TMP_SIZE - SWAP_SIZE))"

VAR_SIZE="$((SIZE_LEFT * VAR_SIZE_PERCENTAGE / 100))"
HOME_SIZE="$((SIZE_LEFT * HOME_SIZE_PERCENTAGE / 100))"

echo -ne "\n[$YELLOW * $NC] Creating partitions..."
set +e
fdisk "$DISK" <<EOF &>"/dev/null"
g
$(echo -e "n\n\n\n+${BOOT_SIZE}M\nY\nt\n$TYPE_EFI\n")
$(echo -e "n\n\n\n+${BOOT_SIZE}M\nY\n")
$(echo -e "n\n\n\n+${SWAP_SIZE}M\nY\nt\n\n$TYPE_SWAP\n")
$(echo -e "n\n\n\n\nY\nt\n\n$TYPE_LVM\n")
w
EOF
echo -e "\r[$GREEN + $NC] Partitions created    "
echo -ne "[$YELLOW * $NC] Setting LVM..."

if [[ "$DISK" == "/dev/nvme"* ]]; then
    PREFIX="p"
else
    PREFIX=""
fi
BOOT_EFI_PARTITION="${DISK}${PREFIX}1"
BOOT_PARTITION="${DISK}${PREFIX}2"
SWAP_PARTITION="${DISK}${PREFIX}3"
LVM_PARTITION="${DISK}${PREFIX}4"

mkswap "$SWAP_PARTITION" >"/dev/null"
mkfs.ext4 "$BOOT_PARTITION" >"/dev/null"
mkfs.fat -F32 "$BOOT_EFI_PARTITION" >"/dev/null"

pvcreate "$LVM_PARTITION" >"/dev/null"
vgcreate "$LVM_NAME" "$LVM_PARTITION" >"/dev/null"

lvcreate -L "${VAR_SIZE}M" "$LVM_NAME" -n "var" >"/dev/null"
lvcreate -L "${HOME_SIZE}M" "$LVM_NAME" -n "home" >"/dev/null"
lvcreate -L "${TMP_SIZE}M" "$LVM_NAME" -n "tmp" >"/dev/null"
lvcreate -l "100%FREE" "$LVM_NAME" -n "root" >"/dev/null"

mkfs.ext4 "/dev/${LVM_NAME}/root" >"/dev/null"
mkfs.ext4 "/dev/${LVM_NAME}/home" >"/dev/null"
mkfs.ext4 "/dev/${LVM_NAME}/var" >"/dev/null"
mkfs.ext4 "/dev/${LVM_NAME}/tmp" >"/dev/null"

echo -e "\r[$GREEN + $NC] LVM set       "
echo -ne "[$YELLOW * $NC] Mounting partitions..."

mount "/dev/${LVM_NAME}/root" "/mnt" >"/dev/null"
mount --mkdir "/dev/${LVM_NAME}/var" "/mnt/var" >"/dev/null"
mount --mkdir "/dev/${LVM_NAME}/home" "/mnt/home" >"/dev/null"
mount --mkdir "/dev/${LVM_NAME}/tmp" "/mnt/tmp" >"/dev/null"
mount --mkdir "$BOOT_PARTITION" "/mnt/boot" >"/dev/null"
mount --mkdir "$BOOT_EFI_PARTITION" "/mnt/boot/efi" >"/dev/null"
swapon "$SWAP_PARTITION" >"/dev/null"

echo -e "\r[$GREEN + $NC] Partitions mounted    "
set -e

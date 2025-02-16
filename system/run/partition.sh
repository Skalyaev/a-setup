#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[0;35m'
GRAY='\033[0;37m'
NC='\033[0m'
set -e
set -u

mapfile -t disks < <(lsblk -d -o "NAME,SIZE" | tail -n "+2")
NAMES=()
SIZES=()
for disk in "${disks[@]}"; do

    read name size <<<"$disk"

    size="$(sed 's/,/./g' <<<"$size" | sed 's/G/*1024/' | bc)"
    size="$(cut -d "." -f "1" <<<"$size")"

    [[ "$size" -lt "$((48 * 1024))" ]] && continue
    [[ "$name" == *"loop"* ]] && continue
    [[ "$name" == *"rom"* ]] && continue
    [[ "$name" == *"airootfs"* ]] && continue

    NAMES+=("$name")
    SIZES+=("$size")
    echo -e "[$PINK ${#NAMES[@]} $NC] $name\t\t($((size / 1024))G)"
done
echo -e "[$PINK 0 $NC] Skip"
while true; do

    echo -ne "[$GRAY \$ $NC] Disk partitioning: "
    read selection

    if [[ -z "$selection" || ! "$selection" =~ ^[0-9]+$
        || "$selection" -lt 0 || "$selection" -gt "${#NAMES[@]}" ]]; then

        echo -e "[$RED - $NC] Invalid selection"
        continue
    fi
    [[ "$selection" -eq 0 ]] && exit

    IDX="$((selection - 1))"
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
    echo -ne "[$GRAY \$ $NC] Disk $DISK will be erased, continue? (n/y): "
    read answer
    [[ "$answer" == [yY]* ]] && break
done

BOOT_SIZE=512
SWAP_SIZE=4096
TMP_SIZE=4096

SIZE="${SIZES[$IDX]}"
SIZE_LEFT="$((SIZE - BOOT_SIZE * 2 - TMP_SIZE - SWAP_SIZE))"

UNIT_SIZE="$((SIZE_LEFT * 30 / 100))"
ask_size() {

    local name="$1"
    local size="$2"
    local idx="$3"
    while true; do

        echo -ne "[$GRAY \$ $NC] Size for $name (default: ${size}G): " >&2
        read answer
        if [[ -n "$answer" && ! "$answer" =~ ^[0-9]+$ ]]; then

            echo -e "[$RED - $NC] Invalid size" >&2
            continue
        fi
        answer="${answer:-$size}"
        answer="$((answer * 1024))"

        if [[ "$answer" -lt 8192 || "$answer" -gt "$((size * idx * 1024))" ]]; then

            echo -e "[$RED - $NC] Invalid size" >&2
            continue
        fi
        size="$answer"
        break
    done
    echo "$size"
}
VAR_SIZE="$(ask_size "/var" "$(($UNIT_SIZE / 1024))" 2)"
HOME_SIZE="$(ask_size "/home" "$((UNIT_SIZE / 1024))" 1)"

FDISK_PAYLOAD="$(cat <<EOF
g
$(echo -e "n\n\n\n+${BOOT_SIZE}M\nY\nt\n$TYPE_EFI\n")
$(echo -e "n\n\n\n+${BOOT_SIZE}M\nY\n")
$(echo -e "n\n\n\n+${SWAP_SIZE}M\nY\nt\n\n$TYPE_SWAP\n")
$(echo -e "n\n\n\n\nY\nt\n\n$TYPE_LVM\n")
w
EOF
)"
if [[ "$DISK" == "/dev/nvme"* ]]; then
    DISK_PREFIX="p"
else
    DISK_PREFIX=""
fi
BOOT_EFI_PARTITION="$DISK${DISK_PREFIX}1"
BOOT_PARTITION="$DISK${DISK_PREFIX}2"
SWAP_PARTITION="$DISK${DISK_PREFIX}3"
LVM_PARTITION="$DISK${DISK_PREFIX}4"
init_partitions() {

    while true; do
        swapoff -a &>"/dev/null"
        vgchange -an &>"/dev/null"
        parted -s "$DISK" "mklabel" "gpt" &>"/dev/null"

        set +e
        fdisk "$DISK" <<<"$FDISK_PAYLOAD" &>"/dev/null"
        set -e

        mkswap "$SWAP_PARTITION" &>"/dev/null"
        mkfs.ext4 "$BOOT_PARTITION" &>"/dev/null"
        mkfs.fat -F32 "$BOOT_EFI_PARTITION" &>"/dev/null"

        pvcreate -ffy "$LVM_PARTITION" &>"/dev/null" && break
    done
}
echo -ne "\n[$YELLOW * $NC] Creating partitions..."
init_partitions

echo -e "\r[$GREEN + $NC] Partitions created    "
echo -ne "[$YELLOW * $NC] Setting LVM..."

LVM_NAME="vg0"
vgcreate "$LVM_NAME" "$LVM_PARTITION" &>"/dev/null"

lvcreate -y -L "${VAR_SIZE}M" "$LVM_NAME" -n "var" &>"/dev/null"
lvcreate -y -L "${HOME_SIZE}M" "$LVM_NAME" -n "home" &>"/dev/null"
lvcreate -y -L "${TMP_SIZE}M" "$LVM_NAME" -n "tmp" &>"/dev/null"
lvcreate -y -l "100%FREE" "$LVM_NAME" -n "root" &>"/dev/null"

mkfs.ext4 "/dev/$LVM_NAME/root" &>"/dev/null"
mkfs.ext4 "/dev/$LVM_NAME/home" &>"/dev/null"
mkfs.ext4 "/dev/$LVM_NAME/var" &>"/dev/null"
mkfs.ext4 "/dev/$LVM_NAME/tmp" &>"/dev/null"

echo -e "\r[$GREEN + $NC] LVM set       "
echo -ne "[$YELLOW * $NC] Mounting partitions..."

mount "/dev/$LVM_NAME/root" "/mnt" &>"/dev/null"
mount --mkdir "/dev/$LVM_NAME/var" "/mnt/var" &>"/dev/null"
mount --mkdir "/dev/$LVM_NAME/home" "/mnt/home" &>"/dev/null"
mount --mkdir "/dev/$LVM_NAME/tmp" "/mnt/tmp" &>"/dev/null"
mount --mkdir "$BOOT_PARTITION" "/mnt/boot" &>"/dev/null"
mount --mkdir "$BOOT_EFI_PARTITION" "/mnt/boot/efi" &>"/dev/null"
swapon "$SWAP_PARTITION" &>"/dev/null"

echo -e "\r[$GREEN + $NC] Partitions mounted    "

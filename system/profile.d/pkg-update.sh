pacman -Syu --noconfirm

ORPHANS=$(pacman -Qdtq)
pacman -Rns "$ORPHANS" --noconfirm

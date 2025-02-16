#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
set -e
set -u

PGDATA_DIR="/var/lib/postgres/data"
if [[ "$(sudo ls "$PGDATA_DIR" 2>"/dev/null")" ]]; then

    echo -e "[$GREEN + $NC] Postgres data set"
    exit
fi
echo -ne "[$YELLOW * $NC] Initializing Postgres data"

sudo mkdir -p "$PGDATA_DIR"
sudo chown "postgres:postgres" "$PGDATA_DIR"
sudo chmod 700 "$PGDATA_DIR"

sudo -u "postgres" initdb \
    --locale="C.UTF-8" \
    --encoding="UTF8" \
    -D "$PGDATA_DIR" \
    --auth-local="peer" \
    --auth-host="trust" &>"/dev/null"

echo -e "\r[$GREEN + $NC] Postgres data initialized "

sudo systemctl enable "postgresql"
sudo systemctl start "postgresql"

#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -e
set -u

TASKLIST=(
    "0 18 * * * gitsync $HOME/document/github"
)
TASKS="$(crontab -l 2>"/dev/null")"
for TASK in "${TASKLIST[@]}"; do

    if [[ -z "$TASKS" ]] || ! grep -qF "$TASK" <<<"$TASKS" >"/dev/null"; then

        [[ -n "$TASKS" ]] && TASKS="$TASKS\n"

        NAME="$(cut -d' ' -f6- <<<"$TASK")"
        echo -ne "[$YELLOW * $NC] Setting '$NAME' cronjob..."

        echo -e "$TASKS$TASK" | crontab - >"/dev/null"
        echo -e "\r[$GREEN + $NC] '$NAME' cronjob set       "

        TASKS="$(crontab -l 2>"/dev/null")"
    fi
done

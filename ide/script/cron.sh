#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'
set -u

TASKLIST=(
    "0 18 * * * gitsync $HOME/document/github"
)
TASKS="$(crontab -l 2>"/dev/null")"
set -e
for TASK in "${TASKLIST[@]}"; do

    grep -q "$TASK" <<<"$TASKS" && continue
    [[ -n "$TASKS" ]] && TASKS+="\n"

    NAME="$(cut -d " " -f "6-" <<<"$TASK")"
    echo -ne "[$YELLOW * $NC] Setting '$NAME' cronjob..."

    echo -e "$TASKS$TASK" | crontab - &>"/dev/null"
    echo -e "\r[$GREEN + $NC] '$NAME' cronjob set       "

    TASKS="$(crontab -l 2>"/dev/null")"
done

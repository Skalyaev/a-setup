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

    [[ -n "$TASKS" ]] && grep -qF "$TASK" <<<"$TASKS" && continue

    NAME="$(cut -d " " -f "6-" <<<"$TASK")"
    echo -ne "[$YELLOW * $NC] Setting '$NAME' cronjob..."

    crontab - <<<"$TASKS\n$TASK" &>"/dev/null"
    echo -e "\r[$GREEN + $NC] '$NAME' cronjob set       "

    TASKS="$(crontab -l 2>"/dev/null")"
done

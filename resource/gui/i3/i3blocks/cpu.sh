#!/bin/bash
CPU_USAGE="$(top -bn2 | grep "Cpu(s)"\
    | tail -n 1 | awk '{print $2 + $4}')"

if [[ ! "$CPU_USAGE" ]];then
    echo "N/A"
    echo "N/A"
    echo "#FF0000"
else
    CPU_USAGE="$(printf "%.0f" "$CPU_USAGE")"
    echo "$CPU_USAGE%"
    echo "$CPU_USAGE%"

    if [[ "$CPU_USAGE" -lt 50 ]];then
        echo "#00FF00"
    elif [[ "$CPU_USAGE" -ge 50 && "$CPU_USAGE" -lt 75 ]];then
        echo "#FFFF00"
    else
        echo "#FF0000"
    fi
fi

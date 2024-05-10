#!/bin/bash
GPU_USAGE="$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)"

if [ -z "$GPU_USAGE"] || ["$GPU_USAGE" -lt 0 ]
then
    echo "N/A"
    echo "N/A"
    echo "#FF0000"
else
    GPU_USAGE="$(printf "%.0f" "$GPU_USAGE")"
    echo "$GPU_USAGE%"
    echo "$GPU_USAGE%"

    if [ "$GPU_USAGE" -lt 50 ]; then
        echo "#00FF00"
    elif [ "$GPU_USAGE" -ge 50 -a "$GPU_USAGE" -lt 75 ]; then
        echo "#FFFF00"
    else
        echo "#FF0000"
    fi
fi

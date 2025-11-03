#!/bin/bash

# GPU monitoring script for NVIDIA cards using nvidia-smi
# Returns JSON for Waybar

# Set PATH explicitly for hyprctl dispatch compatibility
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Query GPU stats: utilization, memory used, memory total, temperature
# Format: GPU_UTIL,MEM_USED,MEM_TOTAL,TEMP
GPU_STATS=$(/usr/bin/nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total,temperature.gpu --format=csv,noheader,nounits 2>/dev/null)

# Check if nvidia-smi succeeded
if [ $? -ne 0 ]; then
    echo '{"text": "N/A", "tooltip": "nvidia-smi not available"}'
    exit 0
fi

# Parse the output
GPU_UTIL=$(echo "$GPU_STATS" | /usr/bin/awk -F', ' '{print $1}')
MEM_USED=$(echo "$GPU_STATS" | /usr/bin/awk -F', ' '{print $2}')
MEM_TOTAL=$(echo "$GPU_STATS" | /usr/bin/awk -F', ' '{print $3}')
TEMP=$(echo "$GPU_STATS" | /usr/bin/awk -F', ' '{print $4}')

# Convert memory from MB to GB for better readability
MEM_USED_GB=$(/usr/bin/awk "BEGIN {printf \"%.1f\", $MEM_USED/1024}")
MEM_TOTAL_GB=$(/usr/bin/awk "BEGIN {printf \"%.1f\", $MEM_TOTAL/1024}")

# Create tooltip with detailed info
TOOLTIP="GPU: ${GPU_UTIL}%\nVRAM: ${MEM_USED_GB}GB / ${MEM_TOTAL_GB}GB\nTemp: ${TEMP}°C"

# Output JSON for Waybar
echo "{\"text\": \"${GPU_UTIL}% ${TEMP}°C\", \"tooltip\": \"${TOOLTIP}\"}"

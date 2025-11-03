#!/usr/bin/bash

# CPU monitoring script for AMD CPUs using sensors and /proc/stat
# Returns JSON for Waybar

# Debug logging
LOG="/tmp/waybar-cpu.log"
echo "=== CPU script run at $(date) ===" >> "$LOG" 2>&1

# Set PATH explicitly for hyprctl dispatch compatibility
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Get CPU usage from /proc/stat (doesn't require TTY like top does)
# Read /proc/stat twice with a delay to calculate usage
read cpu a b c idle rest < /proc/stat
sleep 0.1
read cpu a2 b2 c2 idle2 rest < /proc/stat

# Calculate CPU usage
total=$((a2+b2+c2+idle2))
total_prev=$((a+b+c+idle))
diff_total=$((total-total_prev))
diff_idle=$((idle2-idle))
diff_used=$((diff_total-diff_idle))

# Calculate percentage
if [ "$diff_total" -gt 0 ]; then
    CPU_USAGE=$((100*diff_used/diff_total))
else
    CPU_USAGE=0
fi

echo "CPU_USAGE: $CPU_USAGE" >> "$LOG" 2>&1

# Get CPU temperature using sensors (k10temp for AMD)
# Try to get Tctl (control temperature) first, fallback to Tccd1 if not available
TEMP=$(/usr/bin/sensors k10temp-pci-00c3 2>> "$LOG" | /usr/bin/grep -E "Tctl:|Tccd1:" | /usr/bin/head -n1 | /usr/bin/awk '{print $2}' | /usr/bin/sed 's/+//;s/°C//')
echo "TEMP: $TEMP" >> "$LOG" 2>&1

# Check if we got valid data
if [ -z "$CPU_USAGE" ]; then
    CPU_USAGE="N/A"
    echo "CPU_USAGE is empty, setting to N/A" >> "$LOG" 2>&1
fi

if [ -z "$TEMP" ]; then
    TEMP="N/A"
    TOOLTIP="CPU: ${CPU_USAGE}%\nTemp: unavailable"
    OUTPUT="{\"text\": \"${CPU_USAGE}%\", \"tooltip\": \"${TOOLTIP}\"}"
    echo "Output: $OUTPUT" >> "$LOG" 2>&1
    echo "$OUTPUT"
    exit 0
fi

# Get additional CPU info for tooltip
CPU_CORES=$(/usr/bin/nproc)
CPU_FREQ=$(/usr/bin/awk '{printf "%.2f", $1/1000000}' /proc/cpuinfo | /usr/bin/head -n1)

# Try to get all temperature sensors for detailed tooltip
TCTL=$(/usr/bin/sensors k10temp-pci-00c3 2>/dev/null | /usr/bin/grep "Tctl:" | /usr/bin/awk '{print $2}' | /usr/bin/sed 's/+//;s/°C//')
TCCD1=$(/usr/bin/sensors k10temp-pci-00c3 2>/dev/null | /usr/bin/grep "Tccd1:" | /usr/bin/awk '{print $2}' | /usr/bin/sed 's/+//;s/°C//')

# Create tooltip with detailed info
if [ -n "$TCTL" ] && [ -n "$TCCD1" ]; then
    TOOLTIP="CPU: ${CPU_USAGE}%\nTemp (Tctl): ${TCTL}°C\nTemp (Die): ${TCCD1}°C\nCores: ${CPU_CORES}"
else
    TOOLTIP="CPU: ${CPU_USAGE}%\nTemp: ${TEMP}°C\nCores: ${CPU_CORES}"
fi

# Output JSON for Waybar (matching GPU format)
OUTPUT="{\"text\": \"${CPU_USAGE}% ${TEMP}°C\", \"tooltip\": \"${TOOLTIP}\"}"
echo "Final output: $OUTPUT" >> "$LOG" 2>&1
echo "$OUTPUT"

#!/usr/bin/env bash

get_battery() {
    if command -v acpi >/dev/null 2>&1; then
        BAT_INFO=$(acpi -b 2>/dev/null | head -n1)
        if [[ -n "$BAT_INFO" ]]; then
            PERCENT=$(echo "$BAT_INFO" | grep -o "[0-9]*%" | head -n1)
            STATUS=$(echo "$BAT_INFO" | grep -o "Charging\|Discharging\|Full\|Not charging" | head -n1)
            echo "Battery: ${PERCENT:-0%} [${STATUS:-AC}]"
            return
        fi
    fi
    if [[ -d /sys/class/power_supply/BAT0 ]]; then
        CAP=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "0")
        STAT=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo "On AC")
        echo "Battery: ${CAP}% [${STAT}]"
    else
        echo "AC Power"
    fi
}

get_memory() {
    free -m | awk '/Mem:/ { printf("Memory: %d%%", $3/$2*100) }'
}

get_termweek() {
    WEEK=$(date +%W)
    WEEK=$((10#$WEEK))
    CALC=$((WEEK - 0))
    echo "Winter 2026: ${CALC}/10"
}

while true; do
    BAT=$(get_battery)
    MEM=$(get_memory)
    DATE_VAL=$(date "+%a %m/%d/%Y")
    TIME_VAL=$(date "+%H:%M:%S")
    TERMWEEK=$(get_termweek)

    STATUS=" $BAT | $MEM | $DATE_VAL ($TERMWEEK) $TIME_VAL "
    
    xsetroot -name "$STATUS"
    sleep 1
done

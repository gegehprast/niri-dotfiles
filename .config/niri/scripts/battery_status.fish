#!/usr/bin/env fish

# Define thresholds
set LOW_THRESHOLD 30
set CRITICAL_THRESHOLD 15

# Loop indefinitely
while true
    # Get battery capacity
    set bat_capacity (bat-asus-battery capacity)
    set bat_status (bat-asus-battery status) # Charging | Discharging

    # Check if capacity was read successfully
    if test -z "$bat_capacity"
        echo "Error: Could not read battery capacity"
        sleep 600  # Sleep 10 minutes before retrying
        continue
    end

    # Get current brightness
    set current_brightness (brightnessctl get)
    set max_brightness (brightnessctl max)

    # Calculate brightness levels
    set normal_brightness (math "round($max_brightness * 0.25)")
    set low_brightness (math "round($max_brightness * 0.15)")
    set critical_brightness (math "round($max_brightness * 0.1)")

    # Only adjust brightness if discharging
    if test "$bat_status" = "Discharging"
        # Adjust brightness based on battery level
        if test $bat_capacity -le $CRITICAL_THRESHOLD
            brightnessctl -q set $critical_brightness
            notify-send -u critical "Battery Critical" "Battery at $bat_capacity%. Brightness reduced to 30%"
        else if test $bat_capacity -le $LOW_THRESHOLD
            brightnessctl -q set $low_brightness
            notify-send -u normal "Battery Low" "Battery at $bat_capacity%. Brightness reduced to 50%"
        end
    end

    # Sleep for 10 minutes (600 seconds)
    sleep 600
end

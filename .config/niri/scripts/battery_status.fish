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
    set normal_brightness (math "round($max_brightness * 0.20)")
    set low_brightness (math "round($max_brightness * 0.15)")
    set critical_brightness (math "round($max_brightness * 0.1)")

    # Adjust brightness based on battery status and level
    set brightness_save_file /tmp/battery_brightness_saved

    if test "$bat_status" = "Discharging"
        # Adjust brightness based on battery level
        if test $bat_capacity -le $CRITICAL_THRESHOLD
            if not test -e $brightness_save_file
                brightnessctl get > $brightness_save_file
            end
            brightnessctl -q set $critical_brightness
            notify-send -u critical "Battery Critical" "Battery at $bat_capacity%. Brightness reduced to 10%"
        else if test $bat_capacity -le $LOW_THRESHOLD
            if not test -e $brightness_save_file
                brightnessctl get > $brightness_save_file
            end
            brightnessctl -q set $low_brightness
            notify-send -u normal "Battery Low" "Battery at $bat_capacity%. Brightness reduced to 15%"
        else
            # Battery is above threshold, restore only if we previously reduced it
            if test -e $brightness_save_file
                brightnessctl -q set (cat $brightness_save_file)
                rm $brightness_save_file
            end
        end
    else
        # Charging or Full, restore only if we previously reduced it
        if test -e $brightness_save_file
            brightnessctl -q set (cat $brightness_save_file)
            rm $brightness_save_file
        end
    end

    # Sleep for 10 minutes (600 seconds)
    sleep 600
end

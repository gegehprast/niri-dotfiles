#!/usr/bin/env fish

# Get current default audio sink
set current_sink (pactl get-default-sink)

# Initialize arrays for sink data
set sink_names
set sink_descriptions
set display_list
set icon_on "🔊"
set icon_off "🔈"

# Process each available audio sink
for sink_name in (pactl list short sinks | awk '{print $2}')
    if test -n "$sink_name"
        # Extract human-readable description
        set description (pactl list sinks | grep -A 10 "Name: $sink_name" | grep "Description:" | head -1 | string replace --regex '.*Description: (.*)' '$1' | string trim)

        if test -n "$description"
            # Add visual indicator for current sink
            if test "$sink_name" = "$current_sink"
                set display_item "$icon_on $description"
            else
                set display_item "$icon_off $description"
            end

            # Store sink data
            set --append sink_names $sink_name
            set --append sink_descriptions "$description"
            set --append display_list "$display_item"
        end
    end
end

# Show dmenu selector and get user choice
printf '%s\n' $display_list | vicinae dmenu --placeholder "Select audio output" | read --local selected_item

# Switch to selected audio output
if test -n "$selected_item"
    set selected_description (echo $selected_item | string replace --regex "^$icon_on |^$icon_off " '')

    # Find matching sink name and set as default
    for i in (seq (count $sink_descriptions))
        if test "$sink_descriptions[$i]" = "$selected_description"
            pactl set-default-sink $sink_names[$i]

            sleep 0.1  # Small delay to ensure the sink is set before adjusting volume

            # My speaker
            if test "$sink_names[$i]" = "alsa_output.usb-Generic_USB_Audio-00.HiFi__Headphones__sink"
                wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.35
                echo "Set HiFi Headphones volume to 35%"
                # My headset
            else if test "$sink_names[$i]" = "alsa_output.usb-SteelSeries_SteelSeries_Arctis_5_00000000-00.analog-game"
                wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.90
                echo "Set SteelSeries Arctis 5 volume to 90%"
            end

            echo "Audio output set to: $sink_names[$i]"
            break
        end
    end
end

#!/usr/bin/env fish

# Get current default audio sink
set current_sink (pactl get-default-sink)

# Initialize arrays for sink data
set sink_names
set sink_descriptions
set display_list

# Process each available audio sink
for sink_name in (pactl list short sinks | awk '{print $2}')
    if test -n "$sink_name"
        # Extract human-readable description
        set description (pactl list sinks | grep -A 10 "Name: $sink_name" | grep "Description:" | head -1 | string replace --regex '.*Description: (.*)' '$1' | string trim)
        
        if test -n "$description"
            # Add visual indicator for current sink
            if test "$sink_name" = "$current_sink"
                set display_item "🔊 $description"
            else
                set display_item "🔈 $description"
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
    set selected_description (echo $selected_item | string replace --regex '^🔊 |^🔈 ' '')
    
    # Find matching sink name and set as default
    for i in (seq (count $sink_descriptions))
        if test "$sink_descriptions[$i]" = "$selected_description"
            pactl set-default-sink $sink_names[$i]
            echo "Audio output set to: $selected_description"
            break
        end
    end
end

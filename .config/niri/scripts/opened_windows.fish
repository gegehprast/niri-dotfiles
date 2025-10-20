#!/usr/bin/env fish

# Get niri windows output
set windows_output (niri msg windows | string collect)

# Parse window information
set window_ids
set window_titles
set current_id ""
set current_title ""

for line in (echo $windows_output | string split '\n')
    if string match --quiet "Window ID*" $line
        # Save previous window if complete
        if test -n "$current_id" -a -n "$current_title"
            set --append window_ids $current_id
            set --append window_titles "$current_title"
        end
        # Start new window
        set current_id (echo $line | string replace --regex '^Window ID (\d+).*$' '$1')
        set current_title ""
    else if string match --quiet "  Title:*" $line
        set current_title (echo $line | string replace --regex '^\s*Title:\s*"(.*)"\s*$' '$1')
    end
end

# Add the last window
if test -n "$current_id" -a -n "$current_title"
    set --append window_ids $current_id
    set --append window_titles "$current_title"
end

# Show window selector and focus selected window
printf '%s\n' $window_titles | vicinae dmenu --placeholder "Select window" | read --local selected_title

if test -n "$selected_title"
    # Find the index of the selected title to get corresponding ID
    for i in (seq (count $window_titles))
        if test "$window_titles[$i]" = "$selected_title"
            niri msg action focus-window --id $window_ids[$i]
            break
        end
    end
end

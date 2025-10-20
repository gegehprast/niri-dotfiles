#!/usr/bin/env fish

# Get niri windows output
set windows_output (niri msg windows | string collect)

# Parse window information
set window_ids
set window_titles
set window_app_ids
set current_id ""
set current_title ""
set current_app_id ""

for line in (echo $windows_output | string split '\n')
    if string match --quiet "Window ID*" $line
        # Save previous window if complete
        if test -n "$current_id" -a -n "$current_title" -a -n "$current_app_id"
            set --append window_ids $current_id
            set --append window_titles "$current_title"
            set --append window_app_ids $current_app_id
        end
        # Start new window
        set current_id (echo $line | string replace --regex '^Window ID (\d+).*$' '$1')
        set current_title ""
        set current_app_id ""
    else if string match --quiet "  Title:*" $line
        set current_title (echo $line | string replace --regex '^\s*Title:\s*"(.*)"\s*$' '$1')
    else if string match --quiet "  App ID:*" $line
        set current_app_id (echo $line | string replace --regex '^\s*App ID:\s*"(.*)"\s*$' '$1')
    end
end

# Add the last window
if test -n "$current_id" -a -n "$current_title" -a -n "$current_app_id"
    set --append window_ids $current_id
    set --append window_titles "$current_title"
    set --append window_app_ids $current_app_id
end

# Create display list with icons and titles
set display_list
for i in (seq (count $window_titles))
    set --append display_list "[$window_app_ids[$i]]  $window_titles[$i]"
end

# Show window selector and focus selected window
printf '%s\n' $display_list | vicinae dmenu --placeholder "Select window" | read --local selected_item

if test -n "$selected_item"
    # Extract the title from the selected item (remove icon and spaces)
    set selected_title (echo $selected_item | string replace --regex '^\[[^]]+\] +(.*)$' '$1')
    # Find the index of the selected title to get corresponding ID
    for i in (seq (count $window_titles))
        if test "$window_titles[$i]" = "$selected_title"
            niri msg action focus-window --id $window_ids[$i]
            break
        end
    end
end

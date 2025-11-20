#!/usr/bin/env fish

# Get outputs from niri and extract output names
set outputs (niri msg outputs | grep '^Output' | string replace --regex '.*\(([^)]+)\).*' '$1')

printf '%s\n' $outputs | vicinae dmenu --placeholder "Select output to mirror" | read --local selected_item

echo $selected_item

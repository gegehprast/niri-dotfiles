#!/usr/bin/env fish

# 1. Screenshot with niri
# It is saved in ~/Pictures/Screenshots with the name niri_%Y%m%d_%H%M%S.png

# Record the latest file before taking the screenshot
set before (command ls ~/Pictures/Screenshots/niri_*.png 2>/dev/null | tail -n 1)

niri msg action screenshot

# 2. Wait for a new screenshot file to appear
# `command ls` is used to avoid aliasing of `ls` for something like `eza`
set latest_screenshot ""
while test -z "$latest_screenshot"
    set current (command ls ~/Pictures/Screenshots/niri_*.png 2>/dev/null | tail -n 1)
    if test "$current" != "$before"
        set latest_screenshot $current
    else
        sleep 0.1
    end
end

# 3. Open the latest screenshot with satty for annotation
satty \
    --filename $latest_screenshot \
    --initial-tool brush \
    --actions-on-enter save-to-clipboard,exit \
    --actions-on-escape save-to-clipboard,exit \
    --copy-command wl-copy \
    --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H%M%S').png

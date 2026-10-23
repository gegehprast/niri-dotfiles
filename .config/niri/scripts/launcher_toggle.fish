#!/usr/bin/env fish

# Toggle the noctalia launcher in a given mode, switching directly between modes.
# Usage: launcher_toggle.fish app|win
# The mode that last opened the launcher is tracked in a state file (also written by audio_sink.fish).

set mode $argv[1]
set state_file $XDG_RUNTIME_DIR/noctalia-launcher-mode

if noctalia msg status | string match -q '*"activePanelId": "launcher"*'
    set current (cat $state_file 2>/dev/null)

    # Same mode pressed again: close
    if test "$current" = "$mode"
        noctalia msg panel-close launcher
        exit
    end

    # A dmenu picker can't be switched in place, and opening without a query keeps the old one,
    # so close first and reopen fresh
    if test "$current" = audio; or test "$mode" = app
        noctalia msg panel-close launcher
        sleep 0.15
    end
end

echo $mode >$state_file

switch $mode
    case win
        noctalia msg panel-open launcher /win
    case '*'
        noctalia msg panel-open launcher
end

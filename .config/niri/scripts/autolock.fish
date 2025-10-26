#!/usr/bin/env fish

while true
    set output (qs -c noctalia-shell list | string collect)

    if string match -q "*Process ID: *" -- $output
        break
    end

    sleep 1
end

sleep 1.1

qs -c noctalia-shell ipc call lockScreen lock

#!/usr/bin/env fish

# Wait until noctalia is up and answering IPC
while not noctalia msg status >/dev/null 2>&1
    sleep 1
end

sleep 1.1

noctalia msg session lock

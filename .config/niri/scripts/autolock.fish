#!/usr/bin/env fish

# Wait until noctalia is up and answering IPC
while not noctalia msg status >/dev/null 2>&1
    sleep 1
end

sleep 1.1

noctalia msg session lock

# Autologin can't unlock the login keyring, so noctalia's startup request opens a keyring prompt
# behind the lock screen. Unlocking the lock screen unlocks the keyring via PAM, but the prompt
# stays open; close it once the keyring is unlocked.
for i in (seq 3600)
    if busctl --user get-property org.freedesktop.secrets /org/freedesktop/secrets/collection/login org.freedesktop.Secret.Collection Locked 2>/dev/null | string match -q 'b false'
        pkill -x gcr-prompter
        break
    end
    sleep 1
end

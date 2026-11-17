# This is not necessarily a usage guide, more like a note to self.

## GNOME/Keyring

### 1. PAM step

Add `auth optional pam_gnome_keyring.so` at the end of the auth section and `session optional pam_gnome_keyring.so auto_start` at the end of the session section.

*/etc/pam.d/login*

```
#%PAM-1.0

auth       required     pam_securetty.so
auth       requisite    pam_nologin.so
auth       include      system-local-login
auth       optional     pam_gnome_keyring.so <-- ADD THIS LINE
account    include      system-local-login
session    include      system-local-login
session    optional     pam_gnome_keyring.so auto_start <-- ADD THIS LINE
```

### 2. Automatically change keyring password with user password

Append `password optional pam_gnome_keyring.so` to `/etc/pam.d/passwd`:

*/etc/pam.d/passwd*

```
...
password	optional	pam_gnome_keyring.so
```

## Installation

1. Install paru first; `packages.fish` uses it:

    ```
    sudo pacman -S paru
    ```

2. Run `./install.fish`. It installs the packages and runs `stow --no-folding .`, so only files get symlinked, never whole directories. That keeps files noctalia generates (kitty theme, GTK/Qt colors, etc.) out of the repo.

3. Disable any login manager the distro installed, otherwise the tty login below never happens:

    ```
    sudo systemctl disable sddm
    ```

## Login on tty1

I don't use a login manager. Log in with your password on tty1, and fish starts niri (see `.config/fish/config.fish`):

```fish
if [ -z $WAYLAND_DISPLAY ] && [ $XDG_VTNR -eq 1 ]
    niri-session -l
end
```

Logging in with a password also unlocks the GNOME keyring via PAM (see above).

`~/.config/niri/scripts/autolock.fish` is for the old autologin setup (getty `--autologin` plus locking noctalia right after niri starts). It's disabled in `config.kdl` and not needed with password login.

## Default Terminal

Set the default terminal emulator to kitty, run:

```
xdg-mime default kitty.desktop x-scheme-handler/terminal
```

I've also installed `xdg-terminal-exec` and added kitty.desktop to the list (`~/.config/xdg-terminals.list`). This step is already configured in the dotfiles. Not sure if this is necessary, but this makes Arch/Cachy-Update work properly with kitty as the terminal in my case.

## Make browsers use Dolphin as file manager
>*This step is already configured in the dotfiles.*

Mask the `/usr/share/dbus-1/services/org.freedesktop.FileManager1.service` file by copying it to `~/.local/share/dbus-1/services/` and modifying the `Exec=` line to `/bin/false`.

*~/.local/share/dbus-1/services/org.freedesktop.FileManager1.service*

```
[D-BUS Service]
Name=org.freedesktop.FileManager1
Exec=/bin/false
```

Probably requires a restart or relogin.

## Make Firefox-based browsers use KDE file picker

Set `org.freedesktop.impl.portal.FileChooser` to `kde` in `niri-portals.conf`. 

*~/.config/xdg-desktop-portal/niri-portals.conf*
```
[preferred]
...
org.freedesktop.impl.portal.FileChooser=kde;
...
```

This part is already configured in the dotfiles, but you probably need to configure your browser flags as well.

Go to `about:config` and set `widget.use-xdg-desktop-portal.file-picker` to 1. The possible values, as far as I know, are:
- 0 = Don't use xdg-desktop-portal file picker
- 1 = Always use xdg-desktop-portal file picker
- 2 = Automatic

## Screencasting
>*This step is already configured in the dotfiles.*

I don't know what happened during my setup, but screencasting doesn't work without these two lines in `niri-portals.conf`.

*~/.config/xdg-desktop-portal/niri-portals.conf*
```
[preferred]
...
org.freedesktop.impl.portal.Settings=gnome;
org.freedesktop.impl.portal.ScreenCast=gnome;
...
```

## XWayland Applications
Some apps, like Electron apps, won't launch without setting the DISPLAY environment variable to `:0`. The simplest way is to just append `DISPLAY=:0` before the executable, like `DISPLAY=:0 discord`.

Now, some extra steps are required to make this work with the Noctalia launcher. I'm still very new to niri, so this is the best I can come up for now. Create a wrapper script for your app; see the example in `.config/niri/scripts/xwayland_{APP}.fish`. Then edit the app's desktop file to point to the wrapper script. Example for Discord:

*~/.config/niri/scripts/xwayland_discord.fish*

```fish
#!/usr/bin/env fish

set DISPLAY :0
/usr/bin/discord $argv
```

*~/.local/share/applications/discord.desktop*

```
[Desktop Entry]
Name=Discord
...
Exec=/home/gegeh/.config/niri/scripts/xwayland_discord.fish
...
```

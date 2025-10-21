## GNOME/Keyring

### 1. PAM step

Add `auth optional pam_gnome_keyring.so` at the end of the auth section and `session optional pam_gnome_keyring.so auto_start` at the end of the session section.

*/etc/pam.d/login*

```
#%PAM-1.0

auth       required     pam_securetty.so
auth       requisite    pam_nologin.so
auth       include      system-local-login
auth       optional     pam_gnome_keyring.so
account    include      system-local-login
session    include      system-local-login
session    optional     pam_gnome_keyring.so auto_start
```

### 2. Automatically change keyring password with user password

Append `password optional pam_gnome_keyring.so` to `/etc/pam.d/passwd`:

*/etc/pam.d/passwd*

```
...
password	optional	pam_gnome_keyring.so
```

## getty

### Automatic login to virtual console

I don't like using a login manager. I just use the shell lockscreen; see `~/.config/niri/scripts/autolock.fish`. The script will trigger the Noctalia lockscreen when niri first starts.

Now, to make automatic login to virtual console work, create a drop-in file for `getty@tty1.service` with the following contents:

*/etc/systemd/system/getty@tty1.service.d/autologin.conf*

```
[Service]
ExecStart=
ExecStart=-/sbin/agetty --noreset --noclear --autologin USERNAME - ${TERM}
```

Replace `USERNAME` with your username.

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

Set `org.freedesktop.impl.portal.FileChooser` to `kde` in `niri-portal.conf`. 

*~/.config/xdg-desktop-portal/niri-portal.conf*
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

I don't know what happened during my setup, but screencasting doesn't work without these two lines in `niri-portal.conf`.

*~/.config/xdg-desktop-portal/niri-portal.conf*
```
[preferred]
...
org.freedesktop.impl.portal.Settings=gnome;
org.freedesktop.impl.portal.ScreenCast=gnome;
...
```

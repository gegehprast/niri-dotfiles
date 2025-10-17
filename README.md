## GNOME/Keyring

### 1. PAM step
Add `auth optional pam_gnome_keyring.so` at the end of the auth section and `session optional pam_gnome_keyring.so auto_start` at the end of the session section. 



```
/etc/pam.d/login

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
```
/etc/pam.d/passwd

...
password	optional	pam_gnome_keyring.so
```

## getty
### Automatic login to virtual console
#### Virtual console
Create a drop-in file for `getty@tty1.service` with the following contents: 
```
/etc/systemd/system/getty@tty1.service.d/autologin.conf

[Service]
ExecStart=
ExecStart=-/sbin/agetty --noreset --noclear --autologin USERNAME - ${TERM}
```
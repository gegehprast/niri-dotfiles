#!/usr/bin/env fish

paru -S archlinux-xdg-menu
sudo ln -s /etc/xdg/menus/plasma-applications.menu /etc/xdg/menus/applications.menu
XDG_MENU_PREFIX=arch- kbuildsycoca6
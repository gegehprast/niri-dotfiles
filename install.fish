#!/usr/bin/env fish

read -P "Do you want to install/update/reinstall the packages listed in packages.fish? (yes/NO): " confirmation
if test "$confirmation" = yes
    fish packages.fish
else
    echo "Skipping package installation."
end

read -P "Do you want to copy .config and .local folders to home directory? (yes/NO): " confirmation

if test "$confirmation" = yes
    cp -rf .config/ ~/
    cp -rf .local/ ~/
else
    echo "Skipping .config and .local copy."
end

read -P "Do you want to copy wallpapers to Pictures directory? (yes/NO): " confirmation

if test "$confirmation" = yes
    mkdir -p ~/Pictures/Wallpapers
    cp -rf wallpapers/* ~/Pictures/Wallpapers/
else
    echo "Skipping wallpapers copy."
end

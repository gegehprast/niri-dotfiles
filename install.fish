#!/usr/bin/env fish

echo "Installing packages..."
fish packages.fish

echo --------------------------------------------
echo "Copying .config and .local folders to home directory..."
read -P "This will overwrite your existing .config and .local folders. Do you want to continue? (yes/NO): " confirmation

if test "$confirmation" = yes
    cp -rf .config/ ~/
    cp -rf .local/ ~/
else
    echo "Config and local files not copied."
end

echo --------------------------------------------
echo "Copying wallpapers to Pictures directory..."
mkdir -p ~/Pictures/Wallpapers
cp -rf wallpapers/* ~/Pictures/Wallpapers/

echo ok

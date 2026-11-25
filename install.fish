#!/usr/bin/env fish

echo "Installing packages..."
fish packages.fish
echo "Packages installed."

echo "Stowing configuration files..."
stow --no-folding .
echo "Configuration files stowed."

# KDE apps (Dolphin, thumbnailer) read the icon theme from kdeglobals, not qt6ct.
# Without this they fall back to Breeze, recolored with the accent color.
echo "Setting KDE icon theme..."
kwriteconfig6 --file kdeglobals --group Icons --key Theme Papirus-Dark
rm -rf ~/.cache/thumbnails/*

echo "Setup complete!"

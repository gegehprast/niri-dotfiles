#!/usr/bin/env fish

echo "Installing packages..."
fish packages.fish
echo "Packages installed."

echo "Stowing configuration files..."
stow .
echo "Configuration files stowed."

echo "Setup complete!"

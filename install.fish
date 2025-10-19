#!/usr/bin/env fish

# Ask for confirmation
read -P "This will overwrite your existing .config and .local folders. Do you want to continue? (yes/NO): " confirmation

if test "$confirmation" != yes
    echo "Operation cancelled."
    exit 0
end

cp -rf .config/ ~/
cp -rf .local/ ~/

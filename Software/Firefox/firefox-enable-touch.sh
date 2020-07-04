#!/usr/bin/env bash

# Create a user shortcut
cp /usr/share/applications/firefox.desktop ~/.local/share/applications/firefox.desktop
sed -i "s|Exec=|Exec=env MOZ_USE_XINPUT2=1 |g" ~/.local/share/applications/firefox.desktop

# Create a global shortcut (Changes on every update)
# sudo sed -i "s|Exec=|Exec=env MOZ_USE_XINPUT2=1 |g" /usr/share/applications/firefox.desktop

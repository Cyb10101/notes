#!/usr/bin/env bash

# Create a user shortcut
cp /snap/firefox/current/firefox.desktop ~/.local/share/applications/firefox.desktop
sed -i "s|Exec=|Exec=env MOZ_USE_XINPUT2=1 |g" ~/.local/share/applications/firefox.desktop
sed -i "s|Name=|Name=Cyb |g" ~/.local/share/applications/firefox.desktop
sed -i "s|Icon=|Icon=/snap/firefox/current|g" ~/.local/share/applications/firefox.desktop

# Create a global shortcut (Changes on every update)
# sudo sed -i "s|Exec=|Exec=env MOZ_USE_XINPUT2=1 |g" /usr/share/applications/firefox.desktop

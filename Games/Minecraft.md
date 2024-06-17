# Minecraft

## Installation

```bash
sudo flatpak install -y flathub com.mojang.Minecraft

# Do not show pause menu on window change
sed -i -r "s/^(pauseOnLostFocus:)true$/\1false/g" ~/.var/app/com.mojang.Minecraft/.minecraft/options.txt
```

## Ingame

| Key  | Description |
| ---- | ----------- |
| t    | Chat        |
| F3   | Show Data   |

```yml
Creative mode: /gamemode cyb10101 1
Fly: /fly

Set home:
    - /sethome Cyb10101
    - /sethome home
Teleport:
    - /home Cyb10101
```

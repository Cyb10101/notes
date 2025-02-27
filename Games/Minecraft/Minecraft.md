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

```yaml
Creative mode: /gamemode cyb10101 1
Fly: /fly

Set home:
    - /sethome Cyb10101
    - /sethome home
Teleport:
    - /home Cyb10101
```

## Bedrock Server

* [Bedrock Server](https://www.minecraft.net/de-de/download/server/bedrock)

Install:

```bash
# Download script
wget -O start.sh https://raw.githubusercontent.com/Cyb10101/notes/master/Games/Minecraft/bedrock-start.sh

# Adjust environment variables `VERSION` and maybe `USER_AGENT` in start.sh

# Make it executable
chmod +x start.sh

# Install server
./start.sh install

# Run server
./start.sh run
```

Adjust server configuration or add a world from downloaded copy.

Downloaded world could be here:

* `C:\Users\Username\AppData\Local\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang\minecraftWorlds`

Create a service:

```bash
# Create a service
cat << EOF | sudo tee /etc/systemd/system/minecraft.service > /dev/null
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=${USER}
WorkingDirectory=/home/${USER}/opt/minecraft-server
ExecStart=/home/${USER}/opt/minecraft-server/start.sh run
Restart=always
RestartSec=30
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Reload daemon
sudo systemctl daemon-reload

# Enable and start service
sudo systemctl enable minecraft
sudo systemctl start minecraft

# Stop and disable service
sudo systemctl stop minecraft
sudo systemctl disable minecraft

# Check service status
sudo systemctl status minecraft

# Live logs
sudo journalctl -fu minecraft
```

## Paper Server

* [Paper: Download](https://papermc.io/downloads/paper)
* [Paper: Documentation](https://docs.papermc.io/paper)

Files:

* [papermc-server.sh](papermc-server.sh)
* [papermc-server.cmd](papermc-server.cmd)

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

```bash
# Create a start script
cat <<EOF | tee ~/opt/bedrock-server/run.sh > /dev/null
#!/usr/bin/env bash

scriptPath="\$(cd "\$(dirname "\${0}")" >/dev/null 2>&1; pwd -P)"
cd "\${scriptPath}"

LD_LIBRARY_PATH=. ./bedrock_server
EOF

# Make it executable
chmod +x ~/opt/bedrock-server/run.sh

# Create a service
cat << EOF | sudo tee /etc/systemd/system/minecraft.service > /dev/null
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=${USER}
WorkingDirectory=/home/${USER}/opt/bedrock-server
ExecStart=/home/${USER}/opt/bedrock-server/run.sh
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

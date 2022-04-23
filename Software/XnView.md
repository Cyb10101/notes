# XnView MP

## Installation

```bash
aria2c --download-result=hide --dir=/tmp -o XnViewMP.deb https://download.xnview.com/XnViewMP-linux-x64.deb
sudo dpkg -i /tmp/XnViewMP.deb
sudo apt install -f
```

## Configuration

Tools > Settings...

```bash
sudo apt -y install crudini

# Ask close XnView
crudini --set ~/.config/xnviewmp/xnview.ini '%General' showAgain 65536

# Thumbnail
crudini --set ~/.config/xnviewmp/xnview.ini 'Appearance' overlayIcons 63743
crudini --set ~/.config/xnviewmp/xnview.ini 'Appearance' thumbLabels "1 2 7 "

# Disable save session
crudini --set ~/.config/xnviewmp/xnview.ini 'Start' session '@Invalid()'
crudini --set ~/.config/xnviewmp/xnview.ini 'Start' sessionFlag 2

# General > Tab: General > File startup mode = Normal
crudini --set ~/.config/xnviewmp/xnview.ini '%General' confirmDel false

# General > Tab: File operations > Confirm file delete = false
crudini --set ~/.config/xnviewmp/xnview.ini 'Start' startInFull 0

# View > Tab: View > High quality zoom = Zoom-out & Zoom-in
crudini --set ~/.config/xnviewmp/xnview.ini 'Viewer' zoomQuality 3

# View > Tab: View > Auto image size > Fit image to window
crudini --set ~/.config/xnviewmp/xnview.ini 'Viewer' defaultFit 2

# Fullscreen > Tab: Fullscreen > Auto image size > Fit image to window
crudini --set ~/.config/xnviewmp/xnview.ini 'Viewer' defaultFullscreenFit 2

# Fullscreen > Tab: Fullscreen > Show informations = false
crudini --set ~/.config/xnviewmp/xnview.ini 'Viewer' useInfo false

# Fullscreen > Tab: Fullscreen > Auto show areas = false
crudini --set ~/.config/xnviewmp/xnview.ini 'Viewer' fullFloatView false
```

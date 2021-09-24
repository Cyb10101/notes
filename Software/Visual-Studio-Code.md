# Visual Studio Code

* [Visual Studio Code](https://code.visualstudio.com/)

Ctrl + Shift + P = Powerbar / Command Palette

## Extensions

*Note: Restard needed!*

```bash
# Theme: One Dark Pro (Powerbar > Preferences: Color Theme)
code --install-extension zhuangtongfa.material-theme

# German: (Powerbar > Configure Display Language)
code --install-extension ms-ceintl.vscode-language-pack-de

# Docker
code --install-extension ms-azuretools.vscode-docker

# Live Share
code --install-extension ms-vsliveshare.vsliveshare

# Language: Twig
code --install-extension mblode.twig-language-2

# Language: Apache Conf
code --install-extension mrmlnc.vscode-apache

# Language: PHP
code --install-extension bmewburn.vscode-intelephense-client
```

## Configuration

File > Preferences > Settings > User

```json
{
  "editor.renderWhitespace": "all",
  "files.autoSave": "onFocusChange",
  "window.openFoldersInNewWindow": "on",
  "window.newWindowDimensions": "inherit",
  "window.zoomLevel": 0.3
}
```

File > Preferences > Keyboard shortcuts

* Toggle Line Comment = Ctrl + Numpad-/ (German: Zeilenkommentar umschalten)

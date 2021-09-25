# Visual Studio Code

* [Visual Studio Code](https://code.visualstudio.com/)

Ctrl + , = Settings
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

# Language: Markdown
code --install-extension yzhang.markdown-all-in-one

# Activitybar: Workspace sidebar
code --install-extension sketchbuch.vsc-workspace-sidebar

# Shortcut menu
code --install-extension jerrygoyal.shortcut-menu-bar
```

## Configuration

File > Preferences > Settings > User

```json
{
  "terminal.integrated.fontSize": 15,
  "editor.fontSize": 15,
  "debug.console.fontSize": 15,
  "markdown.preview.fontSize": 15,

  "editor.copyWithSyntaxHighlighting": false,
  "editor.minimap.enabled": false,
  "editor.renderWhitespace": "all",
  "files.autoSave": "onFocusChange",
  "window.newWindowDimensions": "inherit",
  "window.openFoldersInNewWindow": "on",
  "workbench.colorTheme": "One Dark Pro",
  "workbench.editor.untitled.hint": "hidden",
  "workbench.startupEditor": "newUntitledFile",

  "ShortcutMenuBar.newFile": true,
  "ShortcutMenuBar.openFilesList": false,
  "ShortcutMenuBar.toggleTerminal": false,

  "workspaceSidebar.depth": 2
}
```

File > Preferences > Keyboard shortcuts

* Toggle Line Comment = Ctrl + Numpad-/ (German: Zeilenkommentar umschalten)

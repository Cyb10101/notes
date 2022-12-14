# Visual Studio Code

* [Visual Studio Code](https://code.visualstudio.com/)

Ctrl + , = Settings

Ctrl + Shift + P = Powerbar / Command Palette

Ctrl + D = Multi selection

Alt + Shit + Arrow-Key = Multi selection

## Extensions

*Note: Restard needed!*

```bash
# Theme: One Dark Pro (Powerbar > Preferences: Color Theme)
code --install-extension zhuangtongfa.material-theme

# German: (Powerbar > Configure Display Language)
code --install-extension ms-ceintl.vscode-language-pack-de
code --locale=de

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

# Language: Windows Registry Script
code --install-extension ionutvmi.reg

# Language: Better Shell Syntax (Highlighting)
code --install-extension jeff-hykin.better-shellscript-syntax

# Language: C++
code --install-extension ms-vscode.cpptools

# Activitybar: Workspace sidebar
code --install-extension sketchbuch.vsc-workspace-sidebar

# Shortcut menu
code --install-extension jerrygoyal.shortcut-menu-bar

# Todo Tree
code --install-extension gruntfuggly.todo-tree

# Unique Lines
code --install-extension bibhasdn.unique-lines

# Rest Client
code --install-extension humao.rest-client

# Markdown Editor
code --install-extension zaaack.markdown-editor
```

## Configuration

* Powerbar > Preferences: Open Settings (JSON)
* Or: File > Preferences > Settings > User

```json
{
  "terminal.integrated.fontSize": 15,
  "editor.fontSize": 15,
  "debug.console.fontSize": 15,
  "markdown.preview.fontSize": 15,

  "editor.copyWithSyntaxHighlighting": false,
  "editor.minimap.enabled": false,
  "editor.renderWhitespace": "all",
  "editor.scrollBeyondLastLine": false,
  "extensions.ignoreRecommendations": true,
  "files.autoSave": "onFocusChange",
  "window.newWindowDimensions": "inherit",
  "window.openFilesInNewWindow": "on",
  "window.openFoldersInNewWindow": "on",
  "workbench.colorTheme": "One Dark Pro",
  "workbench.editor.untitled.hint": "hidden",
  "workbench.startupEditor": "newUntitledFile",

  "todo-tree.highlights.useColourScheme": true,
  "todo-tree.regex.regexCaseSensitive": false,
  "todo-tree.regex.regex": "(//|#|<!--|;|/\\*|^|^[ \\t]*(-|\\d+.))\\s*@?($TAGS)",

  "ShortcutMenuBar.navigateBack": false,
  "ShortcutMenuBar.navigateForward": false,
  "ShortcutMenuBar.newFile": true,
  "ShortcutMenuBar.openFilesList": false,
  "ShortcutMenuBar.toggleTerminal": false,

  "workspaceSidebar.depth": 2,
  "search.exclude": {
    "**/cache": true,
    "**/var": true,
    "public/build": true
  }
}
```

File > Preferences > Keyboard shortcuts

* Toggle Line Comment = Ctrl + Numpad-/ (German: Zeilenkommentar umschalten)

* Or: Powerbar > Preferences: Open Keyboard Shortcuts (JSON)

```json
[
    {
        "key": "ctrl+numpad_divide",
        "command": "editor.action.commentLine",
        "when": "editorTextFocus && !editorReadonly"
    },
    {
        "key": "ctrl+shift+7",
        "command": "-editor.action.commentLine",
        "when": "editorTextFocus && !editorReadonly"
    }
]
```

## Maximum file watches exceeded

```bash
cat /proc/sys/fs/inotify/max_user_watches
```

Edit `sudo gedit /etc/sysctl.conf`:

```text
# Maximum file watches to 512 MB (Visual Studio Code)
fs.inotify.max_user_watches=524288
```

Reload: `sudo sysctl -p`

# Visual Studio Code

* [VSCodium](https://vscodium.com/)
* [Visual Studio Code](https://code.visualstudio.com/)

Ctrl + , = Settings

Ctrl + Shift + P = Powerbar / Command Palette
Ctrl + P = Switch files

Ctrl + D = Multi selection
Ctrl + U = Revert Multi selection

Alt + Shift + Arrow-Key = Multi selection

## Difference VSCodium

VSCodium is a community-driven, freely-licensed binary distribution of Microsoft’s editor VS Code.

This may not working:

* Property Extension
* VS Code Remote Development
* Debugger: C#

## Codium alias

```bash
alias code=codium
```

## Extensions

*Note: Restard needed!*

```bash
# Theme: One Dark Pro (Powerbar > Preferences: Color Theme)
code --install-extension zhuangtongfa.material-theme

# German: (Powerbar > Configure Display Language)
code --install-extension ms-ceintl.vscode-language-pack-de
code --locale=de

# Shortcut menu
code --install-extension jerrygoyal.shortcut-menu-bar

# ----------------------------------------------------------

# Language: Apache Conf
#code --install-extension mrmlnc.vscode-apache

# Language: Twig
code --install-extension mblode.twig-language-2

# Language: PHP
code --install-extension bmewburn.vscode-intelephense-client

# Language: Markdown
code --install-extension yzhang.markdown-all-in-one

# Language: Windows Registry Script
code --install-extension ionutvmi.reg

# Language: Better Shell Syntax (Highlighting)
code --install-extension jeff-hykin.better-shellscript-syntax

# Todo Tree
code --install-extension gruntfuggly.todo-tree

# Unique Lines
# code --install-extension bibhasdn.unique-lines
code --install-extension earshinov.filter-lines
code --install-extension earshinov.simple-alignment
code --install-extension earshinov.sort-lines-by-selection
code --install-extension earshinov.permute-lines

# Rest Client
code --install-extension humao.rest-client

# Markdown Editor
code --install-extension zaaack.markdown-editor

# Hex Editor
code --install-extension ms-vscode.hexeditor

# Language: C++
code --install-extension ms-vscode.cpptools

# Emoji
code --install-extension Perkovec.emoji

# Live Share
code --install-extension ms-vsliveshare.vsliveshare

# Show trailing space
code --install-extension shardulm94.trailing-spaces
```

## Configuration

* Powerbar > Preferences: Open User Settings (JSON)
* Or: File > Preferences > Settings > User

```json
{
  "terminal.integrated.fontSize": 15,
  "editor.fontSize": 15,
  "editor.stickyScroll.enabled": false,
  "debug.console.fontSize": 15,
  "markdown.preview.fontSize": 15,

  "editor.copyWithSyntaxHighlighting": false,
  "editor.minimap.enabled": false,
  "editor.renderWhitespace": "all",
  "editor.scrollBeyondLastLine": false,
  "extensions.ignoreRecommendations": true,
  "files.autoSave": "onFocusChange",
  "files.defaultLanguage": "markdown",
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

## Find open files

```bash
sudo apt install sqlite3 jq fzf
# sudo apt install sqlitebrowser

# Set workspace folder
workspaceFolder=~/.config/VSCodium/User/workspaceStorage

# Find workspace
while IFS='' read -r file || [ -n "$file" ]; do \
  workspaceId=$(basename $(dirname "$file")); \
  jq -r --arg workspaceId "$workspaceId" '"\($workspaceId), Workspace: \(.workspace), Folder: \(.folder)"' "$file"; \
done < <(find $workspaceFolder -type f -iname 'workspace.json') | fzf -m

# Set workspace id
workspaceId=1477316b0a355abac838497d011db1b7

# Get open files
sqlite3 $workspaceFolder/$workspaceId/state.vscdb "SELECT value FROM ItemTable WHERE key = 'memento/workbench.parts.editor';" \
  | jq -r '."editorpart.state".serializedGrid.root.data[].data.editors[].value' \
  | jq -r -s '.[].resourceJSON.path' | sed 's|^|* |'
```

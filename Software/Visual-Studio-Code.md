# Visual Studio Code

* [VSCodium](https://vscodium.com/)
* [Visual Studio Code](https://code.visualstudio.com/)

Ctrl + , = Settings

Ctrl + Shift + P = Powerbar / Command Palette

Ctrl + D = Multi selection
Ctrl + U = Revert Multi selection

Alt + Shift + Arrow-Key = Multi selection

## Difference VSCodium

VSCodium is a community-driven, freely-licensed binary distribution of Microsoft’s editor VS Code.

This may not working:

* Property Extension
* VS Code Remote Development
* Debugger: C#

## Extensions

*Note: Restard needed!*

```bash
binCode=$(which codium)
binCode=$(which code)

# Theme: One Dark Pro (Powerbar > Preferences: Color Theme)
${binCode} --install-extension zhuangtongfa.material-theme

# German: (Powerbar > Configure Display Language)
${binCode} --install-extension ms-ceintl.vscode-language-pack-de
${binCode} --locale=de

# Shortcut menu
${binCode} --install-extension jerrygoyal.shortcut-menu-bar

# ----------------------------------------------------------

# Language: Apache Conf
#${binCode} --install-extension mrmlnc.vscode-apache

# Language: Twig
${binCode} --install-extension mblode.twig-language-2

# Language: PHP
${binCode} --install-extension bmewburn.vscode-intelephense-client

# Language: Markdown
${binCode} --install-extension yzhang.markdown-all-in-one

# Language: Windows Registry Script
${binCode} --install-extension ionutvmi.reg

# Language: Better Shell Syntax (Highlighting)
${binCode} --install-extension jeff-hykin.better-shellscript-syntax

# Todo Tree
${binCode} --install-extension gruntfuggly.todo-tree

# Unique Lines
# ${binCode} --install-extension bibhasdn.unique-lines
${binCode} --install-extension earshinov.filter-lines
${binCode} --install-extension earshinov.simple-alignment
${binCode} --install-extension earshinov.sort-lines-by-selection
${binCode} --install-extension earshinov.permute-lines

# Rest Client
${binCode} --install-extension humao.rest-client

# Markdown Editor
${binCode} --install-extension zaaack.markdown-editor

# Hex Editor
${binCode} --install-extension ms-vscode.hexeditor

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

# Atom

https://atom.io

```bash
wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
sudo apt update
sudo apt install atom
```

## Shortcuts

```text
Ctrl + D = Multi selection: Words
Ctrl + Leftclick = Multi selection: Cursor
```

## Plugins

```bash
apm install tool-bar tool-bar-main
apm install file-icons file-watcher
apm install sort-lines
apm install atom-beautify

# Package Settings > Open preview pane automatically when opening a markdown file = false
# Package Settings > Preview Theme = one-dark.css
apm install markdown-preview-enhanced

# Programming languages
apm install language-batchfile language-powershell
```

## Optional plugins

```bash
apm install autocomplete-paths
apm install emmet
apm install git-plus git-blame
#apm install git-plus-toolbar
apm install linter linter-jshint linter-eslint linter-jscs linter-csslint linter-sass-lint
apm install markdown-preview-plus
apm install show-invisibles-plus
```

## Settings

* Atom > Settings > Autocomplete plus > Settings
  - Keymap for confirming a suggestion = Tab always, enter when suggestion explicitly selected

### Windows Compile C/C++

```bash
apm install gpp-compiler
```

http://www.mingw.org/

```text
MingGW installer > Basic Setup > Packages: mingw32-base, mingw32-gcc-g++
```

```bash
# Set environment variables: Start > Control Panel\System and Security\System > Advanced System Settings > Environment Variables > Path
setx PATH "%PATH%;C:\MinGW\bin"
```

* Restart system
* Press F5 to compile script

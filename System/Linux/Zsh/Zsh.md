# Zsh shell

* [themes/cyb.zsh-theme](themes/cyb.zsh-theme)
* [.zshrc](.zshrc)

## Install Zsh

```bash
sudo apt update
sudo apt -y install zsh

git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
mkdir -p ~/.oh-my-zsh/custom/themes

# Optional: Compare template
meld -n ~/Sync/notes/System/Linux/Zsh/.zshrc ~/.oh-my-zsh/templates/zshrc.zsh-template &

# Copy custom settings
cp ~/Sync/notes/System/Linux/Zsh/themes/cyb.zsh-theme ~/.oh-my-zsh/custom/themes/cyb.zsh-theme
cp ~/Sync/notes/System/Linux/Zsh/.zshrc ~/.zshrc

# Change login shell permanently
chsh -s $(which zsh)
```

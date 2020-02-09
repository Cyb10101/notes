# Zsh shell

## Install Zsh

```bash
sudo apt update
sudo apt install zsh

git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
vim ~/.zshrc
mkdir -p ~/.oh-my-zsh/custom/themes
vim ~/.oh-my-zsh/custom/themes/cyb.zsh-theme
```

## Change login shell permanently

```bash
chsh -s $(which zsh)
```

## Konfiguration

See [.zshrc](.zshrc)

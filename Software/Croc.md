# Croc

* [Croc](https://schollz.com/tinker/croc6/)
* [Github](https://github.com/schollz/croc)

## Config

* Linux: `gedit ~/.config/croc/send.json`
* Windows: `notepad "$env:userprofile\.config\croc\send.json"`

```json
{
  "RelayAddress": "example.org",
  "RelayWebsocketPort": [9009, 9010, 9011, 9012, 9013],
  "RelayPassword": "relay-password"
}
```

## Linux

```bash
alias croc-app='croc --relay "example.org" --pass="relay-password"'
croc-app send <files>
```

## Windows

Add a new file:

```shell
# Set execution policy to allow user script
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Add a new file
if (!(Test-Path $PROFILE.CurrentUserCurrentHost)) {
    New-Item -ItemType File -Path $PROFILE.CurrentUserCurrentHost -Force
}

# Edit file
notepad $PROFILE.CurrentUserCurrentHost
```

File `$PROFILE.CurrentUserCurrentHost`:

```shell
function croc-app {
    $defaultArguments = @('--relay', 'example.org', '--pass', 'relay-password')
    $arguments = $defaultArguments + $args
    & C:\Users\$env:username\scoop\apps\croc\current\croc $arguments
}
```

Run `croc-app send <files>`.

# SSH

## Konfiguration

Konfiguration auf Client:

vim ~/.ssh/config
	ForwardAgent yes

Konfiguration auf Server:

vim /etc/ssh/ssh_config
	AllowAgentForwarding yes

## Snippets

```bash
# Generate SSH Key
ssh-keygen -t rsa -b 4096 -C 'user@example.org'

# Run SSH Agent + add key 10h
eval `ssh-agent -s` && ssh-add -t 36000 ~/.ssh/id_rsa

# Run SSH Agent
eval `ssh-agent -s`

# Add SSH Key to SSH Agent
ssh-add -t 3600
ssh-add -t 3600 ~/.ssh/id_rsa

# SSH verbinden und Befehl ausführen
ssh {hostname} cat /etc/issue
```

### Connect through public 8.8.8.12 to internal 192.168.178.21

```text
Host proxy-to-intern
	ProxyCommand ssh -A proxyExternalUsername@8.8.8.12 -W %h:%p
	Hostname 192.168.178.21
	User internalUsername
```

## Generate Putty Key <-> OpenSSH Key

```bash
sudo apt-get install putty-tools

# Putty Key -> OpenSSH Key
puttygen id_rsa.ppk -O private-openssh -o id_rsa
puttygen id_rsa.ppk -O public-openssh -o id_rsa.pub

chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

# OpenSSH Key -> Putty Key
puttygen id_rsa -o id_rsa.ppk
```

### Putty Configuration

* Connection > Data > Login details > Auto-login username
* Connection > SSH > Auth > Private key file for authentication

## Known issues

### Spoofing - Warning: the ECDSA host key for 'server' differs from the key for the IP address 'ip'
ssh-keygen -R {host}
ssh-keygen -R {ip}

### WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!
ssh-keygen -R {serverName|serverIP}

# Docker: Installation

[Docker on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

## Docker installation

From Ubuntu repository:

```bash
sudo apt install docker.io
```

From Docker repository:

```bash
# Uninstall old versions
sudo apt remove docker docker-engine docker.io containerd runc

# Install using the repository
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce
```

Only if your want run it for another user than root:

```bash
sudo usermod -aG docker ${USER}
```

## Docker Compose installation

[Docker Compose Releases](https://github.com/docker/compose/releases)

```bash
VERSION=$(curl -fsSL https://api.github.com/repos/docker/compose/releases/latest | jq -r '.name')
curl -o /tmp/docker-compose -fsSL "https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m)"
sudo install /tmp/docker-compose /usr/local/bin/docker-compose
```

## Test Docker

```bash
docker run ubuntu /bin/echo 'hello world'
docker run -ti ubuntu /bin/bash
```

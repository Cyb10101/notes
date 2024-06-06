# Docker: Installation

* [Docker on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
* [Docker Compose releases](https://github.com/docker/compose/releases)

Install Docker from Ubuntu repository:

```bash
sudo apt -y install docker.io
```

Install Docker from Docker repository:

```bash
# Uninstall old versions
sudo apt remove docker docker-engine docker.io containerd runc

# Install using the repository
sudo apt install ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

sudo apt update
sudo apt -y install docker-ce docker-ce-cli containerd.io
```

If you want run Docker from another user than root:

```bash
sudo usermod -aG docker ${USER}
```

Install Docker Compose:

```bash
sudo apt -y install jq
VERSION=$(curl -fsSL https://api.github.com/repos/docker/compose/releases/latest | jq -r '.name')
curl --progress-bar -o /tmp/docker-compose -fL "https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m)"
sudo install /tmp/docker-compose /usr/local/bin/docker-compose
```

## Test Docker

```bash
docker run ubuntu /bin/echo 'hello world'
docker run -ti ubuntu /bin/bash
```

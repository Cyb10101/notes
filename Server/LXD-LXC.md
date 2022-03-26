# LXD/LXC

* [Linux containers LXD](https://linuxcontainers.org/lxd/introduction/)

Console in background: Ctrl + a, q

```bash
# Install
sudo snap install lxd
sudo lxd init --minimal

# Images (optional)
lxc image list
lxc image copy ubuntu:20.04 local: --alias focal

# Create container
lxc launch images:ubuntu/20.04 <container>
lxc exec <container> -- passwd ubuntu
lxc console <container>

# Configure not tested
# lxc launch images:ubuntu/20.04 ubuntu-limited -c limits.cpu=1 -c limits.memory=192MiB
# lxc launch images:ubuntu/20.04 ubuntu-config < config.yaml
# lxc config set <container> <option_key>=<option_value> <option_key>=<option_value> ..

# Export & import backup
#lxc stop <container>
#lxc snapshot <container>
lxc export <container> [file.tar.gz]
lxc import <file.tar.gz> <container>
lxc start <container>

# Remove container
lxc stop <container>
lxc delete <container>
```

Mixed network untested:

```bash
lxc config show ${CONTAINER_NAME}

lxc config device add ${CONTAINER_NAME} enp0s3 nic nictype=routed
lxc config device remove ${CONTAINER_NAME} enp0s3
lxc config device remove ${CONTAINER_NAME} eth0

lxc stop ${CONTAINER_NAME}
lxc config device remove ${CONTAINER_NAME} eth0
lxc config device override ${CONTAINER_NAME} eth0
lxc config device set ${CONTAINER_NAME} eth0 ipv4.address=10.145.59.200
lxc start ${CONTAINER_NAME}
sleep 3
lxc list --columns ns4
```
# Linux: Secure Boot

## Import machine key

```bash
# Test if key is enrolled
sudo mokutil --test-key /var/lib/shim-signed/mok/MOK.der

# Enroll key on next boot
sudo mokutil --import /var/lib/shim-signed/mok/MOK.der
```

## Module signing for drivers

*Note: Maybe not needed again!*
*Note: Must be run after new kernel update!*

@todo [Linux Secure Boot: Module signing should go automatically](https://github.com/Cyb10101/notes/issues/1)

When the secure boot has been activated, some drivers have to be signed.

See file: [module-signing.sh](module-signing.sh)

Modules:

* evdi: DisplayLink
* vboxdrv: VirtualBox

## Bugfix: Failed to find module evdi

```bash
sudo apt install evdi-dkms
```

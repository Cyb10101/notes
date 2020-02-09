# Steam

## Bugfix: Controller is not recognized in Ubuntu 16.04

```bash
sudo vim /lib/udev/rules.d/99-steam-controller-perms.rules
```

```text
# Valve USB devices
SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"
# Steam Controller udev write access
KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess"
# HTC Vive HID Sensor naming and permissioning

# Valve HID devices over USB hidraw
KERNEL=="hidraw*", ATTRS{idVendor}=="28de", MODE="0666"

# Valve HID devices over bluetooth hidraw
KERNEL=="hidraw*", KERNELS=="*28DE:*", MODE="0666"
```

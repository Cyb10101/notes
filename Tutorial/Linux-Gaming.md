# Linux Gaming

Gaming on Linux has improved a bit.
But still requires sometimes background knowledge.

**Operating System / Distribution:**
I assume that you have already found your Linux distribution and you have some knowledge. Otherwise, I mostly recommend [Ubuntu](https://ubuntu.com/).

**Graphic Driver:**
The most important thing first. Usually nothing works without graphics drivers.

* [AMD](https://www.amd.com/) is way ahead and usually comes pre-installed in Ubuntu. Currently this is the best choice.
* [Nvidia](https://www.nvidia.com/) still has some catching up to do. However, drivers can possibly be easily installed via the system. At least if you're lucky.

If you are less lucky, you will have to find a driver and install it manually.
If you're extremely unlucky, you won't even be able to install a graphics driver.

**Display Server:**
The X11 (X Window System Version 11) is a tried and tested system.
However, you may find that you'll be able to play better with Wayland as it has been redesigned from the ground up.

**Linux Game Engines:**
What you want is a Linux compiled game and preferably delivered with a game client as a download.
There are some game engines that can compile binary files for Linux.
Unfortunately, it is usually up to the developers to do this.
These are a few game engines that I know of:

* [Godot](https://godotengine.org/)
* [Unreal Engine](https://unrealengine.com/)
* [Unity](https://unity.com/)
* [Unigine](https://unigine.com/)

**Game clients:**
Some game clients pleasantly offer games to download and launch.
That way, most of the time, you don't have to worry much about how things are going.

* [Itch](https://itch.io/app) (Native)
* [Steam](https://store.steampowered.com/) (Wine/Proton)

```bash
# Bugfix Itch Client don't start: ~/.itch/itch --in-progress-gpu --no-sandbox
sed -Ei "s/^(Exec=\/home\/\w+\/\.itch\/itch)\s+(%U)$/\1 --in-progress-gpu --no-sandbox \2/" ~/.local/share/applications/io.itch.itch.desktop
```

**Wine:**
For Windows games, Wine or Wine-based software is mostly used.
Keywords are Proton, Soda, Caffe, Lutris.
That means everyone does a bit of their own thing, but you have more chance of a game working.

* [Bottles](https://usebottles.com/) is a good way to start other versions of Wine.

Some Wine Databases:

* [Wine App Database](https://appdb.winehq.org/)
* [Proton Database](https://www.protondb.com/)

**DXVK (DirectX over Vulkan):**
The DXVK driver package is available for Windows games created with DirectX.
Most of the time it is enough to take a suitable wine/bottle, so you don't have to worry too much about it.

**FPS Limit:**
I like to recommend setting a frame limit. The reason is quite simple.
Firstly, it protects the processor and graphics card, because it makes no sense to run a game at 200 FPS, if the monitor can only do 60 FPS.
Secondly, it can make a jerky game run more smoothly.

**Audiophile/Videophile:**
If you're an audiophile and a videophile like me, you have a few more things to worry about.
Sometimes the best patch is sunglasses and some ear protectors.

## Bottles

* [Bottles](https://usebottles.com/)
* [Flatpak: Bottles](https://flathub.org/apps/details/com.usebottles.bottles)

```bash
flatpak install flathub com.usebottles.bottles
```

* Menü > Settings:
  * Runner
    * Soda (Newest)
  * DDL-Components
    * DXVK = 1.*, 2.*

* Bottle > Options: Settings
  * Components
    * soda = (Newest)
    * DXVK = (Newest)
    * VKD3D = (Newest)
  * Compatibility: Environment Variables
    * GALLIUM_HUD="simple,cpu+fps+temperature+buffer-wait-time"
    * DXVK_HUD="version,api,devinfo,fps,frametimes,gpuload"
    * DXVK_HUD="fps,frametimes,gpuload"
    * DXVK_FRAME_RATE=60
    * MANGOHUD=1
    * MANGOHUD_CONFIG="fps_limit=60,position=top-left,round_corners=4,wine,cpu_temp,gpu_temp,ram,vram,io_read,io_write,vulkan_driver,engine_version,gamemode,vkbasalt,show_fps_limit,resolution"

## Gallium

In-Game HUD.

```bash
GALLIUM_HUD="help" glxgears
GALLIUM_HUD="cpu+fps,temperature,buffer-wait-time" glxgears
GALLIUM_HUD="simple,cpu+fps+temperature+buffer-wait-time" glxgears

GALLIUM_HUD_TOGGLE_SIGNAL=10 GALLIUM_HUD_VISIBLE=false GALLIUM_HUD="cpu+fps,temperature,buffer-wait-time" glxgears
ps a | grep glxgears
kill -10 12345
```

## Mesa Vulkan

In-Game HUD.

```bash
sudo apt -y install vulkan-tools
VK_INSTANCE_LAYERS=VK_LAYER_MESA_overlay VK_LAYER_MESA_OVERLAY_CONFIG=position=top-left vkcube
```

## MangoHud (Vulkan)

In-Game HUD and FPS Limiter.

* [Mangohud](https://github.com/flightlessmango/MangoHud)
* Toggle the HUD: Right Shift + F12
* Toggle FPS limit: Shift Left + F1

```bash
sudo apt -y install mangohud vulkan-tools
MANGOHUD=1 MANGOHUD_CONFIG="fps_limit=60,position=top-left,round_corners=4,wine,cpu_temp,gpu_temp,ram,vram,io_read,io_write,vulkan_driver,engine_version,gamemode,vkbasalt,show_fps_limit,resolution" vkcube

# Position: top-left, top-right, middle-left, middle-right, bottom-left, bottom-right, top-center
```

## DXVK (DirectX over Vulkan)

In-Game HUD and FPS Limiter.

* [DXVK](https://github.com/doitsujin/dxvk)
* [DXVK: Wiki](https://github.com/doitsujin/dxvk/wiki)

```bash
DXVK_HUD="full"
DXVK_HUD="version,api,devinfo,fps,frametimes,gpuload"
DXVK_HUD="fps,frametimes,gpuload"
DXVK_HUD="fps,gpuload"

DXVK_FRAME_RATE=60
```

@todo DXVK_CONFIG_FILE=/home/user/dxvk.conf
@todo https://github.com/doitsujin/dxvk/blob/master/dxvk.conf

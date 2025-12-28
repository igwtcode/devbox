# archlinux

connect to internet during installation process

```bash
# get device name
ip -c a

iwctl --passphrase <passphrase> station <name> connect <SSID>

# or in iwctl
iwctl
device list
station <name> scan
station <name> get-networks
station <name> connect <SSID>
exit
```

after installation, on first run:

```bash
nmcli device wifi connect "<SSID>" password "<password>"
```

## system config

> [!IMPORTANT]
> Open the file `/etc/makepkg.conf` and search for the line that starts with `OPTIONS=`.
> Change `debug` to `!debug`. This prevents installing `*-debug` packages.

Check these in `/etc/pacman.conf`

```bash
Color
CheckSpace
VerbosePkgLists
ParallelDownloads = 15
ILoveCandy
```

## Tmux

- open tmux with `tmux`.
  If plugins are not auto installed on first run,
  press `Ctrl-a + I` to install all plugins.

## virtualbox

Read [arch wiki](https://wiki.archlinux.org/title/VirtualBox)

- update system with `yay -Syu` and reboot (when necessary)

- install virtualbox with

  ```bash
  yay -S virtualbox virtualbox-guest-iso

  # select the option: virtualbox-host-modules-arch
  ```

- reboot to load necessary kernel modules

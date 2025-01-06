# archlinux

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

## virtualbox

Read [arch wiki](https://wiki.archlinux.org/title/VirtualBox)

- update system with `yay -Syu` and reboot (when necessary)

- install virtualbox with

  ```bash
  yay -S virtualbox virtualbox-guest-iso

  # select the option: virtualbox-host-modules-arch
  ```

- reboot to load necessary kernel modules

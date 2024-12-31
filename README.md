# devbox

Tools and configurations

## Requirements

### mac

```bash
xcode-select --install
```

## Optional

### archlinux

Check these in `/etc/pacman.conf`

```bash
Color
CheckSpace
VerbosePkgLists
ParallelDownloads = 15
ILoveCandy
```

> [!TIP]
> Open the file `/etc/makepkg.conf` and search for the line that starts with `OPTIONS=`.
> Change `debug` to `!debug`. This prevents installing `*-debug` packages.

## Usage

```bash
./main.sh
```

## Post install

Open `tmux` and press `Ctrl-a + I` to install all plugins

## Hints

> [!TIP]
> To export brew packages to a text file: `brew leaves > brew.txt`

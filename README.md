# A setup
| Component | Name | Configuration | Theme |
|-|-|-|-|
| OS | Debian 12 | ---- | ---- |
| DE | ---- | ---- | ---- |
| WM | i3 |  [i3/config](https://github.com/Skalyaeve/a-linux-setup/blob/main/resource/ui/gui/i3/config)  | ---- |
| Shell | Bash |  [.bashrc](https://github.com/Skalyaeve/a-linux-setup/blob/main/resource/ui/terminal/bash/.bashrc)  | ---- |
| Terminal | Alacritty |  [alacritty.yml](https://github.com/Skalyaeve/a-linux-setup/blob/main/resource/ui/terminal/alacritty/alacritty.yml)  | ---- |
| IDE | Vim | [.vimrc](https://github.com/Skalyaeve/a-linux-setup/blob/main/resource/ui/ide/vim/.vimrc) | [a-vim-theme](https://github.com/Skalyaeve/a-vim-theme.git) |
| Browser | Firefox | ---- | [a-firefox-theme](https://github.com/Skalyaeve/a-firefox-theme.git) |

# A script
### Usage
```sh
setup <command> [options]
```

#### Commands
- `install`:
    * From a `resource` directory.
    * Install or update targets specified in `*.list` files.
    * Swap targets specified in `.swap` files.

- `restore`:
    * From a `backup` directory.
    * Perform backup using `diff` file.

#### Options:
- `-u`, `--user USER`:
    * Setup for the specified user's `$HOME` directory.
- `-p`, `--path PATH`:
    * Specify a path to a `resource` or `backup` directory.
    * Default is `~/.local/share/setup/(resource|backup)`
- `-e`, `--exclude DIR[S]`:
    * When `install`, exclude the specified directories.
- `-s`, `--silent`:
    * Run in silent mode.
- `-n`, `--ninja`:
    * When `install`, do not read `*.list` files.
- `--no-apt`:
    * When `install`, do not read `apt.list` files.
- `--no-web`:
    * When `install`, do not read `web.list` files.
- `--no-local`:
    * When `install`, do not read `.swap` files.


### Resource Directory
- Used by `install` command to know what to do.
- Backups stored at `$(dirname $resource)/backup`.
- Web resources stored at `$(dirname $resource)/.web`.

#### apt.list files
- 1 package per line:
- `<package_name> : [description]`
- `apt purge` and `apt clean` do not remove all files.
- Use `.aptclean` files to remove them when `restore`:
- `<package_name> : <absolute path>` ***strict format***.
- 1 path per line.

#### web.list files
- Bash commands.
- No multiline commands.
- Blocks to: install | update | remove.
```sh
#!/bin/bash

# <name> @ <url> ~ [description]
# $- INSTALL
    [commands]
# $---
# $- UPDATE
    [commands]
# $---
# $- REMOVE
    [commands]
# $---
# @@@@
```

#### .swap files
- 1 line per swap.
- Swap files/directories from `$(dirname .swap)`.
- To `cp` src instead of `ln -s`, add `no-link `.
- `[no-link ]<path from .swap file> @ <target DIRECTORY>`.

## Install
```sh
sudo apt update -y
sudo apt install git make curl -y

mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/share
mkdir -p $HOME/.local/src

dst=$HOME/.local/src
git clone https://github.com/Skalyaeve/a-linux-setup.git $dst/setup
cd $dst/setup
make install
# or
# make link_install
```
Edit your `$HOME/.local/share/setup/resource` directory, then:
```sh
export PATH=$HOME/.local/bin:$PATH
setup install
# or
# sudo ln -s $HOME/.local/bin/setup /bin/setup
# sudo setup install -u $USER
```

## Uninstall
```sh
count=$(ls $HOME/.local/share/setup/backup)
for _ in $count; do
    setup restore
    # or
    # sudo setup restore -u $USER
done
```
Then:
```sh
dir=$HOME/.local/src/setup
cd $dir
make uninstall
rm -r $dir
```

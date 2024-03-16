# A linux setup 
| Component | Description | Configuration | Theme |
|-|-|-|-|
| OS | Debian 12 | ---- | ---- |
| DE | ---- | ---- | ---- |
| WM | i3 |  [i3/config](https://github.com/Skalyaeve/a-linux-setup/blob/main/resource/ui/gui/i3/config)  | ---- |
| Shell | Bash |  [.bashrc](https://github.com/Skalyaeve/a-linux-setup/blob/main/resource/ui/terminal/bash/.bashrc)  | ---- |
| Term | Terminator |  [terminator/config](https://github.com/Skalyaeve/a-linux-setup/blob/main/resource/ui/terminal/terminator/config)  | ---- |
| IDE | Vim | [.vimrc](https://github.com/Skalyaeve/a-linux-setup/blob/main/resource/ui/ide/vim/.vimrc) | [a-vim-theme](https://github.com/Skalyaeve/a-vim-theme.git) |
| Browser | Firefox | ---- | [a-firefox-theme](https://github.com/Skalyaeve/a-firefox-theme.git) |

## A Script
- Regroup the different components of your linux setup in a single place.
- Manage your installations, updates, and configurations easier.
- Bring your shortcuts, environment and applications everywhere you go.

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
    * From a backup directory.
    * Perform backup using `diff` file.

#### Options:
- `-u, --user USER`:
    * Setup for the specified user's home directory.
- `-p, --path PATH`:
    * Specify a path to a `resource` or `backup` directory.
    * Default is `~/.local/share/setup/(resource|backup)`
- `-e, --exclude DIR[S]`:
    * When `install`, exclude the specified directories.
- `-s, --silent`:
    * Run in silent mode.
- `-n, --ninja`:
    * When `install`, do not read `*.list` files.
- `--no-apt`:
    * When `install`, do not read `apt.list` files.
- `--no-web`:
    * When `install`, do not read `web.list` files.
- `--no-local`:
    * When `install`, do not read `.swap` files.


### Resource Directory
- Used by `install` command to know what to do.
- Web resources stored at `$(dirname $resource)/.web`.
- Backups stored at `$(dirname $resource)/backup`.

#### apt.list files
- 1 package per line.
- `<package_name> : [description]`.

#### web.list files
- Bash commands.
- No multiline commands.
- Blocks to: install | update | remove.
```sh
<name> @ <url> : [description]
$- INSTALL
    [commands]
$---
$- UPDATE
    [commands]
$---
$- REMOVE
    [commands]
$---
@@@@
```

#### .swap files
- 1 line per swap.
- `<path from .swap file> @ <target DIRECTORY>`.

## Install
```sh
sudo apt update -y
sudo apt install git make curl -y

dst=$HOME/.local/src
mkdir -p $dst
git clone https://github.com/Skalyaeve/a-linux-setup.git $dst/setup
cd $dst/setup

make
make install # Or make link_install
setup # To print help
```
Edit your `$HOME/.local/share/setup/resource` directory, then:
```sh
setup install
# or
# sudo setup install -u $USER
```

## Uninstall
```sh
dir=$HOME/.local/share/setup
count=$(ls -1 $dir/backup | wc -l)
count=$(($count - 1))

for i in $(seq 0 $count); do
    setup restore
    # or
    # sudo setup restore -u $USER
done
```
Then:
```sh
dst=$HOME/.local/src
cd $dst/setup

make uninstall
rm -rf $dst/setup
cd
```

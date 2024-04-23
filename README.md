# A setup
### From
![](https://github.com/Skalyaeve/images-1/blob/main/screenshot/setup-from.png?raw=true)

### To
![](https://github.com/Skalyaeve/images-1/blob/main/screenshot/setup-to.png?raw=true)

| Component | Name | Conf | Binds |
|:-|:-|-:|-:|
| OS | Debian 12 | ---- | ---- |
| DE | ---- | ---- | ---- |
| WM | i3 | [config](https://github.com/Skalyaeve/a-setup/blob/main/resource/gui/i3/config) | [binds.conf](https://github.com/Skalyaeve/a-setup/blob/main/resource/gui/i3/binds.conf) |
| Shell | Bash | [.bashrc](https://github.com/Skalyaeve/a-setup/blob/main/resource/terminal/bash/.bashrc) | [.bash_aliases](https://github.com/Skalyaeve/a-setup/blob/main/resource/terminal/bash/.bash_aliases) |
| Terminal | Alacritty | [alacritty.yml](https://github.com/Skalyaeve/a-setup/blob/main/resource/terminal/alacritty/alacritty.yml) | [.inputrc](https://github.com/Skalyaeve/a-setup/blob/main/resource/terminal/bash/.inputrc)
| IDE | Neovim | [init.lua](https://github.com/Skalyaeve/a-setup/blob/main/resource/ide/nvim/init.lua) | [binds.lua](https://github.com/Skalyaeve/a-setup/blob/main/resource/ide/nvim/lua/binds.lua) |

# A script
- To quickly setup any Debian `home`/system
- To keep updated git/web resources
- To group your different tools and configurations

### Usage
```sh
setup <command> [options]
```

#### Commands
- `install`:
    * Running from a `resource` directory
    * Install apt packages via `.apt` files
    * Run `install.sh` scripts from `.script` dirs
    * Install local resources via `.swap` files

- `restore`:
    * Running from a `backup` directory
    * Uninstall apt packages via `diff` file
    * Run `remove.sh` scripts
    * Restore local resources via `diff` file

#### Options:
- `-u/--user <user>`:
    * `install`/`restore` for specified `<user>`
- `-p/--path <path>`:
    * Specify a path to `resource`/`backup` directory
    * Default: `~/.local/share/setup`
- `-e/--exclude <dir1> [dir2]...`:
    * When `install`, exclude the specified directories
- `--no-apt`:
    * When `install`, do not read `.apt` files
- `--no-script`:
    * When `install`, do not read `.script` files
- `--no-swap`:
    * When `install`, do not read `.swap` files
- `--no-backup`:
    * When `install`, do not create backup

#### .apt files:
- `<package_name> : [description]`
- 1 package per line

#### .script dirs:
- Per subdirectory:
    * 1 `install.sh` bash script
    * 1 optional `remove.sh` bash script
    * exit -1 = Do not copy `remove.sh` to backup

#### .swap files:
- Swap files/directories from `$(dirname .swap)`
- To `cp` src instead of `ln -s`, add `no-link `
- `[no-link ]<path from .swap file> @ <target DIRECTORY>`
- 1 line per swap

## Install
```sh
dst=~/.local/src
mkdir -p $dst
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/setup
mkdir -p ~/.config
git clone https://github.com/Skalyaeve/a-setup.git $dst/setup
cd $dst/setup
ln -s $PWD/setup.sh ~/.local/bin/setup
ln -s $PWD/resource ~/.local/share/setup/resource
```
Edit `resource` directory to your needs, then:
```sh
export PATH=$HOME/.local/bin:$PATH
setup install
```
or
```sh
sudo ln -s ~/.local/bin/setup /usr/local/bin/setup
sudo setup install -u $USER
```

## Backup
```sh
count=$(ls ~/.local/share/setup/backup)
for _ in $count; do
    setup restore
    # or
    # sudo setup restore -u $USER
done
```

## Uninstall
```sh
rm -rf ~/.local/share/setup
rm -rf ~/.local/src/setup
rm ~/.local/bin/setup
```

# Some tools
- [extract](https://github.com/Skalyaeve/a-setup/blob/main/resource/utils/bin/extract): Extract archives
- [setmenu](https://github.com/Skalyaeve/a-setup/blob/main/resource/utils/bin/setmenu): Set a [jgmenu csv](https://github.com/Skalyaeve/a-setup/blob/main/resource/gui/jgmenu/menu.csv) from a [directory](https://github.com/Skalyaeve/a-setup/blob/main/resource/gui/jgmenu/set/main)
- [gitpush](https://github.com/Skalyaeve/a-setup/blob/main/resource/utils/bin/extract): Commit and push repositories from a directory
- [codecount](https://github.com/Skalyaeve/a-setup/blob/main/resource/utils/bin/codecount): Count % of bytes for each file type in a directory

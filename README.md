# <p align="center">A setup</p>
### <p align="center">From</p>
<img align="center" src="https://github.com/Skalyaeve/images-1/blob/main/screenshot/setup-from.png?raw=true"></img>

### <p align="center">To</p>
<img align="center" src="https://github.com/Skalyaeve/images-1/blob/main/screenshot/setup-to.png?raw=true"></img>

<table align="center">
  <tr>
    <th>Component</th>
    <th>Name</th>
    <th>Conf</th>
    <th>Binds</th>
  </tr>
  <tr>
    <td>OS</td>
    <td>Debian 12</td>
    <td>----</td>
    <td>----</td>
  </tr>
  <tr>
    <td>DE</td>
    <td>----</td>
    <td>----</td>
    <td>----</td>
  </tr>
  <tr>
    <td>WM</td>
    <td>i3</td>
    <td><a href="https://github.com/Skalyaeve/a-setup/blob/main/resource/gui/i3/config">config</a></td>
    <td><a href="https://github.com/Skalyaeve/a-setup/blob/main/resource/gui/i3/binds.conf">binds.conf</a></td>
  </tr>
  <tr>
    <td>Shell</td>
    <td>Bash</td>
    <td><a href="https://github.com/Skalyaeve/a-setup/blob/main/resource/terminal/bash/.bashrc">.bashrc</a></td>
    <td><a href="https://github.com/Skalyaeve/a-setup/blob/main/resource/terminal/bash/.bash_aliases">.bash_aliases</a></td>
  </tr>
  <tr>
    <td>Terminal</td>
    <td>Alacritty</td>
    <td><a href="https://github.com/Skalyaeve/a-setup/blob/main/resource/terminal/alacritty/alacritty.yml">alacritty.yml</a></td>
    <td><a href="https://github.com/Skalyaeve/a-setup/blob/main/resource/terminal/bash/.inputrc">.inputrc</a></td>
  </tr>
  <tr>
    <td>IDE</td>
    <td>Neovim</td>
    <td><a href="https://github.com/Skalyaeve/a-setup/blob/main/resource/ide/nvim/init.lua">init.lua</a></td>
    <td><a href="https://github.com/Skalyaeve/a-setup/blob/main/resource/ide/nvim/lua/binds.lua">binds.lua</a></td>
  </tr>
</table>

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
- `-u`/`--user` `<user>`:
    * `install`/`restore` for specified `<user>`
- `-p`/`--path` `<path>`:
    * Specify a path to `resource`/`backup` directory
    * Default: `~/.local/share/setup`
- `-e`/`--exclude` `<dir1> [dir2]`...:
    * When `install`, exclude the specified directories
- `--no-apt`:
    * When `install`, do not read `.apt` files
- `--no-script`:
    * When `install`, do not read `.script` files
- `--no-swap`:
    * When `install`, do not read `.swap` files
- `--no-backup`:
    * When `install`, do not create backup

#### `.apt` files:
- `<package_name>`
- 1 package per line

#### `.script` dirs:
- Per subdirectory:
    * 1 `install.sh` bash scrip
        - `exit -1` = Up to date
    * 1 optional `remove.sh` bash script

#### `.swap` files:
- Swap files/directories from `$(dirname .swap)`
- To `cp` src instead of `ln -s`, add `no-link `
- `[no-link ]<path from .swap file> @ <target DIRECTORY>`
- 1 line per swap

## Install
```sh
# new $HOME ?-> ./init.sh
mkdir -p ~/.local/share/setup
git clone https://github.com/Skalyaeve/a-setup.git setup
cd setup
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

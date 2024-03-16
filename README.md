# A linux setup
> work in progress

## A Setup
| Component | Description |
| - | - |
| OS | Debian 12 |
| DE | ---- |
| WM | i3 |
| Shell | Bash |
| Term | Terminator |
| IDE | Vim |

## A Script
- Regroup the different components of your linux setup in a single place.
- Manage your installations, updates, and configurations easier.
- Bring your shortcuts, environment and applications everywhere you go.

```bash
setup <command> [options]
```

#### Commands
- `install`:
    * From a resource directory.
    * Install or update targets specified in *.list files.
    * Swap targets specified in .swap files.

- `restore`:
    * From a backup directory.
    * Perform backup using diff file.

#### Options:
- `-u, --user USER`:
    * Setup for the specified user's home directory.
- `-p, --path PATH`:
    * Specify a path to a resource or backup directory.
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
- Backups stored at `$(dirname $resource)/.backup`.

#### apt.list files
- 1 package per line.
`<package_name> : [description]`

#### web.list files
- Bash commands.
- No multiline commands.
- Blocks to: install | update | remove..
```
<name> @ <url> ~ [description]
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
`<path from .swap file> @ <target DIRECTORY>`

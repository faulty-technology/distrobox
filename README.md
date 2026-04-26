# distrobox

Declarative distrobox setup for Fedora Kinoite. Defines Ubuntu 24.04 containers with all tooling pre-installed via `distrobox assemble`.

## Containers

- **dev**: VS Code, Neovim, build tools, Node.js, Python
- **godot**: VS Code, Godot (.NET), .NET SDK

## Usage

```sh
./setup.sh            # create containers and export apps
./setup.sh --replace  # tear down and recreate
```

## Structure

- `distrobox.ini` - container definitions
- `hooks/` - per-container init scripts
- `setup.sh` - entrypoint

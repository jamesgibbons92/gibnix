# AGENTS.md - Development Guidelines for gibnix

This file provides guidance for AI coding agents working with this NixOS flake configuration.

## Repository Structure

```
gibnix/
├── flake.nix              # Main entry point - inputs and host definitions
├── hosts/                 # Host-specific NixOS configurations
│   ├── common/core/       # Shared system-level config
│   ├── common/optional/   # Optional modules (audio, vpn, gaming, etc.)
│   ├── common/users/      # User account and home-manager integration
│   ├── s14/               # "bajie" host configuration
│   ├── macbook/           # MacBook host configuration
│   └── erlang/            # WSL host configuration
├── home/                  # Home Manager configurations
│   ├── core/              # Base user config (shell, nvim, git)
│   ├── desktop/           # Desktop environment (Hyprland, waybar, rofi)
│   ├── dev/               # Development tools (go, js, docker)
│   └── hosts/             # Host-specific home-manager overrides
└── modules/               # Custom NixOS modules
```

## Build/Test Commands

### Using nh (Preferred)

```bash
nh os build -H <hostname> ~/gibnix    # Build only (validation)
```

### Other Commands

```bash
home-manager switch --flake .#james   # Home Manager only
nix flake check                       # Validate flake
nix flake update                      # Update all inputs
nix search nixpkgs <package>          # Search packages
```

## Current Hosts

| Hostname  | Directory        | Description           |
| --------- | ---------------- | --------------------- |
| `bajie`   | `hosts/s14/`     | S14 laptop (primary)  |
| `macbook` | `hosts/macbook/` | MacBook configuration |
| `erlang`  | `hosts/erlang/`  | WSL configuration     |

## Code Style Guidelines

### Nix Files (formatter: `alejandra`)

**Function arguments**: Attribute set destructuring

```nix
{
  pkgs,
  config,
  lib,
  ...
}: {
  # configuration
}
```

**Imports**: Group related imports, use relative paths

```nix
imports = [
  ./hardware-configuration.nix
  ../common/core
  ../common/optional/audio.nix
];
```

**Package lists**: Use `with pkgs;` or prefix each

```nix
home.packages = with pkgs; [
  vim
  wget
];
# Or when mixing sources:
home.packages = [
  pkgs.vim
  pkgs-unstable.some-package
];
```

**Naming**: lowercase with hyphens for files, camelCase for variables

### Lua Files (formatter: `stylua --indent-width 2 --indent-type Spaces`)

**Vim options**: Use `vim.o` for simple values, `vim.opt` for tables

```lua
vim.o.number = true
vim.opt.listchars = { tab = "» ", trail = "·" }
```

**Keymaps**: Always include description

```lua
vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = true })
end, { desc = "[F]ormat buffer" })
```

**Plugin config in Nix**: Use heredoc with lua comment

```nix
extraLuaConfig =
  /*
  lua
  */
  ''
    require("plugin").setup({ option = value })
  '';
```

## Important Conventions

- **Modularity**: Keep configs modular; optional features go in `hosts/common/optional/`
- **Hardware config**: Never manually edit `hardware-configuration.nix`
- **State versions**: Don't change `stateVersion` unless you understand implications
- **Secrets**: Never commit secrets; use environment variables
- **Testing**: Always use `nh os build` or `nix flake check` before switching

## Adding New Features

1. **Optional system feature**: Create `hosts/common/optional/<feature>.nix`
2. **User application**: Add to relevant `home/` subdirectory
3. **New host**: Create `hosts/<hostname>/` with `configuration.nix` and
   `hardware-configuration.nix`, then add entry to `flake.nix`
4. **Neovim plugin**: Add to `home/core/nvim/` with `.nix` and optional `.lua` file

## Key Dependencies

- **NixOS**: 25.11 (stable)
- **nixpkgs-unstable**: For bleeding-edge packages
- **home-manager**: release-25.11
- **nixos-hardware**: Hardware-specific optimizations
- **nixos-wsl**: WSL support for erlang host

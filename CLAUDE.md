# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a **flakes-based NixOS configuration** with modular organization and Home Manager integration. The system uses explicit host definitions in `flake.nix` rather than dynamic loading.

**Directory Structure:**
- `flake.nix` - Main entry point defining system configurations and inputs
- `hosts/` - Host-specific configurations organized by hostname
  - `hosts/common/core/` - Shared system-level configuration
  - `hosts/common/users/james/` - User-specific system configuration
  - `hosts/macbook/` - MacBook-specific configuration
  - `hosts/s14/` - S14 laptop configuration
- `home/` - Home Manager configuration modules
  - `home/core.nix` - Base user packages and imports
  - `home/desktop/` - Desktop environment (Hyprland) configuration
  - `home/nvim/` - Neovim configuration with LSP, formatting, themes
  - `home/shell/` - Shell configuration (tmux, zsh)
- `modules/` - Custom NixOS modules (currently minimal)

**Configuration Architecture:**
- Flakes manage dependencies (nixpkgs stable/unstable, home-manager)
- Host configurations combine common modules with host-specific settings
- Home Manager handles user-space configuration declaratively
- Modular organization allows for easy extension and reuse

## Common Development Commands

### Initial Setup
```bash
# Setup system symlink and build (first time or new host)
./setup.sh <hostname>

# Setup for existing hostname (auto-detected)
./setup.sh
```

### Building and Testing Configuration  
```bash
# Safe testing with flakes (recommended first step)
sudo nixos-rebuild test --flake .#<hostname>

# Build and switch to new configuration
sudo nixos-rebuild switch --flake .#<hostname>

# Build without switching (for validation)
sudo nixos-rebuild build --flake .#<hostname>

# Quick rebuild using symlinked config (after setup.sh)
sudo nixos-rebuild switch

# Update flake inputs
nix flake update
```

### Home Manager Commands
```bash
# Rebuild home configuration only
home-manager switch --flake .#james

# Check home configuration
home-manager news
```

### Development Tools
```bash
# Search for packages
nix search nixpkgs <package-name>

# Install packages temporarily
nix-shell -p <package-name>

# Check flake
nix flake check

# Show flake info
nix flake show
```

## Configuration Management Patterns

- **Flakes-based**: Uses Nix flakes for reproducible builds and dependency management
- **Modular architecture**: Common configurations shared between hosts via `hosts/common/`
- **Home Manager integration**: User-space configuration managed declaratively
- **Hardware separation**: Auto-generated `hardware-configuration.nix` should not be manually edited
- **Mixed package sources**: Uses both stable (25.05) and unstable nixpkgs
- **Symlinked integration**: System config directory symlinked to `/etc/nixos` via `setup.sh`

## Current Hosts

- **macbook**: MacBook configuration
- **bajie** (s14): S14 laptop configuration - maps to `hosts/s14/` directory

Both hosts share:
- **NixOS Version**: 25.05 (Warbler) 
- **Audio**: PipeWire with full audio stack
- **Desktop**: Hyprland window manager with comprehensive theming
- **Development**: Neovim with LSP, tmux, git configuration
- **User**: james (normal user with wheel access)

## Development Workflow

1. Test configuration changes with `sudo nixos-rebuild test --flake .#<hostname>`
2. Use `./setup.sh` for initial setup or when adding new hosts
3. For new hosts: 
   - Create `hosts/<hostname>/configuration.nix` and `hardware-configuration.nix`
   - Add host entry to `flake.nix` nixosConfigurations
   - Run `./setup.sh <hostname>`
4. Home Manager changes can be tested independently
5. Flake inputs should be updated regularly with `nix flake update`

## Key Files

- `flake.nix` - Main entry point with inputs and host definitions
- `hosts/common/core/default.nix` - Shared system configuration
- `hosts/common/users/james/default.nix` - User account and home-manager integration  
- `home/core.nix` - Base home-manager configuration
- `setup.sh` - Automated system setup and symlinking script
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a traditional NixOS configuration repository with **dynamic host configuration loading**. The main `configuration.nix` automatically detects the system hostname and imports the appropriate host-specific configuration.

**Directory Structure:**
- `configuration.nix` - Main entry point that dynamically loads host configs based on hostname
- `hosts/macbook-air/` - Host-specific configuration files for the MacBook Air system
- `modules/` - Directory for reusable NixOS modules (currently empty, prepared for modular expansion)

**Dynamic Loading System:**
- Reads hostname from `/proc/sys/kernel/hostname`
- Imports `./hosts/${hostname}/configuration.nix` automatically
- Throws helpful error if host configuration doesn't exist

## Common Development Commands

### Building and Testing Configuration
```bash
# Safe testing (recommended first step)
sudo nixos-rebuild test

# Build and switch to new configuration
sudo nixos-rebuild switch

# Build without switching (for validation)
sudo nixos-rebuild build

# Dry run to preview changes
sudo nixos-rebuild dry-build
```

### System Management
```bash
# List system generations
nixos-rebuild list-generations

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Upgrade system packages
sudo nixos-rebuild switch --upgrade
```

### Package Management
```bash
# Search for packages
nix search nixpkgs <package-name>

# Install packages temporarily
nix-shell -p <package-name>
```

## Configuration Management Patterns

- **Host-based organization**: Each system has its own directory under `hosts/`
- **Hardware separation**: Auto-generated `hardware-configuration.nix` should not be manually edited
- **Traditional channels**: Uses standard NixOS channels (not flakes-based)
- **Symlinked integration**: System config directory is symlinked to this user repository

## Current System Configuration

- **NixOS Version**: 25.05 (Warbler)
- **Desktop Environment**: GNOME with GDM, auto-login enabled for user 'james'
- **Security**: LUKS full-disk encryption configured
- **Audio**: PipeWire audio system
- **Kernel**: Latest Linux kernel (6.16.4)
- **Locale**: UK keyboard layout with Mac variant

## Development Workflow

1. Always test configuration changes with `nixos-rebuild test` before switching
2. The system currently has 2 generations - rollback is available if needed
3. Configuration files are located in `/home/james/nixos-config/hosts/${hostname}/`
4. To add a new host: create `./hosts/new-hostname/configuration.nix` and set `networking.hostName = "new-hostname"`
5. The main `configuration.nix` handles dynamic loading - no manual imports needed
6. Unfree packages are enabled in the current configuration

## Key Files

- `configuration.nix` - Main entry point with dynamic host loading
- `hosts/macbook-air/configuration.nix` - MacBook Air system configuration
- `hosts/macbook-air/hardware-configuration.nix` - Auto-generated hardware config (do not edit manually)
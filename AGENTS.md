# AGENTS.md - Development Guidelines for gibnix

## Build/Test Commands
- **Full system build**: `sudo nixos-rebuild switch --flake .#<hostname>`
- **Test build (safe)**: `sudo nixos-rebuild test --flake .#<hostname>`
- **Validate build**: `sudo nixos-rebuild build --flake .#<hostname>`
- **Home Manager only**: `home-manager switch --flake .#james`
- **Flake check**: `nix flake check`

## Code Style Guidelines

### Nix Files
- **Formatting**: Use `alejandra` (2-space indentation, consistent spacing)
- **Imports**: Group related imports, use relative paths `./path`
- **Packages**: Use `with pkgs;` for package lists, one package per line
- **Attribute sets**: Multi-line for readability, consistent indentation
- **Naming**: Lowercase with hyphens for module names, descriptive variable names

### Lua Files
- **Formatting**: Use `stylua` (2-space indentation, spaces not tabs)
- **Structure**: Follow Neovim plugin conventions, clear function organization
- **Naming**: camelCase for functions, UPPER_CASE for constants

### General
- **Comments**: Minimal, explanatory when needed (avoid obvious comments)
- **Error handling**: Leverage Nix's declarative error handling
- **Modularity**: Keep configurations modular and reusable across hosts
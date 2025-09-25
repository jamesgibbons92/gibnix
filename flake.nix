{
  description = "My NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware/master";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    # username = "james";
    lib = nixpkgs.lib;
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      /*
      desktop = lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/desktop/configuration.nix
          ./common/users.nix
          ./common/packages.nix
        ];
      };
      */
      macbook = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs outputs pkgs-unstable;
        };
        modules = [
          ./hosts/macbook/configuration.nix
          ./hosts/common/core
          ./hosts/common/users/james
        ];
      };
      bajie = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs outputs pkgs-unstable;
        };
        modules = [
          ./hosts/s14/configuration.nix
          ./hosts/common/users/james
        ];
      };
    };
  };
}

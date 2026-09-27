{
  description = "My NixOS Configurations";

  nixConfig = {
    extra-substituters = ["https://nix-cache.gibbo.tech"];
    extra-trusted-public-keys = ["nix-cache.gibbo.tech-1:+5Vna1yXB+Hkz9dbkjjirDr4usupVeS4fW1PAQQA0OI="];
  };

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Pinned to a pre-2026-09 snapshot: slack's linked gtk3/glib libs regressed
    # after that point (GLib-GObject "instance has no handler" crash on start).
    nixpkgs-slack-pin.url = "github:NixOS/nixpkgs/9fbb54b33e91ee4ca368e35a78e0613c720600b3";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    opencode.url = "github:anomalyco/opencode/dev";

    herdr.url = "github:herdrdev/herdr/065ef9d6a531c49fb8bee7e818ef837065b21ee9";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    opencode,
    herdr,
    stylix,
    niri,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    _ = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      bajie = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs outputs opencode herdr;
        };
        modules = [
          stylix.nixosModules.stylix
          niri.nixosModules.niri
          ./hosts/s14/configuration.nix
          ./hosts/common/users/james
        ];
      };
      erlang = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs outputs opencode herdr;
        };
        modules = [
          stylix.nixosModules.stylix
          niri.nixosModules.niri
          ./hosts/erlang/configuration.nix
          ./hosts/common/users/james
        ];
      };
      thinkpad = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs outputs opencode herdr;
        };
        modules = [
          stylix.nixosModules.stylix
          niri.nixosModules.niri
          ./hosts/thinkpad/configuration.nix
          ./hosts/common/users/james
        ];
      };
      wukong = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs outputs opencode herdr;
        };
        modules = [
          stylix.nixosModules.stylix
          niri.nixosModules.niri
          ./hosts/desktop/configuration.nix
          ./hosts/common/core
          ./hosts/common/users/james
        ];
      };
    };
  };
}

{
  description = "My NixOS Configurations";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nixos-wsl.url = "github:nix-community/nixos-wsl/main";

    opencode.url = "github:anomalyco/opencode/dev";

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

    # omanix = {
    #   url = "github:T00fy/omanix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.home-manager.follows = "home-manager";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-wsl,
    opencode,
    stylix,
    niri,
    # omanix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    # username = "james";
    lib = nixpkgs.lib;
    pkgs = import nixpkgs {
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
          inherit inputs outputs opencode;
        };
        modules = [
          stylix.nixosModules.stylix
          ./hosts/macbook/configuration.nix
          ./hosts/common/core
          ./hosts/common/users/james
        ];
      };
      bajie = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs outputs opencode;
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
          inherit inputs outputs opencode;
        };
        modules = [
          stylix.nixosModules.stylix
          nixos-wsl.nixosModules.wsl
          ./hosts/erlang/configuration.nix
          ./hosts/common/users/james
        ];
      };
      wukong = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs outputs opencode;
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

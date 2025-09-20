{
  description = "My NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    # nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    # username = "james";
    lib = nixpkgs.lib;
    # pkgs-unstable = import nixpkgs-unstable {
    #   inherit system;
    #   config.allowUnfree = true;
    # };
    # specialArgs = {inherit pkgs-unstable home-manager username;};
    # homeMgrGlobalCfg = {
    #   home-manager.useGlobalPkgs = true;
    #   home-manager.useUserPackages = true;
    #   home-manager.users.${username} = {
    #     home.stateVersion = "25.05";
    #     programs.home-manager.enable = true;
    #   };
    # };
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
          inherit inputs outputs;
        };
        modules = [
          ./hosts/macbook/configuration.nix
          ./hosts/common/core
          ./hosts/common/users/james
        ];
      };
    };
  };
}

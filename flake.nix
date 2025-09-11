{
  description = "My NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    username = "james";
    lib = nixpkgs.lib;
    specialArgs = {inherit home-manager username;};
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
        inherit system specialArgs;
        modules = [
          ./hosts/macbook/configuration.nix
          ./modules/core.nix
          ./home
        ];
      };
    };
  };
}

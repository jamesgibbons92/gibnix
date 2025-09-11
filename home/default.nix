{ config, pkgs, lib, home-manager, username, ... }:

{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.${username} = {
    home.stateVersion = "25.05";
    programs.home-manager.enable = true;

    imports = [
      ./shell
      ./nvim
      ./git.nix
    ];
  };
}


{ lib, pkgs }:

{
  system =  { ... }: {
    environment.systemPackages = with pkgs; [
      gcc
      vim
      wget
      curl
    ];
  };
  home = { ... }: { };
}

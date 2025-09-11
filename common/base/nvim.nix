{ lib, pkgs }:

{
  system = { ... }: {
    environment.systemPackages = with pkgs; [
      vim
    ];
  };

  home = { ... }: { 
    programs.neovim = {
      enable = true;
    };
  };
}

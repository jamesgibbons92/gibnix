{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./theme.nix
    ./oil.nix
    ./format.nix
    ./telescope.nix
    ./harpoon.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      which-key-nvim
    ];
    extraLuaConfig = lib.mkBefore (builtins.readFile ./lua/init.lua);
  };
}

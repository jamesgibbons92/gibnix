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
    ./lsp.nix
    # ./copilot.nix
    ./sidekick.nix
    ./cmp.nix
    # ./session.nix doesn't work yet
    ./git.nix
    ./mini.nix
    ./which-key.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraLuaConfig = lib.mkBefore (builtins.readFile ./lua/init.lua);
  };
}

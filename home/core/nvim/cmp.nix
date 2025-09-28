{pkgs, ...}: {
  imports = [
    ./copilot.nix
  ];

  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      blink-cmp
      blink-copilot
      friendly-snippets
    ];

    extraLuaConfig = builtins.readFile ./lua/cmp.lua;
  };
}

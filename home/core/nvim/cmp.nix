{pkgs, ...}: {
  imports = [
    ./sidekick.nix
  ];

  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      blink-cmp
      blink-copilot
      friendly-snippets
    ];

    initLua = builtins.readFile ./lua/cmp.lua;
  };
}

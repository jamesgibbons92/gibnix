{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
    ];
    initLua = builtins.readFile ./lua/telescope.lua;
  };
}

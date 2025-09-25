{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
    ];
    extraLuaConfig = builtins.readFile ./lua/telescope.lua;
  };
}

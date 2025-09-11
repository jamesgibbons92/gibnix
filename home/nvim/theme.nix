{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      gruvbox-material
    ];
    extraLuaConfig =
      /*
      lua
      */
      ''
        vim.cmd[[ colorscheme gruvbox-material ]]
      '';
  };
}

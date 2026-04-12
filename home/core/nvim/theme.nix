{pkgs, ...}: {
  stylix.targets.neovim.enable = false;

  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
    ];
    initLua =
      /*
      lua
      */
      ''
        vim.cmd[[ colorscheme tokyonight-night ]]
      '';
  };
}

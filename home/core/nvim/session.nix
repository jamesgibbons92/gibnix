{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      auto-session
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require("auto-session").setup({})
      '';
  };
}

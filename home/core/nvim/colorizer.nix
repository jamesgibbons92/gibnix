{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-colorizer-lua;
        type = "lua";
        config = builtins.readFile ./lua/colorizer.lua;
      }
    ];
  };
}

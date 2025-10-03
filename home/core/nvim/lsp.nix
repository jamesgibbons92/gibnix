{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    bash-language-server
    gopls
    lua-language-server
    copilot-language-server
    nil
    vtsls
    alejandra
  ];

  programs.neovim = {
    plugins = with pkgs-unstable.vimPlugins; [
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./lua/lsp.lua;
      }
    ];
  };
}

{pkgs, ...}: {
  home.packages = with pkgs; [
    pkgs.stylua # lua
    pkgs.alejandra # nix
  ];
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      conform-nvim
    ];
    extraLuaConfig =
      /*
      lua
      */
      ''
        require("conform").setup({
          formatters_by_ft = {
            lua = { "stylua" },
            nix = { "alejandra" },
          },
          formatters = {
            stylua = {
              args = { "--indent-width", "2", "--indent-type", "Spaces", "-" },
            }
          },
          format_on_save = {
            timeout_ms = 500,
            lsp_format = "fallback",
          },
        })
        vim.keymap.set("n", "<leader>f", function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end, { desc = "[F]ormat buffer" })
      '';
  };
}

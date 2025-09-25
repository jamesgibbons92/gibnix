{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      oil-nvim
    ];
    extraLuaConfig =
      /*
      lua
      */
      ''
        require("oil").setup({
          skip_confirm_for_simple_edits = true,
          view_options = {
            show_hidden = true,
          },
        })
        vim.keymap.set("n", "<leader>e", function()
          require("oil").open_float()
        end, { desc = "Open Oil in float" })
      '';
  };
}

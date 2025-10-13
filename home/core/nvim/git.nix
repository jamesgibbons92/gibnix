{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      git-blame-nvim
    ];
    extraLuaConfig = ''
      require('gitblame').setup({
        enabled = false,
        date_format = '%c',
        virtual_text_column = 1,
        message_template = '<author> - <date>'
      })

      vim.keymap.set("n", "<leader>go", function() vim.cmd('GitBlameOpenFileURL') end, { desc = "[G]it blame [o]pen URL" })
      vim.keymap.set("n", "<leader>gt", function() vim.cmd('GitBlameToggle') end, { desc = "[G]it blame [t]oggle" })
    '';
  };
}

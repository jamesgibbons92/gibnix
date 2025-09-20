{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      harpoon
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "[H]arpoon [a]dd" })
        vim.keymap.set("n", "<leader>hl", ui.toggle_quick_menu, { desc = "[H]arpoon [l]ist" })
        vim.keymap.set("n", "<C-1>", function() ui.nav_file(1) end)
        vim.keymap.set("n", "<C-2>", function() ui.nav_file(2) end)
        vim.keymap.set("n", "<C-3>", function() ui.nav_file(3) end)
        vim.keymap.set("n", "<C-4>", function() ui.nav_file(4) end)
      '';
  };
}

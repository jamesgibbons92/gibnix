{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      persistence-nvim
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require("persistence").setup({})

        -- Load the session for the current directory
        vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "Load [q]uick [s]ession" })

        -- Select a session to load
        vim.keymap.set("n", "<leader>qS", function() require("persistence").select() end, { desc = "Select [q]uick [S]ession" })

        -- Load the last session
        vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Load [q]uick [l]ast session" })

        -- Stop Persistence => session won't be saved on exit
        vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "[Q]uit session [d]isable" })

        -- Auto-load last session on startup
        vim.api.nvim_create_autocmd("VimEnter", {
          group = vim.api.nvim_create_augroup("persistence", { clear = true }),
          nested = true,
          callback = function()
            -- Only load the session if nvim was started with no arguments
            if vim.fn.argc() == 0 then
              -- Defer loading to ensure all plugins are loaded
              vim.defer_fn(function()
                require("persistence").load({ last = true })
              end, 10)
            end
          end,
        })
      '';
  };
}

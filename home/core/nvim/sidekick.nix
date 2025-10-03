{pkgs, ...}: {
  programs.neovim = {
    plugins = with pkgs; [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "sidekick.nvim";
        version = "2025-10-02";
        src = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "sidekick.nvim";
          rev = "8ebbd7578bcdd345b81ab0d3e6776133d6b0d140";
          sha256 = "sha256-J1ZxbXPQXiahxhJol6F1gtPbqP0YeWinFEsyvrTQLxk";
        };
        doCheck = false;
        meta.homepage = "https://github.com/folke/sidekick.nvim/";
        meta.hydraPlatforms = [];
      })
    ];

    extraLuaConfig =
      /*
      lua
      */
      ''
        require("sidekick").setup({
          cli = {
            win = {
              mux = {
                backend = "tmux",
                enabled = false,
             },
            },
          },
        })
        vim.keymap.set('n', '<leader>aa', function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end, { desc = 'Sidekick Opencode' })
        vim.keymap.set({ "n", "x", "i", "t" }, '<C-_>', function() require("sidekick.cli").focus() end, { desc = 'Sidekick Toggle Focus' })
        vim.keymap.set({ "x", "n" }, "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end, { desc = 'Send this' })
        vim.keymap.set('x', "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end, { desc = "Send Selection" })
        vim.keymap.set({ "x", "n" }, "<leader>ap", function() require("sidekick.cli").prompt() end, { desc = "Select prompt" })
        vim.keymap.set('n', "<tab>", function() if not require("sidekick").nes_jump_or_apply() then return "<Tab>" end end, { desc = "Goto/apply next edit" })
      '';
  };
}

{pkgs, ...}: {
  home.packages = with pkgs; [
    nil

    alejandra
  ];

  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          -- Setup nil LSP for Nix
          require('lspconfig').nil_ls.setup({
            autostart = true,
            capabilities = vim.lsp.protocol.make_client_capabilities(),
            settings = {
              ['nil'] = {
                testSetting = 42,
                formatting = {
                  command = { "alejandra" },
                },
              },
            },
          })

          -- LSP Keybindings
          vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
              local opts = { buffer = ev.buf }

              -- Navigation
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = '[G]oto [D]efinition' })
              vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = ev.buf, desc = '[G]oto [D]eclaration' })
              vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = ev.buf, desc = '[G]oto [I]mplementation' })
              vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, desc = '[G]oto [R]eferences' })
              vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, desc = 'Hover Documentation' })
              vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = ev.buf, desc = 'Signature Help' })

              -- Code actions
              vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = ev.buf, desc = '[C]ode [A]ction' })
              -- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = ev.buf, desc = '[R]e[n]ame' })

              -- Diagnostics
              -- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { buffer = ev.buf, desc = 'Show Diagnostic [E]rror Messages' })
              vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { buffer = ev.buf, desc = 'Go to Previous [D]iagnostic Message' })
              vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { buffer = ev.buf, desc = 'Go to Next [D]iagnostic Message' })
              vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { buffer = ev.buf, desc = 'Open Diagnostic [Q]uickfix List' })
            end,
          })

          -- Diagnostic configuration
          vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
          })

          -- Show diagnostic signs in the sign column
          local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
          for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
          end
        '';
      }
    ];
  };
}

-- copilot
vim.lsp.enable("copilot")
-- Nix LSP
vim.lsp.config("nil_ls", {
  autostart = true,
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  settings = {
    ["nil"] = {
      testSetting = 42,
      formatting = {
        command = { "alejandra" },
      },
    },
  },
})
vim.lsp.enable("nil_ls")
------- Lua LSP
vim.lsp.config("lua_ls", {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath("config")
        and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
        -- library = vim.api.nvim_get_runtime_file("", true)
      },
    })
  end,
  settings = {
    Lua = {},
  },
})
vim.lsp.enable("lua_ls")
-- GO LSP
-- vim.lsp.config("gopls")
vim.lsp.enable("gopls")
-- TS / JS LSP
vim.lsp.enable("vtsls")
-- LSP Keybindings
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Detach copilot LSP for .env files
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == "copilot_ls" and vim.fn.expand("%"):match("%.env") then
      vim.lsp.stop_client(ev.data.client_id)
      return
    end

    local opts = { buffer = ev.buf }

    -- Navigation
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "[G]oto [D]efinition" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "[G]oto [D]eclaration" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "[G]oto [I]mplementation" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "[G]oto [R]eferences" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover Documentation" })
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Signature Help" })

    -- Code actions
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "[C]ode [A]ction" })
    -- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = ev.buf, desc = '[R]e[n]ame' })

    -- Diagnostics
    -- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { buffer = ev.buf, desc = 'Show Diagnostic [E]rror Messages' })
    vim.keymap.set(
      "n",
      "[d",
      vim.diagnostic.goto_prev,
      { buffer = ev.buf, desc = "Go to Previous [D]iagnostic Message" }
    )
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = ev.buf, desc = "Go to Next [D]iagnostic Message" })
    vim.keymap.set(
      "n",
      "<leader>q",
      vim.diagnostic.setloclist,
      { buffer = ev.buf, desc = "Open Diagnostic [Q]uickfix List" }
    )
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

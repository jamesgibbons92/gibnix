{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      mini-pairs
      mini-surround
    ];
    initLua = ''
      -- Disable default 's' (substitute) command to avoid conflicts
      vim.keymap.set('n', 's', '<Nop>')
      vim.keymap.set('x', 's', '<Nop>')

      require('mini.pairs').setup()
      require('mini.surround').setup({})
    '';
  };
}

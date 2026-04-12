{
  pkgs,
  opencode,
  ...
}: {
  imports = [
    ./shell
    ./nvim
    ./git.nix
  ];

  home.stateVersion = "25.05";

  # Adopt new default: GTK4 theme no longer inherits from gtk.theme
  gtk.gtk4.theme = null;

  home.packages = [
    pkgs.vim
    pkgs.wget
    pkgs.curl
    pkgs.fastfetch
    pkgs.jq

    pkgs.ripgrep

    pkgs.claude-code
    # opencode.packages.${pkgs.system}.default
    pkgs.opencode

    pkgs.bitwarden-cli
  ];

  programs.btop = {
    enable = true;
    settings = {
      theme_background = true;
      update_ms = 500;
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    # addKeysToAgent = "yes";
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
      };
    };
  };

  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    mcp = {
      context7 = {
        type = "remote";
        url = "https://mcp.context7.com/mcp";
        headers = {
          CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
        };
      };
    };
  };
}

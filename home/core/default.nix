{
  pkgs,
  opencode,
  herdr,
  ...
}: {
  imports = [
    ./shell
    ./nvim
    ./git.nix
  ];

  home.stateVersion = "25.05";

  home.packages = [
    pkgs.vim
    pkgs.wget
    pkgs.curl
    pkgs.fastfetch
    pkgs.jq
    pkgs.dig

    pkgs.ripgrep

    pkgs.claude-code
    # opencode.packages.${pkgs.system}.default
    pkgs.opencode
    herdr.packages.${pkgs.system}.default

    pkgs.bitwarden-cli
    pkgs.nethogs
  ];

  programs.btop = {
    enable = true;
    settings = {
      theme_background = true;
      update_ms = 500;
    };
  };

  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        AddKeysToAgent = "yes";
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

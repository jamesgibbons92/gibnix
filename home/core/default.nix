{
  pkgs,
  pkgs-unstable,
  opencode,
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

    pkgs.ripgrep

    pkgs.claude-code
    opencode.packages.${pkgs.system}.default

    pkgs.bitwarden-cli
  ];

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark";
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
}

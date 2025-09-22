{
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    ./shell
    ./nvim
    ./git.nix

    ./desktop # testing for now
  ];

  home.stateVersion = "25.05";

  home.packages = [
    pkgs.vim
    pkgs.wget
    pkgs.curl
    pkgs.fastfetch
    pkgs.xclip #move this to de setup

    pkgs.ripgrep

    pkgs.claude-code
    pkgs-unstable.opencode

    pkgs.bitwarden-cli

    pkgs.spotify-player
  ];
}

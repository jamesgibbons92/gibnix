{pkgs, ...}: {
  imports = [
    ./shell
    ./nvim
    ./git.nix

    ./desktop # testing for now
  ];

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    vim
    wget
    curl
    fastfetch
    xclip #move this to de setup

    ripgrep

    claude-code

    bitwarden-cli
  ];
}

{pkgs, ...}: {
  imports = [
    ./virtualisation.nix
    ./database.nix
    ./aws.nix
    ./javascript.nix
    ./go.nix
  ];

  home.packages = with pkgs; [
    devenv
  ];
}

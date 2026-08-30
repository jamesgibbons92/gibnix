{pkgs, ...}: {
  imports = [
    ./virtualisation.nix
    ./database.nix
    ./aws.nix
    ./javascript.nix
    ./go.nix
    ./godot.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    devenv
  ];
}

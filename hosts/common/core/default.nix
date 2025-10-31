{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./locale.nix
    # system packages/programs...
  ];

  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
  };

  programs.zsh.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
  };

  nixpkgs = {
    # overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  environment.systemPackages = with pkgs; [
    gcc
    gnumake
  ];

  programs.dconf.enable = true;
  programs.nix-ld.enable = true;
  nix.settings = {
    trusted-users = ["root" "james"];
    experimental-features = ["nix-command" "flakes"];
  };
}

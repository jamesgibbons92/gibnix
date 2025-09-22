{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    # system packages/programs...
  ];

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

  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
    # pipewire
    # wireplumber
    sof-firmware
    pavucontrol
    bluez
    blueman
    playerctl
    brightnessctl
    kdePackages.dolphin # move to de module
  ];

  programs.dconf.enable = true;

  nix.settings.experimental-features = ["flakes" "nix-command"];
}

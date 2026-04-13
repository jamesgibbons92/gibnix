# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common/core
    ../common/optional/wireless.nix
    ../common/optional/audio.nix
    ../common/optional/virtualisation.nix
    ../common/optional/vpn.nix
    ../common/optional/gaming.nix
    ../common/optional/sync.nix
    ../common/optional/logseq.nix
    ../common/optional/printing.nix
    ../common/optional/niri.nix
    ../common/optional/obs.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "wukong";

  # Configure network connections interactively with nmcli or nmtui.
  system.stateVersion = "25.11"; # Did you read the comment?
}

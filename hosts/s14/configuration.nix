# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    "${inputs.nixos-hardware}/common/cpu/intel/lunar-lake"
    ../common/core
    ../common/optional/wireless.nix
    ../common/optional/audio.nix
    ../common/optional/virtualisation.nix
    ../common/optional/vpn.nix
    ../common/optional/gaming.nix
  ];

  # nixpkgs.overlays = [inputs.self.overlays.alsa-ucm-conf-unstable];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "bajie"; # Define your hostname.

  services.xserver.xkb = {
    layout = "gb";
    variant = "intl";
  };

  console.keyMap = "uk";

  services.printing.enable = true;
  environment.systemPackages = [
    pkgs.asusctl
    pkgs-unstable.alsa-ucm-conf
  ];

  systemd.user.services.pipewire.environment.ALSA_CONFIG_UCM = "${pkgs-unstable.alsa-ucm-conf}/share/alsa/ucm";
  systemd.user.services.pipewire.environment.ALSA_CONFIG_UCM2 = "${pkgs-unstable.alsa-ucm-conf}/share/alsa/ucm2";
  systemd.user.services.wireplumber.environment.ALSA_CONFIG_UCM = "${pkgs-unstable.alsa-ucm-conf}/share/alsa/ucm";
  systemd.user.services.wireplumber.environment.ALSA_CONFIG_UCM2 = "${pkgs-unstable.alsa-ucm-conf}/share/alsa/ucm2";

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
      asusdConfig = {
        text = ''
          (
              charge_control_end_threshold: 80,
              disable_nvidia_powerd_on_battery: true,
              ac_command: "",
              bat_command: "",
              platform_profile_linked_epp: true,
              platform_profile_on_battery: Quiet,
              change_platform_profile_on_battery: true,
              platform_profile_on_ac: Performance,
              change_platform_profile_on_ac: true,
              profile_quiet_epp: Power,
              profile_balanced_epp: BalancePower,
              profile_custom_epp: Performance,
              profile_performance_epp: Performance,
              ac_profile_tunings: {},
              dc_profile_tunings: {
                  Quiet: (
                      enabled: false,
                      group: {},
                  ),
              },
              armoury_settings: {},
          )
        '';
      };
    };
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
